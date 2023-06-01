function [h,alldata] = edfread_fast(fn, channels)
tic
h = edfread(fn);

if nargout > 1
    fid = fopen(fn, 'r');

    fseek(fid, h.bytes, -1);

    total_bytes = h.records * sum(h.samples) * 2;

    alldata = fread(fid, [total_bytes 1], 'int16=>int16');

    fclose(fid);
    
    alldata = double(alldata);

    alldata = reshape(alldata, sum(h.samples), h.records);

    alldata = mat2cell(alldata, h.samples, h.records);

    if nargin > 1
        alldata = alldata(channels);
    end

    scalefac = (h.physicalMax - h.physicalMin)./(h.digitalMax - h.digitalMin);
    dc = h.physicalMax - scalefac .* h.digitalMax;

    for i = 1:numel(alldata)
        alldata{i} = alldata{i}(:)' * scalefac(i) + dc(i);
    end
    
    alldata = vertcat(alldata{:});
end

toc

end