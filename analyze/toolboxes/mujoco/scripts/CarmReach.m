%% note 0
% if you use the non-matlab standalone mj_studio in the bin folder you can
%   open the model armC_nofingers.xml and hit 'b' to see the joint locations

%% Prep notes / Readme for matlab use
% put armC_nofingers.xml in the models folder
% run the setpath code in the matlab folder
% in the models folder, be sure to run (if xml is modified): xml2mjb(deblank('armC_nofingers.xml'))
% the above line will compile the xml file to an mjb file
% the fingertip line of the xml file corresponds to the end effector location of the arm 
% this can and maybe needs to be adjusted
% from the matlab folder the following code can be run 
% The arm has no meshes so I can't tell where the arm is or what direction the arm is facing
% possibly the toy needs to be at a different location relative to the arm
% Will update this if we get arm meshes
% To view the arm at all (though indirectly), pressing 'i' will give moments of inertia but this doesn't really visualize the arm well
% to get trajectory only a few timesteps into the future, set the timestep
%   size in the xml file and then use mjsim for a time that corresponds to a
%   few steps
% This file is organized into a few cells to be run as follows:
% 1) run the next cell to load the model from the mjb file (assuming converted from xml)
% 2) run cell for one of -  default reach, reach to specific target, or
% reach to random target
% 3) the workspace will store xposmatrix and qposmatrix which are:
%   xposmatrix is the end effector of the arm
%   qposmatrix is all of the kinematic variables of the model (45 for armC_nofingers.xml)
%   The list from looking at mujoco standalone of the model is (angles in radians, translations in meters?):
%     1-3: lower_torso_TZ_root TX,TY,TZ
%     4-7: quat="0.70710678 0.70710678 0 0"
%     8:lumbar_pitch
%     9:lumbar_roll
%     10:lumbar_yaw
%     11:sternoclavicular_r_r2 
%     12:sternoclavicular_r_r3
%     13:unrotscap_r_r3
%     14:unrotscap_r_r2
%     15:acromioclavicular_r_r2
%     16:acromioclavicular_r_r3
%     17:acromioclavicular_r_r1
%     18:unrothum_r_r1
%     19:unrothum_r_r2
%     20:unrothum_r_r3
%     21:elevation_angle_r
%     22:shoulder_elevation_r
%     23:shoulder1_r_r2
%     24:shoulder_rotation_r
%     25:elbow_flexion_r
%     26:pro_supination_r
%     27-29:free (toy/target) TX,TY,TZ *********
%     30-33: toy quat="1 0.01 0.01 0"
%     34-end:jlink1,2,3 (the stick parts of the toy) - RX,RY,RZ,....
%     not sure precisely how these last few map to the toy, but should be somewhat close
% 4) The last cell will play a video of the reach (again 'i' will give moments of inertia)
%%
close all; clear all;

global xposmatrix qposmatrix sites %this requires a modified arm_reach.m file (adjusted from distribution)

% load model
addpath('/mnt/y7/analyze/toolboxes/mujoco/models/');
addpath('/mnt/raid/analyze/toolboxes/mujoco/models/');
%mj('load',which('armC_noweirdjoint.mjb'));
mj('load',which('armC_nofingers_with_geoms.mjb'));
mj('load',which('armC_nofingers.mjb'));
model = mj('getmodel');

%% default reach - uses initial position specified by xml file
mjsim(@arm_reach,5); %second arg is number of seconds to simulate (with 100 bins per second, specified in the xml)

%%
% partly based on code for simple reaches worked on by Chris Cueva, modified by Josh Merel
%----------------------------------------------------------------------
%               reach to specific xyz pose of endpoint
%----------------------------------------------------------------------
targetpos = [.255; 0; 3.09];% target position
qpos0 = mj('get','qpos');% 45 x 1 matrix, initial position in generalized coordinates
qpos0(26:28) = targetpos;% set target position
mj('set','qpos',qpos0);
mjsim(@arm_reach,5); 
fingerpos = mj('get','site_xpos');% 2 x 3 matrix 
fingerpos = (fingerpos(1,:) + [0.045 0 0])'% 3 x 1 matrix
qposT = mj('get','qpos')% 45 x 1 matrix, final position in generalized coordinates

%%
%----------------------------------------------------------------------
%    reach to randomly picked location within a square (may be too far
%    to reach so may need to adjust square boundaries)
%----------------------------------------------------------------------
xposmatrix = []; qposmatrix = [];

x = -0.7 + (0.7+0.7)*rand(1);
y = -0.7 + (0.7+0.7)*rand(1);
z = 2.6 + (3.9-2.6)*rand(1);
targetpos = [x; y; z];% target position
% might be a good idea to fix the initialization to a specfic value
% qpos0 = [0;0;3.25000000000000;0.707106781186548;0.707106781186548;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0.150000000000000;0.100000000000000;3.25000000000000;0.999900014997501;0.00999900014997501;0.00999900014997501;0;1;0;0;0;1;0;0;0;1;0;0;0;]';
% alternative to above line is trust default initialization
qpos0 = mj('get','qpos');
qpos0(27:29) = targetpos;% set target position
mj('set','qpos',qpos0);
mjsim(@arm_reach,1); %second arg is number of seconds to simulate (with 100 bins per second, specified in the xml) 

% check if reach is near target
fingerpos = mj('get','site_xpos');% 2 x 3 matrix 
fingerpos = (fingerpos(1,:) + [0.045 0 0])';% 3 x 1 matrix
distance = sqrt((fingerpos - targetpos)'*(fingerpos - targetpos));


%% The following commands appear to animate arbitrary saved trajectories.
DATA = struct;
for i = 1:size(qposmatrix,2)
    DATA(i).qpos = qposmatrix(:,i);
    DATA(i).time = i*mj('get','dt');
    
%     %if you want to display one frame at a time (this is basically the inards of animate)
%     mj('set','qpos',DATA(i).qpos);
%     mj kinematics;
%     mjplot;
%     pause
end
animate(DATA)

%%
figure
for i = 1:size(sites,1)
    tmp = reshape(sites(i,:),5,3)';
    plot3(tmp(1,:),tmp(2,:),tmp(3,:))
    xlim([-0.10 0.02]);
    ylim([-0.2 0.2]);
    zlim([3.15 3.55]);
    pause(.05)
end
