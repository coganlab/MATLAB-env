function retu = shuffle(inpt)
%shuf = shuffle(inpt)
nn = length(inpt);
retu = inpt;
for i = 1:nn-1
    j = floor(rand(1,1)*(nn-i+1)+i);
    temp = retu(i);
    retu(i) = retu(j);
    retu(j)=temp;
end