function Channels = createChannels(Subject)
% Subject = Subject Name
% Channels = list of good channels
if strcmp(Subject,'D1')
    Channels = [1:66];
elseif  strcmp(Subject,'D3')
    Channels = [1:52];
    badChans=[12];
    Channels=setdiff(Channels,badChans);
elseif  strcmp(Subject,'D5')
    Channels = [1:44]; 
elseif  strcmp(Subject,'D7')
    Channels = [1:102];
 %   Channels = [17:80]; % just grid    
elseif strcmp(Subject,'D8')
    Channels = [1:110];
elseif strcmp(Subject,'D9')
    Channels = [1:120]; 
elseif strcmp(Subject,'D11')
    Channels = [1:118];      
elseif strcmp(Subject,'D12')
    Channels = [1:110];
elseif strcmp(Subject,'D13')
    Channels = [1:120];
 %   AnalParams.ReferenceChannels=[18:20];
 elseif strcmp(Subject,'D14')
    Channels = [1:120];
 elseif strcmp(Subject,'D15')
    Channels = [1:120];
  %  AnalParams.ReferenceChannels=[62:63,105:106];
elseif strcmp(Subject,'D16')
    Channels = [1:41];
elseif strcmp(Subject,'S1');
   % Channels=[1:256];
    Channels=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
elseif strcmp(Subject,'D17');
    Channels=[1:114];
elseif strcmp(Subject,'D18');
    Channels=[1:122];
elseif strcmp(Subject,'D19');
    Channels=[1:76];    
elseif strcmp(Subject,'S6');
   Channels=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
elseif strcmp(Subject,'D20');
    Channels=[1:120];
elseif strcmp(Subject,'D22');
    Channels=[1:100];
    badChans=[92];
    Channels=setdiff(Channels,badChans);
elseif strcmp(Subject,'D23');
        Channels=[1:121];
elseif strcmp(Subject,'D24');
        Channels=[1:52];
elseif strcmp(Subject,'D26');
    Channels=[1:60];        
elseif strcmp(Subject,'D27');
    Channels=[1:114];
  %  AnalParams.ReferenceChannels=[72,99,100];
elseif strcmp(Subject,'D28');
    Channels=[1:108];
    badChans=[77,78];
    Channels=setdiff(Channels,badChans);
elseif strcmp(Subject,'D29');
     Channels=[1:140]; % change to 140
     badChans=[67,70];
     Channels=setdiff(Channels,badChans);
else
    Channels = [1:64];
end