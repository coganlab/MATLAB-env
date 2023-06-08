function skf = gpb2_filter(skf, Y, S)
T = size(Y,2);


for t=1:T
    % Individual Kalman Filter Updates for each model
    for i=1:skf.nmodels
	for j=1:skf.nmodels
	    [newX, newP, newPc, L] = kf_filter(skf,i,j,t,Y(:,t));
	    skf.Xij(:,i,j,t) = newX;
	    skf.Pij(:,:,i,j,t) = newP;
	    if i == j && any(diag(newP)<0)
		dbstack; keyboard
	    end
	    skf.Pcij(:,:,i,j,t) = newPc;
	    skf.L(i,j,t) = L;

	    if nargin == 4
		MM = S(t) == j;
		MM = MM*(1-eps)+eps;
	    else
		MM = 1;
	    end

	    if t == 1
		skf.Mt(i,j,t) = L*skf.Z(i,j)*skf.mu_0(i);
	    else
		skf.Mt(i,j,t) = L*skf.Z(i,j)*skf.M(i,t-1)*MM;
	    end
	    if any(any(isnan(newP))) || any(not(isreal(newP(:)))) ||any(diag(newP)<0)
		dbstack; keyboard
	    end
	end
    end

    %Normalize state transitions
    skf.Mt(:,:,t) = skf.Mt(:,:,t) / sum(sum(skf.Mt(:,:,t)));

    %Compute state probabilities: P( S_t=j | y_1:t )
    skf.M(:,t) = sum(skf.Mt(:,:,t),1);

    % ???
    for i=1:skf.nmodels
	for j=1:skf.nmodels
	    skf.Wij(i,j,t) = skf.Mt(i,j,t)/skf.M(j,t);
	end
    end

    for j=1:skf.nmodels
	[newX, newP] =  gpb2_collapse(skf.Xij(:,:,j,t),skf.Pij(:,:,:,j,t),skf.Wij(:,j,t));
	skf.model{j}.X(:,t) = newX;
	skf.model{j}.P(:,:,t) = newP;
	xtj(:,j) = newX;
	ptj(:,:,j) = newP;
	if any(any(any(isnan(newP)))) || any(not(isreal(newP(:)))) || any(diag(newP)<0)
	    disp('Problem with P');
	    dbstack; keyboard
	end
    end



    [skf.X(:,t), skf.P(:,:,t)] = gpb2_collapse(xtj, ptj, skf.M(:,t));

end

