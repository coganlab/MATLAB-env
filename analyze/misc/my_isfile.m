function out = my_isfile(file)

a = dir(file);

if length(a)
    out = 1;
else
    out = 0;
end
