function procJointsat(day, rec, jointfile)
% procJointsat(day, rec, jointfile)
% 
% Calculates the proportion of frames for each joint that are saturated in the joint solve.
% 

global MONKEYDIR
calvin_pmd_pmv_sc32x4

cd([MONKEYDIR '/' day '/' rec]);
load(['rec' rec '.Body.joint_names.mat'])
JOINTLIST = joint_names(10:34);
HANDJOINTLIST = JOINTLIST(8:end);

JointFilename = ['rec' rec '.' 'Body' '.' jointfile '.mocap.mot'];
[header,joint_data,joint_names]=parseJointFile(JointFilename,1);

for shoulder_elevation_r = joint_data(12,:);
  low_sat = find(shoulder_elevation_r == 0);
  high_sat = find(shoulder_elevation_r == 180);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop1 = total_sat/length(shoulder_elevation_r); 
end
  if sat_prop1 < 0.03 
      disp('low levels of shoulder_elevation saturation')
  else sat_prop1 > 0.03
      disp('high levels of shoulder_elevation saturation')
  end


for elevation_angle_r = joint_data(13,:);
  low_sat = find(elevation_angle_r == -90);
  high_sat = find(elevation_angle_r == 130);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop2 = total_sat/length(elevation_angle_r);
end
  if sat_prop2 < 0.03 
      disp('low levels of elevation_angle saturation')
  else sat_prop2 > 0.03
      disp('high levels of elevation_angle saturation')
  end


for shoulder_rotation_r = joint_data(14,:);
  low_sat = find(shoulder_rotation_r == -120);
  high_sat = find(shoulder_rotation_r == 60);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop3 = total_sat/length(shoulder_rotation_r); 
end
  if sat_prop3 < 0.03 
      disp('low levels of shoulder_rotation saturation')
  else sat_prop3 > 0.03
      disp('high levels of shoulder_rotation saturation')
  end


for elbow_flexion_r = joint_data(15,:);
  low_sat = find(elbow_flexion_r == -10);
  high_sat = find(elbow_flexion_r == 160);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop4 = total_sat/length(elbow_flexion_r); 
end
  if sat_prop4 < 0.03 
      disp('low levels of elbow_flexion saturation')
  else sat_prop4 > 0.03
      disp('high levels of elbow_flexion saturation')
  end

