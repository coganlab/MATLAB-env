function flag = isSpike(Session)
%
%  flag = isSpike(Session)
%

Type = sessType(Session)
if strcmp(Type,'Spike')
	flag = 1;
else
	flag = 0;
end

