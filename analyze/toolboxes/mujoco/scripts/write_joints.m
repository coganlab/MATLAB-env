%     1-3: lower_torso_TZ_root TX,TY,TZ
%     4-6: quat="0.70710678 0.70710678 0 0"
%     7:lumbar_pitch
%     8:lumbar_roll
%     9:lumbar_yaw
%     10:sternoclavicular_r_r2 
%     11:sternoclavicular_r_r3
%     12:unrotscap_r_r3
%     13:unrotscap_r_r2
%     14:acromioclavicular_r_r2
%     15:acromioclavicular_r_r3
%     16:acromioclavicular_r_r1
%     17:unrothum_r_r1
%     18:unrothum_r_r2
%     19:unrothum_r_r3
%     20:elevation_angle_r
%     21:shoulder_elevation_r
%     22:shoulder1_r_r2
%     23:shoulder_rotation_r
%     24:elbow_flexion_r
%     25:pro_supination_r
%     27-29:free (toy/target) TX,TY,TZ *********
%     30-33: toy quat="1 0.01 0.01 0"
%     34-end:jlink1,2,3 (the stick parts of the toy) - RX,RY,RZ,....
%     not sure precisely how these last few map to the toy, but should be somewhat close



%unadulterated
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

% 1 lower_torso_TX,
% 2 lower_torso_TY,
% 3 lower_torso_TZ,
% 4 lower_torso_RX,
% 5 lower_torso_RY,
% 6 lower_torso_RZ,
% 7 lumbar_roll,
% 8 lumbar_yaw,
% 9 lumbar_pitch,
% 10 shoulder_elevation_r,
% 11 elevation_angle_r,
% 12 shoulder_rotation_r,
% 13 elbow_flexion_r,
% 14 pro_supination_r,
% wrist_flexion_r,wrist_deviation_r,thumb_prox_flexion_r,thumb_prox_abduction_r,thumb_mid_flexion_r,thumb_distal_flexion_r,index_prox_flexion_r,index_prox_abduction_r,index_mid_flexion_r,index_distal_flexion_r,middle_prox_flexion_r,middle_prox_abduction_r,middle_mid_flexion_r,ring_prox_flexion_r,ring_prox_abduction_r,ring_mid_flexion_r,ring_distal_flexion_r,pinky_prox_flexion_r,pinky_prox_abduction_r,pinky_mid_flexion_r,pinky_distal_flexion_r

function qp=write_joints(qposmatrix, filename)

qposmatrix_tp = qposmatrix';

torso_r = SpinCalc('QtoEA123', qposmatrix_tp(:,4:7), 1e-3, 0);

qposmatrix_deg = qposmatrix_tp.*(180./pi);

order = [22 21 23 25 24];
%o/shourder = [22:26];

qposmatrix_ordered = [zeros(size(qposmatrix_tp,1),9)];
qposmatrix_ordered = [qposmatrix_ordered qposmatrix_deg(:,order)];
qposmatrix_ordered = [qposmatrix_ordered zeros(size(qposmatrix_deg,1),21)];

% 120902 torso fixed
%qposmatrix_ordered = qposmatrix_ordered(:,[10:24 28:end]);
qposmatrix_ordered = [qposmatrix_ordered(:,[10:24]) zeros(size(qposmatrix_tp,1), 20)];

dlmwrite(filename, qposmatrix_ordered, 'precision', '%.6f');

qp=qposmatrix_ordered;
