function [x, u, L, Vx, Vxx, cost, trace, stop, timing] = iLQG(DYNCST, x0, u0, Op)
% iLQG - solve the deterministic finite-horizon optimal control problem.
%
%		minimize sum_i CST(x(:,i),u(:,i)) + CST(x(:,end))
%			u
%		s.t.  x(:,i+1) = DYN(x(:,i),u(:,i))
% 
% Inputs
% ======
% DYNCST - a combined dynamics and cost function. It is called in
% three different formats. 
%
% step:
% [xnew,cnew] = DYNCST(x,u,i) is called during the forward pass. Here x, 
% u and xnew are vectors, and cnew and i (the time index) are scalars.
%
% final:
% [~,cnew] = DYNCST(x,nan) is called at the end the forward pass to compute
% the final cost. The nan input indicates that no controls are used.
%
% derivatives:
% [~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu] = DYNCST(x,u,I) computes the
% derivatives along the trajectory. In this case size(x)==[n N+1] where N 
% is the trajectory length. size(u)==[m N+1] with NaNs in the last column
% to indicate final-cost. The time indexes are always I=(1:N)
%
% x0 - the initial state from which to solve the control problem. x0
% should be a column vector
%
% u0 - the initial control sequence. It is a matrix of size(u0)==[m N]
% where m is the dimension of the control and N is the number of state 
% transitions. 
%
% Op - optional parameters, see below
%
% Outputs
% =======
% x - the optimal state trajectory found by the algorithm.
%     size(x)==[n N+1]
%
% u - the optimal open-loop control sequence.
%     size(u)==[m N]
%
% L - the optimal closed loop control gains. These gains multiply the
%     deviation of a simulated trajectory from the nominal trajectory x.
%     size(L)==[m n N]
%
% Vx - the gradient of the Value. size(Vx)==[n N+1]
%
% Vxx - the Hessian of the Value. size(Vxx)==[n n N+1]
%
% cost - the costs along the trajectory. size(cost)==[1 N+1]
%        the cost-to-go is V = fliplr(cumsum(fliplr(cost))) 
%
% lambda - the final value of the regularization parameter
%
% trace - a trace of various convergence-related values. One row for each
%		  iteration, the columns of trace are
%		  [iter lambda alpha g_norm dcost z sum(cost) dlambda]
%         see below foe details.
%
% timing - timing information

%---------------------- user-adjustable parameters ------------------------
defaults = {'lims',           [],...
            'cost',           [],...            initial cost
            'lambdaInit',     1,...            initial value for lambda
            'dlambdaInit',    1,...             initial value for dlambda
            'lambdaFactor',   1.6,...           lambda "second derivative"
            'lambdaMax',      1e10,...          lambda maximum value
            'lambdaMin',      1e-6,...          below this value lambda = 0      
            'regType',        1,...             regularization type 1: q_uu+lambda*eye(); 2: V_xx+lambda*eye()
            'searchType',     1,...             1: backtracking;  2: parallel
            'zMin',           0,...             minimal accepted reduction ratio
            'tolFun',         1e-11,...          reduction exit criterion
            'tolGrad',        1e-9,...          gradient exit criterion
            'maxIter',        500,...           maximum iterations
            'Alpha',          10.^linspace(0,-3,8),... backtracking coefficients
            'plot',           1,...             0: no;  k>0: every k iters; k<0: every k iters, with derivs window
            'print',          2,...             0: no;  1: final; 2: iter; 3: iter, detailed
            'F_PASS',         nan,...           fast implementation of forward_pass
            'plotFn',         @(x)0,...			user-defined graphics callback
            };

% --- initial sizes and controls
n        = size(x0, 1);          % size of state vector
m        = size(u0, 1);          % size of control vector
N        = size(u0, 2);          % number of time steps
u        = u0;                   % initial control sequence         
         
% --- proccess options          
if nargin < 4,
   Op = struct();
end
Op  = setOpts(defaults,Op);

verbosity = Op.print;
      
switch numel(Op.lims)
   case {0,2*m}
   case 2
      Op.lims = ones(m,1)*Op.lims(:)';
   case m
      Op.lims = Op.lims(:)*[-1 1];
   otherwise
      error('limits are of the wrong size')
end

