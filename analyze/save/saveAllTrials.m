function saveAllTrials(
%
%   saveAllTrials()
%   Runs saveTrials for all days of a particular monkey


days = getRecordingDays;

for i =1:length(days)
   try saveTrials(days(i).name);
   catch
   end
end