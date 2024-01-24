load trigger.mat;
h = edfread_fast(edf_filename);
%trigger = -trigger; % triggers should be pointing up, if they are pointing down, then (un)comment this line
    % Pic Naming + Global Local Tasks will likely need to use this inverse trigger function!
figure; plot(trigger)

%% find areas surrounding triggers and set to zero
to_zero = [1:2.233e6 ...
   5.56e6:length(trigger)];
trigger(to_zero) = 0;
figure; plot(trigger); 


%% identify triggers
thresh = 2.25e5 ; % change this accordingly
freq = h.frequency(1); % change this accordingly
seconds_between_triggers = 1.5; % change this accordingly

num_samples_between_triggers = seconds_between_triggers * freq; % 2 seconds

trigs = find(trigger >= thresh); % find all points above thresh
diff_trigs = diff(trigs); % find difference between points
big_trigs = find(diff_trigs > num_samples_between_triggers); % get indices of only big gaps
trigTimes = [trigs(1) trigs(big_trigs+1)]; % combine the first trig index and each big-gap index

%trigTimes = trigTimes(1:2:end); % to get rid of double triggers (alternate) 
  
    % ^^ FOR UNIQUENESS POINT: Use 1 SECOND between so it doubles the total 
        % (to 960), then run the double triggers alternate command above to cut down to 480!
    % ^^ Will also likely need to use it for Lexical No Delay

%trigTimes = trigTimes(1:55:end); % this one keeps intervals of trigs
%trigTimes([1,2,3,etc.]) = []; % this one deletes specific trigs - KEY!
 
% show trigs on current axis
plottrigtimes(trigTimes, thresh, [1 0 0]);

%% if triggers are correctly identified, then save
save('trigTimes', 'trigTimes');