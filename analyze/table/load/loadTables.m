function [Table] = loadTables(Table)
%
%  Table = loadTables(Table)
%
% You need to run your definition file first to get your table name.

global MONKEYDIR

TableNameString = getTableNameString(Table.CondParams);

filemat = fullfile(MONKEYDIR, 'mat', ['Table.' TableNameString '.mat']);
load(filemat);

