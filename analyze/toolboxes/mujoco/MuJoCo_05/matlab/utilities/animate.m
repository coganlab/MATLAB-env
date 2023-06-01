% animate a recorded sequence (see mjsim())
function animate(DATA)

N   = length(DATA);
tic;
for i = 1:N-1
    mj('set','qpos',DATA(i).qpos);
    mj kinematics;
    mjplot;

    dt = max(0, DATA(i+1).time - DATA(i).time);
    pause(max(0, dt-toc));
    tic;
end
