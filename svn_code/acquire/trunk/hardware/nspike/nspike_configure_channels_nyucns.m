function channels = nspike_configure_channels_nyucns
%
%
% this ugly for loop maps nspike channels 1-256 onto 1-256
i=1;
for twice = 0:1
    for group = 0:3
        for division = 0:7
            for channel = 0:3
                hw_num = (division * 16) + (group * 4) + channel;
                channels(i).hardware_number = hw_num; 
                i = i + 1;
             end
        end
    end
end 


for i = 1:128
  channels(i).filters = [1,11000];
  channels(i+128).filters = [500,11000];
end

