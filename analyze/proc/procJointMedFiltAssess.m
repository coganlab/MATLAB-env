function procJointMedFiltAssess(day, rec, jointfile)
% procJointsat(day, rec, jointfile)
% 
% Calculates the degree to which a median filter of 20 samples decreases
% the variance of the data
%
global MONKEYDIR

cd([MONKEYDIR '/' day '/' rec]);
load(['rec' rec '.Body.joint_names.mat'])
JOINTLIST = joint_names(10:34);
HANDJOINTLIST = JOINTLIST(8:end);

JointFilename = ['rec' rec '.' 'Body' '.' jointfile '.mocap.mot'];
[header,joint_data,joint_names]=parseJointFile(JointFilename,1);

for shoulder_elevation_r = joint_data(12,:)';
shoulder_elevation_filt = medfilt1(shoulder_elevation_r,20);

end

for elevation_angle_r = joint_data(13,:)';
elevation_angle_filt = medfilt1(elevation_angle_r,20);

end

for shoulder_rotation_r = joint_data(14,:)';
shoulder_rotation_filt = medfilt1(shoulder_rotation_r,20);

end

for elbow_flexion_r = joint_data(15,:)';
elbow_flexion_filt = medfilt1(elbow_flexion_r,20);

end

for pro_supination_r = joint_data(16,:)';
pro_supination_filt = medfilt1(pro_supination_r,20);

end

for wrist_flexion_r = joint_data(17,:)';
wrist_flexion_filt = medfilt1(wrist_flexion_r,20);

end

for wrist_deviation_r = joint_data(18,:)';
wrist_deviation_filt = medfilt1(wrist_deviation_r,20);

end

for thumb_prox_flexion_r = joint_data(19,:)';
thumb_prox_flex_filt = medfilt1(thumb_prox_flexion_r,20);

end

for thumb_prox_abduction_r = joint_data(20,:)';
thumb_prox_abd_filt = medfilt1(thumb_prox_abduction_r,20);

end

for thumb_mid_flexion_r = joint_data(21,:)';
thumb_mid_flex_filt = medfilt1(thumb_mid_flexion_r,20);

end

for thumb_distal_flexion_r = joint_data(22,:)';
thumb_dist_flex_filt = medfilt1(thumb_distal_flexion_r,20);

end

for index_prox_flexion_r = joint_data(23,:)';
index_prox_flex_filt = medfilt1(index_prox_flexion_r,20);

end

for index_prox_abduction_r = joint_data(24,:)';
index_prox_abd_filt = medfilt1(index_prox_abduction_r,20);

end

for index_mid_flexion_r = joint_data(25,:)';
index_mid_flex_filt = medfilt1(index_mid_flexion_r,20);

end

for index_distal_flexion_r = joint_data(26,:)';
index_dist_flex_filt = medfilt1(index_distal_flexion_r,20);

end

for middle_prox_flexion_r = joint_data(27,:)';
mid_prox_flex_filt = medfilt1(middle_prox_flexion_r,20);

end

for middle_prox_abduction_r = joint_data(28,:)';
mid_prox_abd_filt = medfilt1(middle_prox_abduction_r,20);

end

for middle_mid_flexion_r = joint_data(29,:)';
mid_mid_flex_filt = medfilt1(middle_mid_flexion_r,20);

end

for middle_distal_flexion_r = joint_data(30,:)';
mid_dist_flex_filt = medfilt1(middle_distal_flexion_r,20);

end

for ring_prox_flexion_r = joint_data(31,:)';
ring_prox_flex_filt = medfilt1(ring_prox_flexion_r,20);

end

for ring_prox_abduction_r = joint_data(32,:)';
ring_prox_abd_filt = medfilt1(ring_prox_abduction_r,20);

end

for ring_mid_flexion_r = joint_data(33,:)';
ring_mid_flex_filt = medfilt1(ring_mid_flexion_r,20);

end

for ring_distal_flexion_r = joint_data(34,:)';
ring_dist_flex_filt = medfilt1(ring_distal_flexion_r,20);

end

for pinky_prox_flexion_r = joint_data(35,:)';
pinky_prox_flex_filt = medfilt1(pinky_prox_flexion_r,20);

