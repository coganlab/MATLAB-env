matlab_dir = fileparts(mfilename('fullpath'));

addpath(matlab_dir);

addpath([matlab_dir filesep 'mex']);
addpath([matlab_dir filesep 'utilities']);
addpath([matlab_dir filesep 'iLQG']);

root_dir = matlab_dir(1:find(matlab_dir==filesep,1,'last'));
addpath([root_dir 'models']);
addpath([root_dir 'bin']);
