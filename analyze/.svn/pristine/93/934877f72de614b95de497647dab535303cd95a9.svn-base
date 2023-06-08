% save 2D array as binary mujoco heightfield: nx, ny, [image data]
function save_hf(data, filename)

fp = fopen(filename, 'wb');
if ~fp,
    error('could not create file');
end

sz = size(data);
fwrite(fp, sz, 'int32');
fwrite(fp, data', 'float32');
fclose(fp);