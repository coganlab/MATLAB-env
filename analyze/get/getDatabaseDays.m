function day = getDatabaseDays(Database, int)

% function day = getDatabaseDays(Database, int)
% Database = Database from which to pull days
% int = [1 6] - which database entries we want to pull


Alldays = Database;

day = {};

for i = int(1):int(2)
   day = [day Alldays{i}{1}];
end




