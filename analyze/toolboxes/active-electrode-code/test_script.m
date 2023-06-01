
start = 17

for i = start:0.5:start + 10
convert2Movie (data, filename, i, i + 0.5, 0, numRow, numCol, Fs);
pause
end