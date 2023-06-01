function [X,dims]=reduce(Y);
%REDUCE Take spatially organised multichannel ts data and string up space
%
%  [X, DIMS] = REDUCE(Y) 

%  Author: Bijan Pesaran, 15/10/98

sY=size(Y);

dims=sY(1:length(sY)-1);
X=reshape(Y,[prod(dims),sY(length(sY))]);

