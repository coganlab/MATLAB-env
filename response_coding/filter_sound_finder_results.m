sfr = scantext('sound_finder_results.txt', '\t', 0, '%f%f%s');
cue_events = scantext('cue_events.txt', '\t', 0, '%f%f%s');

% remove events that overlap with stimulus cue
fid = fopen('filtered_sound_finder_results.txt', 'w');
for s = 1:numel(sfr{1})
    mask1 = sfr{1}(s) < cue_events{2};
    mask2 = sfr{2}(s) > cue_events{1};
    if sum(mask1 & mask2) == 0 && (sfr{2}(s) - sfr{1}(s)) > .1
        fprintf(fid, '%f\t%f\t%s\n', sfr{1}(s), sfr{2}(s), sfr{3}{s});
    end
end
fclose(fid);