if isa(Op.F_PASS,'function_handle')
   forward_pass   = Op.F_PASS;
else
   forward_pass   = @(x0,u,L,x) f_pass(x0,u,L,x,DYNCST,Op.lims);
end

lambda   = Op.lambdaInit;
dlambda  = Op.dlambdaInit;

% --- forward simulation of initial trajectory
if size(x0,2) == 1
   for alpha = Op.Alpha
      [diverge,x,un,cost]  = forward_pass(x0(:,1),alpha*u,[],[]);
      if ~diverge
         u = un;
         break
      end
   end
else % already did initial fpass
   x        = x0;
   diverge  = false;
   cost     = Op.cost;
end

Op.plotFn(x);

if diverge
   [Vx,Vxx, stop, fx]  = deal(nan);
   L        = zeros(m,n,N);
   cost     = [];
   timing   = [0 0 0 0];
   trace    = [1    lambda nan   nan    nan   nan sum(cost(:)) dlambda];
   if verbosity > 0
      fprintf('\nEXIT: Initial control sequence caused divergence\n');
   end
   return
end

flgChange   = 1;
t_total     = tic;
diff_t      = 0;
back_t      = 0;
fwd_t       = 0;
stop        = 0;
dcost       = 0;
z           = 0;
expected    = 0;
trace       = zeros(min(Op.maxIter,1e6),8);
trace(1,:)  = [1    lambda nan   nan    nan   nan sum(cost(:)) dlambda];
			 %[iter lambda alpha g_norm dcost z   sum(cost)    dlambda];
L           = zeros(m,n,N);
graphics(Op.plot,x,u,cost,L,[],[],[],[],[],[],trace(1,:),1);
if verbosity > 0
   fprintf('\n=========== begin iLQG ===========\n');
end
for iter = 1:Op.maxIter
   if stop
      break;
   end

   %====== STEP 1: differentiate dynamics and cost along new trajectory
   if flgChange
      t_diff = tic;
      [~,~,fx,fu,fxx,fxu,fuu,cx,cu,cxx,cxu,cuu]   = DYNCST(x, [u nan(m,1)], 1:N+1);
      diff_t = diff_t + toc(t_diff);
      flgChange   = 0;
   end
   
   %====== STEP 2: backward pass, compute optimal control law and cost-to-go
   backPassDone   = 0;
   while ~backPassDone
      
      t_back   = tic;
      [diverge, Vx, Vxx, l, L, dV] = back_pass(cx,cu,cxx,cxu,cuu,fx,fu,fxx,fxu,fuu,lambda,Op.regType,Op.lims,u);
      back_t   = back_t + toc(t_back);
      
      if diverge
         if verbosity > 2
            fprintf('Cholesky failed at timestep %d.\n',diverge);
         end
         dlambda   = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
         lambda    = max(lambda * dlambda, Op.lambdaMin);           
         if lambda > Op.lambdaMax
            break;
         end
         continue
      end
      backPassDone      = 1;
   end
   % check for termination due to small gradient
   g_norm         = mean(max(abs(l) ./ (abs(u)+1),[],1));
   trace(iter,[1 4 7])  = [iter g_norm nan];
   if g_norm < Op.tolGrad && lambda < 1e-5
      dlambda   = min(dlambda / Op.lambdaFactor, 1/Op.lambdaFactor);
      lambda    = lambda * dlambda * (lambda > Op.lambdaMin);      
      trace(iter,[2 8])  = [lambda dlambda];
      if verbosity > 0
         fprintf('\nSUCCESS: gradient norm < tolGrad\n');
      end
      break;
   end    
   
   %====== STEP 3: line-search to find new control sequence, trajectory, cost
   fwdPassDone  = 0;
   if backPassDone
      t_fwd = tic;
		for alpha = Op.Alpha
		   [diverge,xnew,unew,costnew]   = forward_pass(x0 ,u+l*alpha, L, x(:,1:N));
		   dcost    = sum(cost(:)) - sum(costnew(:)) - 1e10*diverge;
		   expected = max(-alpha*(dV(1) + alpha*dV(2)), 0);
		   z        = dcost/expected;
		   if (z > Op.zMin) 
			  fwdPassDone = 1;
			  break;
		   end 
		end                             
      fwd_t = fwd_t + toc(t_fwd);
   end
   
   %====== STEP 4: accept (or not), draw graphics
   if fwdPassDone
      
      % print status
      if verbosity > 1
         fprintf('iter: %-3d  cost: %-9.6g  reduc: %-9.3g  gradient: %-9.3g  log10lam: %3.1f\n', ...
            iter, sum(cost(:)), dcost, g_norm, log10(lambda));     
      end            
      
      % decrease lambda
      dlambda   = min(dlambda / Op.lambdaFactor, 1/Op.lambdaFactor);
      lambda    = lambda * dlambda * (lambda > Op.lambdaMin);
      
      % accept changes
      u              = unew;
      x              = xnew;
      cost           = costnew;
      flgChange      = 1;
      Op.plotFn(x);
      
      % update trace
      trace(iter,:)  = [iter lambda alpha g_norm dcost z sum(cost(:)) dlambda];
      
      % terminate ?
      if dcost < Op.tolFun
         if verbosity > 0
            fprintf('\nSUCCESS: cost change < tolFun\n');
         end
         break;
      end      
      
   else % no cost improvement
      % increase lambda
      dlambda  = max(dlambda * Op.lambdaFactor, Op.lambdaFactor);
      lambda   = max(lambda * dlambda, Op.lambdaMin);  
      
      % print status
      if verbosity > 1
         fprintf('iter: %-3d  REJECTED    expected: %-11.3g    actual: %-11.3g    log10lam: %3.1f\n',...
                  iter,expected ,dcost, log10(lambda));
      end

      % update trace
      trace(iter,:)  = [iter lambda nan g_norm dcost z sum(cost(:)) dlambda];      
      
      % terminate ?
      if lambda > Op.lambdaMax,
         if verbosity > 0
            fprintf('\nEXIT: lambda > lambdaMax\n');
         end
         break;
      end
   end
   stop           = graphics(Op.plot,x,u,cost,L,Vx,Vxx,fx,fxx,fu,fuu,trace(1:iter,:),0);   
