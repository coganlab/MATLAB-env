% convert a mujoco .xml file to a binary .mjb file
function xml2mjb(filename)

% find file
filepath = which(filename);
if isempty(filepath)
	filepath = which([filename '.xml']);
end
if(isempty(filepath))
	error('could not find file.')
end

% find binary
switch mexext
	case 'mexw64'
		binfile	= 'mj_convert64.exe';
	case 'mexw32'
		binfile	= 'mj_convert32.exe';
	otherwise
		error('unsupported platform.')
end

% change directory
bin_dir = fileparts(which(binfile));
here  = cd;
cd(bin_dir);

% convert
for i = 1:size(filename,1)
	switch mexext
		case 'mexw64'
			cmd	= ['mj_convert64 ' filepath];
		case 'mexw32'
			cmd	= ['mj_convert32 ' filepath];
		otherwise
			error('unsupported platform.')
	end
	disp(cmd)
	system(cmd,'-echo');
end

%change back
cd(here);		

