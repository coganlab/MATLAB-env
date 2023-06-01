function newtal4=talconvert4(sub,TalairachXFM)

% input new transform from talcovert3 and subject's coordinates and outputs
% new avg.
nyumc
% filename=[NYUMCDIR '/' sub '/mri/transforms/talairach.xfm'];
% fid=fopen(filename,'r');
% gotit = 0;
% string2match='Linear_Transform';
% for i=1:20
%     temp=fgetl(fid);
%     if strmatch(string2match,temp),
%         gotit = 1;
%         break;
%     end
% end
%     
%     if gotit,
%     TalairachXFM = fscanf(fid,'%f',[4,3])';
%     TalairachXFM(4,:)=[0 0 0 1];
%     fclose(fid);
%     else
%    fclose(fid);
%    error('fail2')
%     end

    %  read coordinates
    filename2dir=[NYUMCDIR '/' sub '/loc/'];
    filename2dir2=dir([filename2dir '/*_T1_*.txt']);
    fid = fopen([filename2dir filename2dir2.name]);
    elec_all = textscan(fid,'%s %f %f %f %s');
    elec_cell = [elec_all{1},num2cell(elec_all{2}),num2cell(elec_all{3}),num2cell(elec_all{4})];
    
    if isempty(char(elec_all{5}(:)))
    g = strmatch('G',upper(elec_cell(:,1)));
    d = strmatch('D',upper(elec_cell(:,1)));
else
    g = strmatch('G',upper(elec_all{5}));
    d = strmatch('D',upper(elec_all{5}));
end

if ~isempty(g) && ~isempty(d)
    elec_grid = elec_cell(g,:);
    elec_depth = elec_cell(d,:);
    elec_cell([g;d],:) = [];    
elseif isempty(d)
    elec_depth = [];
    elec_grid = elec_cell(g,:);
    elec_cell(g,:) = [];
elseif isempty(g)
    elec_grid = [];
    elec_depth = elec_cell(d,:);
    elec_cell(d,:) = [];
end

elec_grid=elec_grid(:,2:4);
elec_grid=cell2num(elec_grid);
elec_grid=cat(2,elec_grid,ones(64,1));

newtal4=TalairachXFM*elec_grid';


