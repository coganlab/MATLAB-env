function register_KeyPressFcn(fig_or_ax, eventtype, fun_handle, args)
if nargin < 4
    args = {};
end
numh = numel(fig_or_ax.(eventtype));
fprintf('Registering %s\n', eventtype);
disp(fun_handle)
if numh == 0
    fig_or_ax.(eventtype) = {@exec_KeyPressFcn, {fun_handle, args}};
else
    fig_or_ax.(eventtype){end+1} = {fun_handle, args};
end
end