function [C_mat, f, S_mat] = ...
    pcohmat(X, tapers, sampling, fk, pad, flag) 
% PCOHMAT calculates the coherency matrix for a set of time series on a cluster.
%
% [C_MAT, F, S_MAT] = ...
%	PCOHMAT(X, TAPERS, SAMPLING, FK, PAD, FLAG)
%
%  Inputs:  X		=  Time series array in [Trials,Channel,Time] or
%				[Channels,Time] form.
%	    TAPERS 	=  Data tapers in [K,TIME], [N,P,K] or [N, W] form.
%			   	Defaults to [N,5,9] where N is the duration 
%				of X and Y.
%	    SAMPLING 	=  Sampling rate of time series X, in Hz. 
%				Defaults to 1.
%	    FK 	 	=  Frequency range to return in Hz in
%                               either [F1,F2] or [F2] form.  
%                               In [F2] form, F1 is set to 0.
%			   	Defaults to [0,SAMPLING/2]
%	    PAD		=  Padding factor for the FFT.  
%			      	i.e. For N = 500, if PAD = 2, we pad the FFT 
%			      	to 1024 points; if PAD = 4, we pad the FFT
%			      	to 2048 points.
%				Defaults to 2.
%
%	   FLAG = 0:	calculate C_MAT seperately for each channel/trial.
%	   FLAG = 1:	calculate C_MAT by pooling across channels/trials. 
%	   	Defaults to FLAG = 1.
%
%  Outputs: C_MAT        =  Coherency of X in [Chan,Chan,Freq] form.
%	     F	       =  Units of Frequency axis.
%	    S_MAT	       =  Spectrum of X in [Channels/Trials,Freq] form.
%

%  Written by:  Bijan Pesaran Caltech 1998
%

sX = size(X);
if length(sX) == 3
	nt = sX(3);
	nch = sX(2);
	ntrials = sX(1);
end
if length(sX) == 2
	nt = sX(2);
	nch = sX(1);
end

if nch < 2 error('X must have at least two channels'); end

if nargin < 3 sampling = 1; end 
nt = nt./sampling;
if nargin < 2 tapers = [nt, 5, 9]; end 
if length(tapers) == 2
   n = tapers(1);
   w = tapers(2);
   p = n*w;
   k = floor(2*p-1);
   tapers = [n,p,k];
   disp(['Using ' num2str(k) ' tapers.']);
end
if length(tapers) == 3  
   tapers(1) = tapers(1).*sampling;  
   tapers = dpsschk(tapers); 
end
if nargin < 4 fk = [0,sampling./2]; end
if length(fk) == 1
    fk = [0,fk];
end
if nargin < 5 pad = 2; end
if nargin < 6 flag = 1; end 

K = length(tapers(1,:)); 
N = length(tapers(:,1));
if N ~= nt.*sampling
  error('Error: Tapers and time series not the same length'); 
end

nf = max(256, pad*2^nextpow2(N+1)); 
nfk = floor(fk./sampling.*nf);
f = linspace(fk(1),fk(2),diff(nfk));

neid = PMI_Size;
eid = [1:neid];

disp('Sending tapers to all nodes');
for id = 1:neid
    status = PMI_Send2(eid(id),tapers);
end

if length(sX) == 2	%  Single trial
    disp('Single trial');
    C_mat = zeros(nch,nch,diff(nfk));
%     S_mat = zeros(nch,diff(nfk));
    id = 0; allsent = 0; t=0;
    for ch1 = 2:nch  %  Looping across channels
        tic; X1 = X(ch1,:); 
        disp(['Channel ' num2str(ch1) ' Time ' num2str(t) ' s']);
        for ch2 = 1:ch1-1
            X2 = X(ch2,:); 
            disp(['Channel 2 is ' num2str(ch2)]);
            id = id+1;
            nodes(id,:) = [ch1,ch2];
            status = PMI_Send2(eid(id),X1);
            status = PMI_Send2(eid(id),X2);
            cmd = ['[cohtemp] = coherency(X1, X2, tapers, ' num2str(sampling) ...
                    ',[' num2str(fk(1)) ',' num2str(fk(2)) ...
                    '],' num2str(pad) ',' num2str(flag) ');'];    
            status = PMI_IEval(eid(id),cmd);
            if status disp(['Node ' num2str(eid(id)) ' received command OK']); end
            if (ch1 == nch & ch2 == ch1-1)
                allsent = 1;
                neid = id;
            end
            disp(['Allsent is ' num2str(allsent)]);
            if ((id == neid) | allsent)
                disp('Collecting from nodes')
                for Rid = 1:neid
                    disp(['  Coherency from Node ' num2str(Rid)]);
                    [cohtemp] = PMI_Recv(eid(Rid),'cohtemp');
                    %disp(['  Spectrum from Node ' num2str(Rid)]);
                    %[s_xtemp] = PMI_Recv(eid(Rid),'s_xtemp');
                    C_mat(nodes(Rid,1),nodes(Rid,2),:) = cohtemp;
                    C_mat(nodes(Rid,2),nodes(Rid,1),:) = cohtemp';
                    %S_mat(ch1spot,:) = s_xtemp;
                end
                id = 0;
            end
        end    
        t = toc;
    end
