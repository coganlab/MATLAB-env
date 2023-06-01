function procPk(day,rec)
%
% procPk(day, rec);
%
% Generate pk files for a recording day.
%	Run before createMultiunit_Database
%	Run after procSp

if nargin < 2
    makePk(day);
else
    makePk(day,rec);
end
