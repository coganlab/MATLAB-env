function myrmpath(mypath)
%
%   myrmpath(path)
%
a = mypath;
[t,r] = strtok(a,':'); rmpath(t);
while(length(r)) 
    [t,r] = strtok(r,':');
    rmpath(t);
end
