%GETDATA   save some fields from the mujoco data object
function data = getData()

% these are the fields of data we'll save
data_fields = {...
'ne'
'ncon'
'nflc'
'time'
'com'
'energy'
'qpos'
'qvel'
'qvel_next'
'act'
'act_dot'
'ctrl'
'qfrc_bias'
'qfrc_applied'
'qfrc_impulse'
'xpos'
'xmat'
'geom_xpos'
'geom_xmat'
'site_xpos'
'site_xmat'
'ten_wrapadr'
'ten_wrapnum'
'ten_length'
'wrap_obj'
'wrap_xpos'
'contact'
'con_id'}';

% get the field values
V		= cell(1,length(data_fields));
[V{:}]	= mj('get',data_fields{:});

% create a matlab struct
FV		= [data_fields; V];
data	= struct(FV{:});