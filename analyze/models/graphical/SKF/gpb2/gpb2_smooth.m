function skf = gpb2_smooth(skf, Y)
%GPB2_SMOOTH	Smoother for GPB2
%
% Inputs: 
%   skf = SKF structure with filtered estimates
%   Y = observations
% Output:
%   skf = SKF structure updated with smoothed estimates

T = size(Y,2);

% Base cases for t=T
for i=1:skf.nmodels
    skf.model{i}.smooth.X(:,T) = skf.model{i}.X(:,T);
    skf.model{i}.smooth.P(:,:,T) = skf.model{i}.P(:,:,T);
    skf.smooth.XtTj(:,i,T) = skf.model{i}.X(:,T);
    skf.smooth.PtTj(:,:,i,T) = skf.model{i}.P(:,:,T);
end
skf.smooth.M(:,T) = skf.M(:,T);
skf.smooth.Mt(:,T) = skf.Mt(:,T);
skf.smooth.X(:,T) = skf.X(:,T);
skf.smooth.P(:,:,T) = skf.P(:,:,T);
skf.smooth.Pjk(:,:,:,:,T) = skf.Pij(:,:,:,:,T);
skf.smooth.Wkj(:,:,T) = skf.Z;
skf.smooth.U(:,:,T) = skf.Z';

for t=T-1:-1:1
    if(any(isnan(skf.smooth.P(:))))
	disp('smoothed P isnan')
	dbstack
	keyboard
    end
    for j=1:skf.nmodels
	for k=1:skf.nmodels
	    [newX, newP, newPc] = kf_smooth(skf,j,k,t);
	    skf.smooth.Xjk(:,j,k,t) = newX;
	    skf.smooth.Pjk(:,:,j,k,t) = newP;
	    skf.smooth.Pcjk(:,:,j,k,t+1) = newPc;
	    if any(isnan(newP(:))) || any(not(isreal(newP(:))))
		dbstack;keyboard
	    end


	    skf.smooth.U(j,k,t) = skf.M(j,t)*skf.Z(j,k);
	end
    end

    for k=1:skf.nmodels
	unorm = 0;
	for jp =1:skf.nmodels
	    unorm = unorm + skf.M(jp,t)*skf.Z(jp,k);
	end
	skf.smooth.U(:,k,t) = skf.smooth.U(:,k,t)/unorm;
    end

    for j = 1:skf.nmodels
	for k=1:skf.nmodels
	    skf.smooth.Mt(j,k,t) = skf.smooth.U(j,k,t)*skf.smooth.M(k,t+1);
	end
	skf.smooth.M(j,t) = sum(skf.smooth.Mt(j,:,t));
    end

    for k=1:skf.nmodels
	for j=1:skf.nmodels
	    skf.smooth.Wkj(k,j,t) = skf.smooth.Mt(j,k,t)/skf.smooth.M(j,t);
	end
    end

    for j=1:skf.nmodels
	Xk = reshape(skf.smooth.Xjk(:,j,:,t), skf.xdims, skf.nmodels);
	Pk = reshape(skf.smooth.Pjk(:,:,j,:,t),skf.xdims,skf.xdims,skf.nmodels);
	[newX, newP] = gpb2_collapse(Xk,Pk,skf.smooth.Wkj(:,j,t));
	skf.model{j}.smooth.X(:,t)  = newX;
	skf.model{j}.smooth.P(:,:,t) = newP;
	skf.smooth.XtTj(:,j,t) = newX;
	skf.smooth.PtTj(:,:,j,t) = newP;
	if any(isnan(newP(:))) || any(not(isreal(newP(:))))
	    dbstack;keyboard
	end


    end

    [finalX, finalP] = gpb2_collapse(skf.smooth.XtTj(:,:,t), skf.smooth.PtTj(:,:,:,t), skf.smooth.M(:,t));
    skf.smooth.X(:,t) = finalX;
    skf.smooth.P(:,:,t) = finalP;

    if any(isnan(finalP(:))) || any(not(isreal(newP(:))))
	dbstack;keyboard
    end

    
    for j=1:skf.nmodels
	for k=1:skf.nmodels
	    skf.smooth.XuT(:,j,k,t) = skf.smooth.XtTj(:,k,t+1);
	end
    end


    for k=1:skf.nmodels
	[newX, newY, newP] = gpb2_collapse_cross(skf.smooth.XuT(:,:,k,t), skf.smooth.Xjk(:,:,k,t),skf.smooth.Pcjk(:,:,:,k,t+1),skf.smooth.U(:,k,t));
	skf.smooth.PutTk(:,:,k,t) = newP;

	s = 0;
	for j=1:skf.nmodels
	    s = s + skf.smooth.Xjk(:,j,k,t)*skf.smooth.U(j,k,t);
	end
	skf.smooth.Xb(:,k,t) = s;
    end
    [newX,newY,newP] = gpb2_collapse_cross(skf.smooth.XtTj(:,:,t+1),skf.smooth.Xb(:,:,t), skf.smooth.PutTk(:,:,:,t), skf.smooth.M(:,t+1));
    skf.smooth.VutT(:,:,t+1) = newP;


end
