function hittest_off(handle, notthisone)
if nargin < 2
    notthisone = 1;
end

if ~notthisone
    p = properties(handle);
    if sum(strcmp(p, 'ButtonDownFcn'))
        if ~isempty(handle.ButtonDownFcn)
            warning('Turning off hittest for a %s with a button down callback', class(handle));
        end
    end
    if sum(strcmp(p, 'HitTest'))
        handle.HitTest = 'off';
    end
end

for h = 1:numel(handle.Children)
    hittest_off(handle.Children(h), 0);
end
end