function flag = isMultiunit(Session)
%
%  flag = isMultiunit(Session)
%

Type = sessType(Session);
if strcmp('Multiunit',Type)
	flag = 1;
else
	flag = 0;
end

