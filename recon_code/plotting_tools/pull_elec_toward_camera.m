function pull_elec_toward_camera(handle_elec, magnitude)
% sc is scatter handle
if nargin < 2
    magnitude = 10; % mm
end

for e = 1:numel(handle_elec.XData)
    newpoint = campos - [handle_elec.XData(e) handle_elec.YData(e) handle_elec.ZData(e)];
    newpoint = newpoint/norm(newpoint);
    newpoint = newpoint * magnitude;
    handle_elec.XData(e) = handle_elec.XData(e) + newpoint(1);
    handle_elec.YData(e) = handle_elec.YData(e) + newpoint(2);
    handle_elec.ZData(e) = handle_elec.ZData(e) + newpoint(3);
end

drawnow update;
end