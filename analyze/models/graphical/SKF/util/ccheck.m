function ccheck(M)
% Check covariance matrices

if all(eig((M+M')/2) >=0)
    % positive semi-definite
else
    [ST,I] = dbstack;
    dbstack
    fprintf('%s: line %d: CCHECK failed\n',ST(2).file, ST(2).line);
    keyboard
end

if ~isequal(M,M')
    dbstack
    fprintf('NOT SYMMETRIC');
    keyboard
end
