
function locations = choiceThresholdMovements(locations,threshold)
% Given either hand or eye data, detect whether the data passes a
% threshold and is deterined a movement in a direction
% 3 no movement, 1 right or up movement, 2 left or down movement

    locations(find(locations > threshold)) = threshold + 1;
    locations(find(locations < -threshold)) = threshold + 2;
    locations(intersect(find(locations < threshold),find(locations > -threshold))) = threshold + 3;
    locations = locations - threshold;
return