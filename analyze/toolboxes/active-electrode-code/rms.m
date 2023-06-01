

%
% Root-Mean-Square value(s) for input data
%
% Efficient MATLAB function for finding RMS values. Accepts N-Dimensional 
% matrices, and computes the column-wise RMS value for N>1, or across any 
% dimension dim if specified by the user.
% 
% Usage:        output = rms(input, dim)
%

% Hazem Saliba Baqaen. Hazem@brown.edu
% MATLAB 7.0
% Credit due to Duane Hanselman for important suggestions


function out = rms(in,dim)

if nargin == 1      % Default (no dim argument specified)
    dim = 1;
end

if nargin==1 && ndims(in)==2 && any(size(in)==1)        % Can replace this condition with nargin==1 && isvector(in) in MATLAB 7 or higher
    out = norm(in)/sqrt(length(in));        % Faster, but requires 1-Dim data vector
else
    out = sqrt(sum((in.^2),dim)/size((in),dim));        % Column-wise RMS for [row x column] array or matrix if dim = 1
end

% For increased speed it is advised to bypass the function call altogether
% and copy and paste part or all of the internal code into your program
