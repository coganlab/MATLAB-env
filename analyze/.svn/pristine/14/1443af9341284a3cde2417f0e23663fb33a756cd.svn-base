function [pk cvr] = mergeSessions(sess)
% Takes pk (peak) and cvr (covariate) files recorded across different 
% sessions and merges them into one.

pk = cell(size(sess(1).pk));
cvr = cell(size(sess(1).cvr));
t = 0;
for i = 1:length(sess)
    for j = 1:length(sess(i).pk)
        foo = sess(i).pk{j};
        pk{j} = [pk{j};[foo(:,1)+t,foo(:,2)]];
    end
    
    for j = 1:length(sess(i).cvr)
        foo = sess(i).cvr{j};
        cvr{j} = [cvr{j}, [foo(1,:)+t;foo(2,:)]];
    end
    t = t + sess(i).cvr{1}(1,end);
end