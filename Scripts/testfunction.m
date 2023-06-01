function output = testfunction(input)
if ~isfield(input,'numbers'); input.numbers=1:5;disp('Filling in numbers'); end
output = input.numbers+4;
end