end

if stop
   if verbosity > 0
      fprintf('\nEXIT: Terminated by user\n');
   end
end

if iter == Op.maxIter
   if verbosity > 0
      fprintf('\nEXIT: Maximum iterations reached.\n');
   end
end


if ~isempty(iter)
   total_t = toc(t_total);
   if verbosity > 0
      fprintf(['\n'...
               'iterations:   %-3d\n'...
               'final cost:   %-12.7g\n' ...
               'final grad:   %-12.7g\n' ...   
               'final lambda: %-12.7e\n' ...               
               'time / iter:  %-5.0f ms\n'...               
               'total time:   %-5.2f seconds, of which\n'...
               '  derivs:     %-4.1f%%\n'... 
               '  back pass:  %-4.1f%%\n'...
               '  fwd pass:   %-4.1f%%\n'...
               '  other:      %-4.1f%% (inc. graphics)\n'...
               '=========== end iLQG ===========\n'],...
               iter,sum(cost(:)),g_norm,lambda,1e3*total_t/iter,total_t, [diff_t, back_t, fwd_t, (total_t-diff_t-back_t-fwd_t)]*100/total_t);         
   end
   trace    = trace(1:max(trace(:,1)),:);
   timing   = [diff_t back_t fwd_t total_t-diff_t-back_t-fwd_t];
   graphics(Op.plot,x,u,cost,L,Vx,Vxx,fx,fxx,fu,fuu,trace,2); % draw legend
else
   error('Failure: no iterations completed, something is wrong.')
end

function [diverge,xnew,unew,cnew] = f_pass(x0,u,L,x,DYNCST,lims)
tolDiv   = 1e6;   % criterion for determining divergence

n        = size(x0,1);
m        = size(u,1);
N        = size(u,2);

xnew     = [x0 zeros(n,N)];
unew     = zeros(m,N);
cnew     = zeros(1,N+1);
diverge  = 0;
for i = 1:N
   if ~isempty(L)
      dx                   = xnew(:,i) - x(:,i);
      unew(:,i)            = u(:,i) + L(:,:,i)*dx;
   else
      unew(:,i)            = u(:,i);
   end
   if ~isempty(lims)
      unew(:,i)            = min(max(lims,[],2), max(min(lims,[],2), unew(:,i)));
   end
   [xnew(:,i+1),cnew(i)]   = DYNCST(xnew(:,i),unew(:,i),i);
   if any(abs(xnew(:,i+1)) > tolDiv)
      diverge  = 1;
      return
   end
