function [] = plotGauss_color(mu1,mu2,var1,var2,covar,color)
%plotGauss(mu1,mu2,var1,var2,covar)
%
%PLOT A 2D Gaussian
%This function plots the given 2D gaussian on the current plot.

% This code was written by Sam Roweis, roweis@cns.caltech.edu.
% PLEASE DO NOT REDISTRIBUTE. TELL PEOPLE TO GET A COPY THEMSELVES
% FROM THE FTP SITE AT hope.caltech.edu in pub/roweis/EM
% You are free to use this code for any research BUT NOT COMMERCIAL purpose.


t = -pi:.01:pi;
k = length(t);
x = 3*sin(t);
y = 3*cos(t);

R = [var1 covar; covar var2];

[vv, dd] = eig(R);

A = real((vv * sqrt(dd))');
z = [x' y'] * A;

hold on;
plot(z(:,1)+mu1,z(:,2)+mu2,color);
plot(mu1,mu2,'w+');
hold off;