end

for pinky_prox_abduction_r = joint_data(36,:)';
pinky_prox_abd_filt = medfilt1(pinky_prox_abduction_r,20);

end

for pinky_mid_flexion_r = joint_data(37,:)';
pinky_mid_flex_filt = medfilt1(pinky_mid_flexion_r,20);

end

for pinky_distal_flexion_r = joint_data(38,:)';
pinky_dist_flex_filt = medfilt1(pinky_distal_flexion_r,20);

end

figure;
plot(shoulder_elevation_r,'r');
hold on;
plot(shoulder_elevation_filt);
fignum = gcf;
oldorient = orient(fignum);
pdfpath = fullfile(MONKEYDIR,'fig','daily_metrics',day,'JointFiltEval','MedFilt',rec,jointfile);
if ~exist(pdfpath)
        disp(['pdf path does not exist.  Creating']);
        mkdir(pdfpath)
end
cd(pdfpath)
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'shoulder_elevation.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(elevation_angle_r,'r');
hold on;
plot(elevation_angle_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'elevation_angle.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(shoulder_rotation_r,'r');
hold on;
plot(shoulder_rotation_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'shoulder_rotation.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(elbow_flexion_r,'r');
hold on;
plot(elbow_flexion_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'elbow_flexion.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(pro_supination_r,'r');
hold on;
plot(pro_supination_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'pro_supination.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(wrist_flexion_r,'r');
hold on;
plot(wrist_flexion_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'wrist_flexion.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(wrist_deviation_r,'r');
hold on;
plot(wrist_deviation_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'wrist_deviation.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(thumb_prox_flexion_r,'r');
hold on;
plot(thumb_prox_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'thumb_prox_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(thumb_prox_abduction_r,'r');
hold on;
plot(thumb_prox_abd_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'thumb_prox_abd.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(thumb_mid_flexion_r,'r');
hold on;
plot(thumb_mid_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'thumb_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(thumb_distal_flexion_r,'r')
hold on;
plot(thumb_dist_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'thumb_dist_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(index_prox_flexion_r,'r')
hold on;
plot(index_prox_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'index_prox_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(index_prox_abduction_r,'r')
hold on;
plot(index_prox_abd_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'index_prox_abd.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(index_mid_flexion_r,'r')
hold on;
plot(index_mid_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'index_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(index_distal_flexion_r,'r')
hold on;
plot(index_dist_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'index_dist_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(middle_prox_flexion_r,'r')
hold on;
plot(mid_prox_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'mid_prox_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(middle_prox_abduction_r,'r')
hold on;
plot(mid_prox_abd_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'mid_prox_abd.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(middle_mid_flexion_r,'r')
hold on;
plot(mid_mid_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'mid_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(middle_distal_flexion_r,'r')
hold on;
plot(mid_dist_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'mid_dist_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(ring_prox_flexion_r,'r')
hold on;
plot(ring_prox_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'ring_prox_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(ring_prox_abduction_r,'r')
hold on;
plot(ring_prox_abd_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'ring_prox_abd.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(ring_mid_flexion_r,'r')
hold on;
plot(ring_mid_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'ring_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(ring_distal_flexion_r,'r')
hold on;
plot(ring_dist_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'ring_dist_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(pinky_prox_flexion_r,'r')
hold on;
plot(pinky_prox_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'pinky_prox_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(pinky_prox_abduction_r,'r')
hold on;
plot(pinky_prox_abd_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'pinky_prox_abd.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(pinky_mid_flexion_r,'r')
hold on;
plot(pinky_mid_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'pinky_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');

figure;
plot(pinky_distal_flexion_r,'r')
hold on;
plot(pinky_dist_flex_filt);
fignum = gcf;
oldorient = orient(fignum);
disp('Printing to EPS');
orient(fignum,'landscape')
print(fignum,'-depsc2','~/ARandomFilename');
orient(fignum,oldorient);
disp('Printing to PDF');
cmd = ['LD_LIBRARY_PATH= epstopdf --outfile=' 'pinky_mid_flex.pdf' ' ~/ARandomFilename.eps'];
unix(cmd);
unix('rm ~/ARandomFilename.eps');
