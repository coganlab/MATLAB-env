trigger = (decimate(double(ConvertedData.Data.MeasuredData(1,3).Data > 2),625) > 0.05);

trigger = double(trigger)';


data4 = [data ; trigger];

