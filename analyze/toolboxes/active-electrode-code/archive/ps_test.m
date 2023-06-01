function noise = ps_test( filename )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

load(filename)
start = 1.1e5;
stop = 8e5;
figure(1)
plot(Untitled.data(start:stop))
figure(2)
plot(detrend(Untitled.data(start:stop)))
ch0_std = std(detrend(Untitled.data(start:stop))) * 1000 * 1000;

figure(3)
plot(Untitled1.data(start:stop))
figure(4)
plot(detrend(Untitled1.data(start:stop)))
ch1_std = std(detrend(Untitled1.data(start:stop))) * 1000 * 1000;

figure(5)
plot(Untitled2.data(start:stop))
figure(6)
plot(detrend(Untitled2.data(start:stop)))
ch2_std = std(detrend(Untitled2.data(start:stop))) * 1000 * 1000;

figure(7)
plot(Untitled3.data(start:stop))
figure(8)
plot(detrend(Untitled3.data(start:stop)))
ch3_std = std(detrend(Untitled3.data(start:stop))) * 1000 * 1000;

figure(9)
plot(Untitled4.data(start:stop))
figure(10)
plot(detrend(Untitled4.data(start:stop)))
ch4_std = std(detrend(Untitled4.data(start:stop))) * 1000 * 1000;

figure(11)
plot(Untitled10.data(start:stop))
figure(12)
plot(detrend(Untitled10.data(start:stop)))
ch10_std = std(detrend(Untitled10.data(start:stop))) * 1000 * 1000;


noise = [ch0_std ch1_std ch2_std ch3_std ch4_std ch10_std];
end