end
[~,cnew(N+1)] = DYNCST(xnew(:,N+1),nan(m,1),i);


function [diverge, Vx, Vxx, l, L, dV] = back_pass(cx,cu,cxx,cxu,cuu,fx,fu,fxx,fxu,fuu,lambda,regType,lims,u)

% tensor multiplication
p13mm = @(a,b) permute(sum(bsxfun(@times,a,b),1), [3 2 1]); 

N  = size(cx,2);
n  = numel(cx)/N;
m  = numel(cu)/N;


cx    = reshape(cx,  [n N]);
cu    = reshape(cu,  [m N]);
cxx   = reshape(cxx, [n n N]);
cxu   = reshape(cxu, [n m N]);
cuu   = reshape(cuu, [m m N]);


l     = zeros(m,N-1);
L     = zeros(m,n,N-1);
Vx    = zeros(n,N);
Vxx   = zeros(n,n,N);
dV    = [0 0];

Vx(:,N)     = cx(:,N);
Vxx(:,:,N)  = cxx(:,:,N);

diverge  = 0;
nfactor  = 0;
for k = N-1:-1:1
	
	Qu  = cu(:,k)      + fu(:,:,k)'*Vx(:,k+1);
	Qx  = cx(:,k)      + fx(:,:,k)'*Vx(:,k+1);
	Qux = cxu(:,:,k)'  + fu(:,:,k)'*Vxx(:,:,k+1)*fx(:,:,k);
	if ~isempty(fxu)
		fxuVx = p13mm(Vx(:,k+1),fxu(:,:,:,k));
		Qux   = Qux + fxuVx;
	end
	
	Quu = cuu(:,:,k)   + fu(:,:,k)'*Vxx(:,:,k+1)*fu(:,:,k);
	if ~isempty(fuu)
		fuuVx = p13mm(Vx(:,k+1),fuu(:,:,:,k));
		Quu   = Quu + fuuVx;
	end
	
	Qxx = cxx(:,:,k)   + fx(:,:,k)'*Vxx(:,:,k+1)*fx(:,:,k);
	if ~isempty(fxx)
		Qxx = Qxx + p13mm(Vx(:,k+1),fxx(:,:,:,k));
	end
	
	Vxx_reg = (Vxx(:,:,k+1) + lambda*eye(n)*(regType == 2));
	
	Qux_reg = cxu(:,:,k)'   + fu(:,:,k)'*Vxx_reg*fx(:,:,k);
	if ~isempty(fxu)
		Qux_reg = Qux_reg + fxuVx;
	end
	
	QuuF = cuu(:,:,k)  + fu(:,:,k)'*Vxx_reg*fu(:,:,k) + lambda*eye(m)*(regType == 1);
	
	if ~isempty(fuu)
		QuuF = QuuF + fuuVx;
	end
	
	if nargin < 13 || isempty(lims) || lims(1,1) > lims(1,2)
		% cholesky decomposition, check for non-PD
		[R,d] = chol(QuuF);
		if d ~= 0
			diverge  = k;
			return;
		end
		
		% find control law
		lL = -R\(R'\[Qu Qux_reg]);
		lk = lL(:,1);
		Lk = lL(:,2:n+1);
		if ~isempty(lims)
			lower          = lims(:,2)-u(:,k);
			upper          = lims(:,1)-u(:,k);
			lk             = max(lower, min(upper, lk));
			clamped        = (lk==lower)|(lk==upper);
			Lk(clamped,:)  = 0;
		end
	else
		% solve boxQP
		lower = lims(:,1)-u(:,k);
		upper = lims(:,2)-u(:,k);
		
		[lk,result,R,free,QPtrace] = QP(QuuF,Qu,lower,upper,l(:,min(k+1,N-1)));
		if ~isempty(QPtrace)
			nfactor   = nfactor+[QPtrace(end).nfactor];
		end
		if result<1
			diverge  = k;
			return;
		end
		
		Lk	= zeros(m,n);
		if any(free)
			Lfree		= -R\(R'\Qux_reg(free,:));
			Lk(free,:)	= Lfree;
		end

	end
	
	% update cost-to-go approximation
	
	dV          = dV + [lk'*Qu  .5*lk'*Quu*lk];
	
	Vx(:,k)     = Qx  + Lk'*Quu*lk + Lk'*Qu  + Qux'*lk;
	Vxx(:,:,k)  = Qxx + Lk'*Quu*Lk + Lk'*Qux + Qux'*Lk;
	Vxx(:,:,k)  = .5*(Vxx(:,:,k) + Vxx(:,:,k)');
	
	l(:,k)      = lk;
	L(:,:,k)    = Lk;
end

function [x,result,Hfree,free,trace] = QP(H,g,l,u,x0,options)

n        = size(H,1);
clamped  = false(n,1);
free     = true(n,1);
oldvalue = 0;
result   = 0;
gnorm    = 0;
nfactor	 = 0;
trace    = [];
Hfree	 = zeros(n);

if nargin > 4
	x = max(l, min(u, x0));
else
	x = (l+u)/2;
end

if nargin > 5
	options        = num2cell(options(:));
	[maxIter, minGrad, minRelImprove, stepDec, minStep, Armijo, print] = deal(options{:});
else % defaults
	maxIter        = 100;		% maximum number of iterations
	minGrad        = 1e-8;		% minimum norm of non-fixed gradient
	minRelImprove  = 1e-8;		% minimum relative improvement
	stepDec        = 0.6;		% factor for decreasing stepsize
	minStep        = 1e-22;		% minimal stepsize for linesearch
	Armijo         = 0.1;   	% Armijo parameter (fraction of linear improvement needed)
	print          = 0;			% verbosity
end

value    = x'*g + 0.5*x'*H*x;

for iter = 1:maxIter
	
	if result ~=0
		break;
	end
	
	% check relative improvement
	if( iter>1 && (oldvalue - value) < minRelImprove*abs(oldvalue) )
		result = 4;
		break;
	end
	oldvalue = value;
	
	% get gradient
	grad     = g + H*x;
	
	% find clamped dimensions
	old_clamped					= clamped;
	clamped						= false(n,1);
	clamped((x == l)&(grad>0))	= true;
	clamped((x == u)&(grad<0))	= true;
	free						= ~clamped;
	
	% check for all clamped
	if all(clamped)
		result = 6;
		break;
	end		
	
	% factorize if clamped has changed
	if iter == 1
		factorize	= true;
	else
		factorize	= any(old_clamped ~= clamped);
	end
	
	if factorize
		[Hfree, indef]  = chol(H(free,free));
		if indef
			result = -1;
			break
		end
		nfactor			= nfactor + 1;
	end
	
	% check gradient norm
	gnorm  = norm(grad(free));
	if gnorm < minGrad
		result = 5;
		break;
	end		
	
	% get search direction
	grad_clamped   = g  + H*(x.*clamped);
	search         = zeros(n,1);	
	
	search(free)   = -Hfree\(Hfree'\grad_clamped(free)) - x(free);
	
	% check for descent direction
	sdotg          = sum(search.*grad);
	if sdotg >= 0 % (should not happen)
		break
	end
	
	% armijo linesearch
	step  = 1;
	nstep = 0;
	xc    = min(u, max(l, x+step*search));
	vc    = xc'*g + 0.5*xc'*H*xc;
	while (vc - oldvalue)/(step*sdotg) < Armijo
		step  = step*stepDec;
		nstep = nstep+1;		
		xc    = min(u, max(l, x+step*search));
		vc    = xc'*g + 0.5*xc'*H*xc;		
		if step<minStep
			result = 2;
			break
		end
	end
	
	if print > 1
		fprintf('iter %3d:  |grad|= %9.3g,  reduction= %9.3g, improvement= %9.4g  linesearch = %g ^ %-2d,  factorize = %d\n', ...
			iter, gnorm, oldvalue-vc, (vc - oldvalue) / (step*sdotg), stepDec, nstep, factorize);
	end
	
	if nargout > 4
		trace(iter).x        = x;
		trace(iter).xc       = xc;
		trace(iter).value    = value;
		trace(iter).search   = search;
		trace(iter).clamped  = clamped;
		trace(iter).nfactor  = nfactor;
	end
	
	%accept candidate
	x     = xc;
	value = vc;
end

if iter >= maxIter
	result = 1;
end

results = { 'Hessian is not positive definite',...			% result = -1
			'No descent direction found',...				% result = 0    SHOULD NOT OCCUR
			'Maximum main iterations exceeded',...			% result = 1
			'Maximum line-search iterations exceeded',...	% result = 2
			'No bounds, returning Newton point',...			% result = 3
			'Improvement smaller than tolerance',...		% result = 4
			'Gradient norm smaller than tolerance',...		% result = 5
			'All dimensions are clamped'};					% result = 6

if print > 0
	fprintf('RESULT: %s.\niterations = %d,  gradient = %-12.6g, final value = %-12.6g,  factorizations = %d\n',...
		results{result+2}, iter, gnorm, value, nfactor);
end



function  stop = graphics(figures,x,u,cost,L,Vx,Vxx,fx,fxx,fu,fuu,trace,init)
stop = 0;

if figures == 0
   return;
end

n  = size(x,1);
N  = size(x,2);
nL = size(L,2);
m  = size(u,1);

cost  = sum(cost,1);

% === first figure
if figures ~= 0  && ( mod(trace(end,1)-1,figures) == 0 || init == 2 )
   
   fig1 = findobj(0,'name','iLQG - convergence');
   if  isempty(fig1)
      fig1 = figure();
      set(fig1,'NumberTitle','off','Name','iLQG - convergence','KeyPressFcn',@Kpress,'user',0);
   end

   if size(trace,1) == 1
      set(fig1,'user',0);
   end

   set(0,'currentfigure',fig1);
   clf(fig1);

   ax1   = subplot(2,2,1);
   set(ax1,'XAxisL','top','YAxisL','right','xlim',[1 N],'xtick',[])
   line(1:N,cost,'linewidth',4,'color',.5*[1 1 1]);
   ax2 = axes('Position',get(ax1,'Position'));
   plot((1:N),x','linewidth',2);
   set(ax2,'xlim',[1 N],'Ygrid','on','YMinorGrid','off','color','none');
   set(ax1,'Position',get(ax2,'Position'));
   double_title(ax1,ax2,'state','running cost')
   
   axL = subplot(2,2,3);
   CO = get(axL,'colororder');
   set(axL,'nextplot','replacechildren','colororder',CO(1:min(n,7),:))
   Lp = reshape(permute(L,[2 1 3]), [nL*m N-1])';
   plot(axL,1:N-1,Lp,'linewidth',1,'color',0.9*[1 1 1]);
   ylim  = get(axL,'Ylim');
   ylim  = [-1 1]*max(abs(ylim));
   set(axL,'XAxisL','top','YAxisL','right','xlim',[1 N],'xtick',[],'ylim',ylim)
   axu = axes('Position',get(axL,'Position'));
   plot(axu,(1:N-1),u(:,1:N-1)','linewidth',2);
   ylim  = get(axu,'Ylim');
   ylim  = [-1 1]*max(abs(ylim));   
   set(axu,'xlim',[1 N],'Ygrid','on','YMinorGrid','off','color','none','ylim',ylim);
   set(axL,'Position',get(axu,'Position'));
   double_title(axu,axL,'controls','gains')
   xlabel 'timesteps'

   T        = trace(:,1);
   mT       = max(T);   
   
   ax1      = subplot(2,2,2); 
   set(ax1,'XAxisL','top','YAxisL','right','xlim',[1 mT+eps],'xtick',[])
   hV = line(T,trace(:,7),'linewidth',4,'color',.5*[1 1 1]);
   ax2 = axes('Position',get(ax1,'Position'));
   hT = semilogy(T,max(0, trace(:,2:5)),'.-');    
   set(ax2,'xlim',[1 mT+eps],'Ygrid','on','YMinorGrid','off','color','none');
   set(ax1,'Position',get(ax2,'Position'));
   double_title(ax1,ax2,'convergence trace','total cost')
   
   subplot(2,2,4);
   plot(T,trace(:,6),'.-','linewidth',2);
   title 'actual/expected reduction ratio'
   set(gca,'xlim',[0 mT+1],'ylim',[0 2],'Ygrid','on');
   xlabel 'iterations'
   
   set(findobj(fig1,'-property','FontSize'),'FontSize',8)
   stop = get(fig1,'user');
end

if figures < 0  &&  (mod(abs(trace(end,1))-1,figures) == 0 || init == 2) && ~isempty(Vx)

   fig2 = findobj(0,'name','iLQG - derivatives');
   if  isempty(fig2)
      fig2 = figure();
      set(fig2,'NumberTitle','off','Name','iLQG - derivatives','KeyPressFcn',@Kpress,'user',0);
   end

   if size(trace,1) == 1
      set(fig2,'user',0);
   end

   set(0,'currentfigure',fig2);
   clf(fig2);

   subplot(2,3,1);
   plot(1:N,Vx','linewidth',2);
   set(gca,'xlim',[1 N]);
   title 'V_x'
   grid on;   

   subplot(2,3,4);
   z = reshape(Vxx,nL^2,N)';
   zd = (1:nL+1:nL^2);
   plot(1:N,z(:,setdiff(1:nL^2,zd)),'color',.5*[1 1 1]);
   hold on;
   plot(1:N,z(:,zd),'linewidth',2);
   hold off
   grid on;
   set(gca,'xlim',[1 N]);
   title 'V_{xx}'
   xlabel 'timesteps'   

   subplot(2,3,2);
   z = reshape(fx,nL^2,N-1)';
   zd = (1:n+1:n^2);
   plot(1:N-1,z(:,setdiff(1:n^2,zd)),'color',.5*[1 1 1]);
   hold on;
   plot(1:N-1,z,'linewidth',2);
   set(gca,'xlim',[1 N-1+eps]);
   hold off
   grid on;
   title 'f_{x}'    
   
   nxx = numel(fxx);
   if nxx == nL^3*(N-1) || nxx == nL^2*(N-1)
      subplot(2,3,5);
      z  = reshape(fxx,[nxx/(N-1) N-1])';
      plot(1:N-1,z);
      title 'f_{xx}'
      grid on;   
      set(gca,'xlim',[1 N-1+eps]);
   end

   subplot(2,3,3);
   z = reshape(fu,nL*m,N-1)';
   plot(1:N-1,z','linewidth',2);
   set(gca,'xlim',[1 N]);
   title 'f_u'
   grid on;
   
   nuu = numel(fuu);
   if nuu == nL*m^2*(N-1) || nuu == nL*m*(N-1)
      subplot(2,3,6);
      z  = reshape(fuu,[nuu/(N-1) N-1])';
      plot(1:N-1,z);
      title 'f_{uu}'
      grid on;   
      set(gca,'xlim',[1 N-1+eps]);
   end   
   
   set(findobj(fig2,'-property','FontSize'),'FontSize',8)
   stop = stop + get(fig2,'user');
end

if init == 1
   figure(fig1);
elseif init == 2
   strings  = {'V','\lambda','\alpha','\partial_uV','\Delta{V}'};
   legend([hV; hT],strings,'Location','Best');
end

drawnow;

function Kpress(src,evnt)
if strcmp(evnt.Key,'escape')
   set(src,'user',1)
end

function double_title(ax1, ax2, title1, title2)

t1 = title(ax1, title1);
set(t1,'units','normalized')
pos1 = get(t1,'position');
t2 = title(ax2, title2);
set(t2,'units','normalized')
pos2 = get(t2,'position');
[pos1(2),pos2(2)] = deal(min(pos1(2),pos2(2)));
pos1(1)  = 0.05;
set(t1,'pos',pos1,'HorizontalAlignment','left')
pos2(1)  = 1-0.05;
set(t2,'pos',pos2,'HorizontalAlignment','right')

% setOpts - a utility function for setting default parameters
% ===============
% defaults  - either a cell array or a structure of field/default-value pairs.
% options   - either a cell array or a structure of values which override the defaults.
% params    - structure containing the union of fields in both inputs. 
function params = setOpts(defaults,options)

if nargin==1 || isempty(options)
   user_fields  = [];
else
   if isstruct(options)
      user_fields   = fieldnames(options);
   else
      user_fields = options(1:2:end);
      options     = struct(options{:});
   end
end

if isstruct(defaults)
   params   = defaults;
else
   params   = struct(defaults{:});
end

for k = 1:length(user_fields)
   params.(user_fields{k}) = options.(user_fields{k});
end
