function bsCheckAreaFields
%
%
%

global BSAREALIST

BS = BSAreaFields;

for iArea1 = 1:length(BSAREALIST)
    for iArea2 = 1:iArea1
        if iArea1~=iArea2
            Areas = intersect(BS.(BSAREALIST{iArea1}),BS.(BSAREALIST{iArea2}));
            if length(Areas)
                disp([BSAREALIST{iArea1} ' ' BSAREALIST{iArea2}]);
                Areas
            end
        end
    end
end

F = loadField_Database;
SN = getSessionNumbers(F);

disp('Missing fields')
setdiff(SN,BS.TotalFields)