end


if length(sX) == 3		%  Multiple trials
    disp('Multiple trials');
    id = 0; allsent = 0; t=0;
    if flag			%  Pooling across trials
        cmd = ['[cohtemp] = coherency(X1, X2, tapers, ' num2str(sampling) ...
                ',[' num2str(fk(1)) ',' num2str(fk(2)) ...
                '],' num2str(pad) ',' num2str(flag) ');'];    
        disp('Pooling across trials');
        C_mat = zeros(nch,nch,diff(nfk));
        %     S_mat = zeros(nch,diff(nfk));
        for ch1 = 2:nch
            tic;
            X1 = squeeze(X(:,ch1,:));
            disp(['Channel ' num2str(ch1) ' Time ' num2str(t) ' s']);
            for ch2 = 1:ch1
                X2 = squeeze(X(:,ch2,:));
                id = id+1;
                nodes(id,:) = [ch1,ch2];
                status = PMI_Send2(eid(id),X1);
                status = PMI_Send2(eid(id),X2);
                status = PMI_IEval(eid(id),cmd);
                if status disp(['Node ' num2str(eid(id)) ' received command OK']); end
                if (ch1 == nch & ch2 == ch1-1)
                    allsent = 1;
                    neid = id;
                end
                %         disp(['Allsent is ' num2str(allsent)]);
                if ((id == neid) | allsent)
                    %             disp('Collecting from nodes')
                    for Rid = 1:neid
                        %                 disp(['  Coherency from Node ' num2str(Rid)]);
                        [cohtemp] = PMI_Recv(eid(Rid),'cohtemp');
                        %disp(['  Spectrum from Node ' num2str(Rid)]);
                        %[s_xtemp] = PMI_Recv(eid(Rid),'s_xtemp');
                        C_mat(nodes(Rid,1),nodes(Rid,2),:) = cohtemp;
                        C_mat(nodes(Rid,2),nodes(Rid,1),:) = conj(cohtemp);
                        %S_mat(ch1spot,:) = s_xtemp;
                    end
                    id = 0;
                end
            end
            t = toc;    
        end
    end
    if ~flag			%  No pooling across trials        
        cmd = ['[cohtemp] = coherency(X1, X2, tapers, ' num2str(sampling) ...
                ',[' num2str(fk(1)) ',' num2str(fk(2)) ...
                '],' num2str(pad) ',' num2str(flag) ');'];    
        disp('No pooling across trials');
        C_mat = zeros(nch,nch,ntrials,diff(nfk));
        %S_mat = zeros(nch,ntrials,diff(nfk));
        for ch1 = 2:nch
            tic;
            X1 = sq(X(:,ch1,:));        
            disp(['Channel ' num2str(ch1) ' Time ' num2str(t) ' s']);
            for ch2 = 1:ch1-1
                X2 = sq(X(:,ch2,:));
                %         disp(['Channel 2 is ' num2str(ch2)]);
                id = id+1;
                nodes(id,:) = [ch1,ch2];
                status = PMI_Send2(eid(id),X1);
                status = PMI_Send2(eid(id),X2);
                status = PMI_IEval(eid(id),cmd);
                if status disp(['Node ' num2str(eid(id)) ' received command OK']); end
                if (ch1 == nch & ch2 == ch1-1)
                    allsent = 1;
                    neid = id;
                end
                %         disp(['Allsent is ' num2str(allsent)]);
                if ((id == neid) | allsent)
                    %             disp('Collecting from nodes')
                    for Rid = 1:neid
                        %                 disp(['  Coherency from Node ' num2str(Rid)]);
                        [cohtemp] = PMI_Recv(eid(Rid),'cohtemp');
                        %disp(['  Spectrum from Node ' num2str(Rid)]);
                        %[s_xtemp] = PMI_Recv(eid(Rid),'s_xtemp');
                        C_mat(nodes(Rid,1),nodes(Rid,2),:,:) = cohtemp;
                        C_mat(nodes(Rid,2),nodes(Rid,1),:,:) = conj(cohtemp);
                        %S_mat(ch1spot,:) = s_xtemp;
                    end
                    id = 0;
                end
            end         %  End Channel 2 loop
            t = toc;    
        end             %  End Channel 1 loop
    end
end

for i = 1:neid
    PMI_IEval(eid(i),'clear');
end
