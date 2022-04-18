load trigger.mat;
h = edfread_fast(edf_filename);
% trigger = -trigger; % triggers should be pointing up, if they are pointing down, then (un)comment this line
figure; plot(trigger);gca_fast;gca_click;


%% find areas surrounding triggers and set to zero
to_zero = [1:2.69e6 ...
   5.3e6:length(trigger)];
trigger(to_zero) = 0;
figure; plot(trigger);gca_fast;gca_click;


%% identify triggers
thresh = 2.25e5; % change this accordingly
freq = h.frequency(1); % change this accordingly
seconds_between_triggers = 1; % change this accordingly

num_samples_between_triggers = seconds_between_triggers * freq; % 2 seconds

trigs = find(trigger >= thresh); % find all points above thresh
diff_trigs = diff(trigs); % find difference between points
big_trigs = find(diff_trigs > num_samples_between_triggers); % get indices of only big gaps
trigTimes = [trigs(1) trigs(big_trigs+1)]; % combine the first trig index and each big-gap index

%trigTimes = trigTimes(1:2:end);

 
% show trigs on current axis
plottrigtimes(trigTimes, thresh, [1 0 0]);

%% if triggers are correctly identified, then save
save('trigTimes', 'trigTimes');