function  [header, joint_data, joint_names] = parseJointFile(JointFilename,named)
% 
% [header, joint_data, joint_names] = parseJointFile(JointFilename, named)
% 

global experiment
MAXMARKERS = 60;

%disp('In parseJointFile')
disp(['Opening joint file: ' JointFilename]);
fid = fopen(JointFilename);

x = ''; i = 1; header = {};
while ~strcmp(x,'endheader')
    x = fgetl(fid);
    header{i} = x;
    i = i +1;
end
x = textscan(header{6},'%s');
nFrames = str2num(x{1}{2});
disp(['Number of frames detected: ' num2str(nFrames)]);

x = fgetl(fid);  % blank line

captions = textscan(fgetl(fid),'%s');
joint_names = captions{1};
joint_names = joint_names(3:end);

nJoint = length(joint_names);
disp(['Number of joint angles detected: ' num2str(nJoint)])

string = '%f%f';
for iJoint = 1:nJoint
    string = [string '%f'];
end
data = textscan(fid,string,'delimiter','\t','EmptyValue',-Inf);
joint_data = cell2mat(data)';

if(~named)
    tmp = sum(joint_data' == -Inf);
    frames = size(joint_data,2);
    empty_columns = (tmp == frames);
    max_column = max(find(empty_columns == 0));
    joint_data = joint_data(1:max_column,:);
end
fclose(fid);


%disp('Leaving parseJointFile')