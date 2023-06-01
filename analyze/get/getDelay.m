function Delay = getDelay(Trials);
%
%  Delay = getDelay(Trials);
%

TO = getTargsOn(Trials); Go = getGo(Trials);
Delay = Go-TO;