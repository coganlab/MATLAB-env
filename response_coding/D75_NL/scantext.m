function data = scantext(filename, delimiter, numheaders, fmt)
if ~exist('numheaders', 'var') || isempty(numheaders)
    numheaders = 0;
end

if ~exist('fmt', 'var') || isempty(fmt)
    fmt = scanformat(filename, delimiter, numheaders);
end

fid = fopen(filename, 'rb');
for n = 1:numheaders
    fgets(fid);
end

data = textscan(fid, fmt, Inf, 'Delimiter', delimiter);
fclose(fid);
end