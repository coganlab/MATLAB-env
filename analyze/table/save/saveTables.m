function [Table] = saveTables(Table,OverwriteFlag)
%
%  [Table] = saveTables(Table, OverwriteFlag)
%
%  OverwriteFlag = 1 Overwrite if saved.  0 = Do not overwrite if saved.
%                   Defaults to 0.

global MONKEYDIR

if nargin < 2; OverwriteFlag = 0; end

TableNameString = getTableNameString(Table.CondParams);

filemat = fullfile(MONKEYDIR, 'mat', ['Table.' TableNameString '.mat']);
if exist(filemat, 'file') && OverwriteFlag==0
    disp([filemat ' exists.  No overwrite'])
else
    if isempty(Table.Data.Values)
        Table = createTable(Table);
        save(filemat, 'Table','-v7.3');
    else
        save(filemat, 'Table','-v7.3');
    end
end