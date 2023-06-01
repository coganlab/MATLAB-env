function status = Fseek(fid,offset,origin)

if nargin < 3
  origin = -1;
end

position = ftell(fid);
Diff = offset - position;
fseek(fid,0,origin);

Loops = floor(offset./32000);
if Loops
   for i = 1:Loops
      fseek(fid,32000,0);
   end
end

sh = round(rem(offset,32000));
status = fseek(fid,sh,0);
