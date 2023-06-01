function Ind = sc32Ch2Ind(Ch)
%
%  Calculate the SC32 figure index for a channel index on the array.
%
%  Ind = sc32Ch2Ind(Ch)
%

Ch2Ind = [12,18,24,30,36,11,17,23,29,35,4,10,16,22,28,34,3,9,15,21,27,33,8,14,20,26,32,7,13,19,25,31];

Ind = Ch2Ind(Ch);
