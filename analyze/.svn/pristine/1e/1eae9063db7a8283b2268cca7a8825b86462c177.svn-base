function Sys = findSys(Trials, system_name)
%
% Find which trials correspond to system name
%
%	Sys = findSys(Trials, system_name)
%

Sys = zeros(1,length(Trials));

%data manipulation to get to the cell structures we are interested in
[drive_names{1:length(Trials)}] = deal(Trials.MT);
tmp_sys = [drive_names{:}];
sys = reshape(tmp_sys,length(drive_names{1}),length(tmp_sys)/length(drive_names{1}));

% The following gives backwards compatibility when the Sys field in the Session
% cell array only contains the first letter of the MT field.  In that case,
% we replace the short system_name with the full system name.
Sysnames = unique(sys);

if sum(strcmp(Sysnames,system_name)) == 0
    for iSysname = 1:length(Sysnames)
        FullSysname = Sysnames{iSysname};
        %if strcmp(FullSysname(1:length(system_name)),system_name)
        if strcmp(FullSysname(1:min(length(system_name),length(FullSysname))),system_name)
            system_name = FullSysname;
        else %deal with case of 'MT1' and 'MT_1'
            if strcmp(FullSysname(1:2),system_name(1:2)) && strcmp(FullSysname(end),system_name(end))
                system_name = FullSysname;
            end
        end
    end
end

% Now the same as before
for i = 1:length(Trials(1).MT)
    Sys(strcmp(sys(i,:),system_name)) = i;
end


% [Sys1{1:length(Trials)}] = deal(Trials.MT1);
% [Sys2{1:length(Trials)}] = deal(Trials.MT2);
% if(strcmp(Trials(1).MT1, 'Tower_1'))
%     Sys(strcmp(Sys1,'Tower_1')) = 1;
%     Sys(strcmp(Sys2,'Tower_1')) = 2;
% else
%     Sys(strcmp(Sys1,'PRR')) = 1;
%     Sys(strcmp(Sys2,'PRR')) = 2;
% end

