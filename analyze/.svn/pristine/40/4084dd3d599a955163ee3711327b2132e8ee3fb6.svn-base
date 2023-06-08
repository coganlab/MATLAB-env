function P = gauss_pdf(X,M,S)
%GAUSS_PDF Probability of X given mean (M) and covariance (S)
    
    if all(M(:) == 0)
	DX = X;
    else
	DX = X - M;
    end

    d = length(DX);

    c = (2*pi)^(d/2);
    c = c * det(S)^(1/2);

    E = (-1/2)*DX'*pinv(S)*DX;
    P = exp(E);
    P = P./c;

