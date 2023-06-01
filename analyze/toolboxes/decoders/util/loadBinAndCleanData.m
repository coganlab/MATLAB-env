function [s,c,d] = loadBinAndCleanData(date,sessions,files,dt)

for i = 1:length(sessions)
    for j = 1:length(files)
        eval(['load ' date '/' sessions{i} '/rec' sessions{i} '.' files{j} '.mat'])
        switch files{j}
            case 'Body.Joint'
                sess(i).cvr = Joint;
            case 'Body.Marker'
                sess(i).cvr = Marker;
            case {'L_PMd.pk','R_PMd.pk'}
                if length(sess) < i || ~isfield(sess(i),'pk') || isempty(sess(i).pk)
                    sess(i).pk = pk;
                else
                    sess(i).pk = [sess(i).pk pk];
                end
            otherwise
                error('I don''t normally deal with this kind of data!  Either this argument goes, or I do!')
        end
    end
end
[pk cvr] = mergeSessions(sess);
[s,c,d] = bin(pk,dt,cellfun(@transpose,cvr,'UniformOutput',0));
first = find(c(:,1)~=0&~isnan(c(:,1))&~isinf(c(:,1)),1);
last  = find(c(:,1)~=0&~isnan(c(:,1))&~isinf(c(:,1)),1,'last');
s = s(first:last,:);
c = c(first:last,:);
d = d(first:last,:);