for pro_supination_r = joint_data(16,:);
  low_sat = find(pro_supination_r == -120);
  high_sat = find(pro_supination_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop5 = total_sat/length(pro_supination_r);
end
  if sat_prop5 < 0.03 
      disp('low levels of pro_supination saturation')
  else sat_prop5 > 0.03
      disp('high levels of pro_supination saturation')
  end


for wrist_flexion_r = joint_data(17,:);
  low_sat = find(wrist_flexion_r == -90);
  high_sat = find(wrist_flexion_r == 90);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop6 = total_sat/length(wrist_flexion_r);
end
  if sat_prop6 < 0.03 
      disp('low levels of wrist_flexion saturation')
  else sat_prop6 > 0.03
      disp('high levels of wrist_flexion saturation')
  end


for wrist_deviation_r = joint_data(18,:);
  low_sat = find(wrist_deviation_r == -45);
  high_sat = find(wrist_deviation_r == 45);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop7 = total_sat/length(wrist_deviation_r); 
end
  if sat_prop7 < 0.03 
      disp('low levels of wrist_deviation saturation')
  else sat_prop7 > 0.03
      disp('high levels of wrist_deviation saturation')
  end

for thumb_prox_flexion_r = joint_data(19,:);
  low_sat = find(thumb_prox_flexion_r == -60);
  high_sat = find(thumb_prox_flexion_r == 60);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop8 = total_sat/length(thumb_prox_flexion_r); 
end
  if sat_prop8 < 0.03 
      disp('low levels of thumb_prox_flexion saturation')
  else sat_prop8 > 0.03
      disp('high levels of thumb_prox_flexion saturation')
  end

for thumb_prox_abduction_r = joint_data(20,:);
  low_sat = find(thumb_prox_abduction_r == -60);
  high_sat = find(thumb_prox_abduction_r == 60);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop9 = total_sat/length(thumb_prox_abduction_r); 
end
  if sat_prop9 < 0.03 
      disp('low levels of thumb_prox_abduction saturation')
  else sat_prop9 > 0.03
      disp('high levels of thumb_prox_abduction saturation')
  end


for thumb_mid_flexion_r = joint_data(21,:);
  low_sat = find(thumb_mid_flexion_r == -20);
  high_sat = find(thumb_mid_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop10 = total_sat/length(thumb_mid_flexion_r); 
end
  if sat_prop10 < 0.03 
      disp('low levels of thumb_mid_flexion saturation')
  else sat_prop10 > 0.03
      disp('high levels of thumb_mid_flexion saturation')
  end

for thumb_distal_flexion_r = joint_data(22,:);
  low_sat = find(thumb_distal_flexion_r == -20);
  high_sat = find(thumb_distal_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop11 = total_sat/length(thumb_distal_flexion_r); 
end
  if sat_prop11 < 0.03 
      disp('low levels of thumb_distal_flexion saturation')
  else sat_prop11 > 0.03
      disp('high levels of thumb_distal_flexion saturation')
  end

for index_prox_flexion_r = joint_data(23,:);
  low_sat = find(index_prox_flexion_r == -75);
  high_sat = find(index_prox_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop12 = total_sat/length(index_prox_flexion_r); 
end
  if sat_prop12 < 0.03 
      disp('low levels of index_prox_flexion saturation')
  else sat_prop12 > 0.03
      disp('high levels of index_prox_flexion saturation')
  end

for index_prox_abduction_r = joint_data(24,:);
  low_sat = find(index_prox_abduction_r == -60);
  high_sat = find(index_prox_abduction_r == 60);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop13 = total_sat/length(index_prox_abduction_r); 
end
  if sat_prop13 < 0.03 
      disp('low levels of index_prox_abduction saturation')
  else sat_prop13 > 0.03
      disp('high levels of index_prox_abduction saturation')
  end

for index_mid_flexion_r = joint_data(25,:);
  low_sat = find(index_mid_flexion_r == -20);
  high_sat = find(index_mid_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop14 = total_sat/length(index_mid_flexion_r);
end
  if sat_prop14 < 0.03 
      disp('low levels of index_mid_flexion saturation')
  else sat_prop14 > 0.03
      disp('high levels of index_mid_flexion saturation')
  end

for index_distal_flexion_r = joint_data(26,:);
  low_sat = find(index_distal_flexion_r == -20);
  high_sat = find(index_distal_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop15 = total_sat/length(index_distal_flexion_r); 
end
  if sat_prop15 < 0.03 
      disp('low levels of index_distal_flexion saturation')
  else sat_prop15 > 0.03
      disp('high levels of index_distal_flexion saturation')
  end

for middle_prox_flexion_r = joint_data(27,:);
  low_sat = find(middle_prox_flexion_r == -75);
  high_sat = find(middle_prox_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop16 = total_sat/length(middle_prox_flexion_r); 
end
  if sat_prop16 < 0.03 
      disp('low levels of middle_prox_flexion saturation')
  else sat_prop16 > 0.03
      disp('high levels of middle_prox_flexion saturation')
  end

for middle_prox_abduction_r = joint_data(28,:);
  low_sat = find(middle_prox_abduction_r == -45);
  high_sat = find(middle_prox_abduction_r == 45);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop17 = total_sat/length(middle_prox_abduction_r); 
end
  if sat_prop17 < 0.03 
      disp('low levels of middle_prox_abduction saturation')
  else sat_prop17 > 0.03
      disp('high levels of middle_prox_abduction saturation')
  end

for middle_mid_flexion_r = joint_data(29,:);
  low_sat = find(middle_mid_flexion_r == -75);
  high_sat = find(middle_mid_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop18 = total_sat/length(middle_mid_flexion_r); 
end
  if sat_prop18 < 0.03 
      disp('low levels of middle_mid_flexion saturation')
  else sat_prop18 > 0.03
      disp('high levels of middle_mid_flexion saturation')
  end
  
for middle_distal_flexion_r = joint_data(30,:);
  low_sat = find(middle_distal_flexion_r == -75);
  high_sat = find(middle_distal_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop19 = total_sat/length(middle_distal_flexion_r); 
end
  if sat_prop19 < 0.03 
      disp('low levels of middle_distal_flexion saturation')
  else sat_prop19 > 0.03
      disp('high levels of middle_distal_flexion saturation')
  end
  
for ring_prox_flexion_r = joint_data(31,:);
  low_sat = find(ring_prox_flexion_r == -75);
  high_sat = find(ring_prox_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop20 = total_sat/length(ring_prox_flexion_r); 
end
  if sat_prop20 < 0.03 
      disp('low levels of ring_prox_flexion saturation')
  else sat_prop20 > 0.03
      disp('high levels of ring_prox_flexion saturation')
  end

for ring_prox_abduction_r = joint_data(32,:);
  low_sat = find(ring_prox_abduction_r == -45);
  high_sat = find(ring_prox_abduction_r == 45);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop21 = total_sat/length(ring_prox_abduction_r);
end
  if sat_prop21 < 0.03 
      disp('low levels of ring_prox_abduction saturation')
  else sat_prop21 > 0.03
      disp('high levels of ring_prox_abduction saturation')
  end

for ring_mid_flexion_r = joint_data(33,:);
  low_sat = find(ring_mid_flexion_r == -20);
  high_sat = find(ring_mid_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop22 = total_sat/length(ring_mid_flexion_r); 
end
  if sat_prop22 < 0.03 
      disp('low levels of ring_mid_flexion saturation')
  else sat_prop22 > 0.03
      disp('high levels of ring_mid_flexion saturation')
  end

for ring_distal_flexion_r = joint_data(34,:);
  low_sat = find(ring_distal_flexion_r == -20);
  high_sat = find(ring_distal_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop23 = total_sat/length(ring_distal_flexion_r); 
end
  if sat_prop23 < 0.03 
      disp('low levels of ring_distal_flexion saturation')
  else sat_prop23 > 0.03
      disp('high levels of ring_distal_flexion saturation')
  end

for pinky_prox_flexion_r = joint_data(35,:);
  low_sat = find(pinky_prox_flexion_r == -75);
  high_sat = find(pinky_prox_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop24 = total_sat/length(pinky_prox_flexion_r); 
end
  if sat_prop24 < 0.03 
      disp('low levels of pinky_prox_flexion saturation')
  else sat_prop24 > 0.03
      disp('high levels of pinky_prox_flexion saturation')
  end

for pinky_prox_abduction_r = joint_data(36,:);
  low_sat = find(pinky_prox_abduction_r == -45);
  high_sat = find(pinky_prox_abduction_r == 45);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop25 = total_sat/length(pinky_prox_abduction_r); 
end
  if sat_prop25 < 0.03 
      disp('low levels of pinky_prox_abduction saturation')
  else sat_prop25 > 0.03
      disp('high levels of pinky_prox_abduction saturation')
  end

for pinky_mid_flexion_r = joint_data(37,:);
  low_sat = find(pinky_mid_flexion_r == -20);
  high_sat = find(pinky_mid_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop26 = total_sat/length(pinky_mid_flexion_r); 
end
  if sat_prop26 < 0.03 
      disp('low levels of pinky_mid_flexion saturation')
  else sat_prop26 > 0.03
      disp('high levels of pinky_mid_flexion saturation')
  end

for pinky_distal_flexion_r = joint_data(38,:);
  low_sat = find(pinky_distal_flexion_r == -20);
  high_sat = find(pinky_distal_flexion_r == 120);
  if isempty(low_sat) == 1
      low_sat = 0;
  end
  if isempty(high_sat) == 1
      high_sat = 0;
  end
  total_sat = low_sat(end) + high_sat(end);
  sat_prop27 = total_sat/length(pinky_distal_flexion_r); 
end
  if sat_prop27 < 0.03 
      disp('low levels of pinky_distal_flexion saturation')
  else sat_prop27 > 0.03
      disp('high levels of pinky_distal_flexion saturation')
  end

All_sats = [sat_prop1, sat_prop2, sat_prop3, sat_prop4, sat_prop5, sat_prop6, sat_prop7, sat_prop8, sat_prop9, sat_prop10, sat_prop11, sat_prop12, sat_prop13, sat_prop14, sat_prop15, sat_prop16, sat_prop17, sat_prop18, sat_prop19, sat_prop20, sat_prop21, sat_prop22, sat_prop23, sat_prop24, sat_prop25, sat_prop26, sat_prop27]; 
sat_mat_path = fullfile(MONKEYDIR,'mat','daily_metrics',day,'JointSatEval',rec,jointfile);
if ~exist(sat_mat_path)
        disp(['file path does not exist.  Creating']);
        mkdir(sat_mat_path)
end
cd(sat_mat_path)
save('joint_saturation_matrix.mat','All_sats','-mat')

if mean(All_sats) < 0.03
    disp('Low levels of saturation');
elseif 0.03 < mean(All_sats) < 0.1
    disp('Moderate levels of saturation, consider revising jnt file')
else mean(All_sats) > 0.1
    disp('High levels of saturation, revise jnt file')
end
