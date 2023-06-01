function mem = meminfo
%
%  mem = meminfo
%
%  Inputs: None
%
%  Outputs: Mem.MemTotal = RAM size in kilobytes.
%	    Mem.MemFree = RAM Free in kilobytes
%       Mem.SwapTotal = Total Swap space size in kB
%       Mem.SwapFree = Free Swap space size in kB


unix('cat /proc/meminfo > ~/meminfo');

fid = fopen('~/meminfo');

C = textscan(fid,'%s%f');
fclose(fid);

mem = struct([]);
for iC = 1:length(C{1})
  switch C{1}{iC}(1:end-1)
  case {'MemFree','MemTotal','SwapTotal','SwapFree'}
    mem = setfield(mem,{1,1},C{1}{iC}(1:end-1),{1},C{2}(iC));
  end
end
delete('~/meminfo')
