function channels=centralChannels(Subject);


if strcmp(Subject,'D1')
    AnalParams.Channel = [1:66];
elseif  strcmp(Subject,'D3')
    AnalParams.Channel = [1:52];
    badChans=[12];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
elseif  strcmp(Subject,'D5')
    AnalParams.Channel = [1:44];
elseif  strcmp(Subject,'D7')
    AnalParams.Channel = [1:102];
    %   AnalParams.Channel = [17:80]; % just grid
elseif strcmp(Subject,'D8')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject,'D9')
    AnalParams.Channel = [1:120];
elseif strcmp(Subject,'D11')
    AnalParams.Channel = [1:118];
elseif strcmp(Subject,'D12')
    AnalParams.Channel = [1:110];
elseif strcmp(Subject,'D13')
    AnalParams.Channel = [1:120];
    %   AnalParams.ReferenceChannels=[18:20];
elseif strcmp(Subject,'D14')
    AnalParams.Channel = [1:120];
elseif strcmp(Subject,'D15')
    AnalParams.Channel = [1:120];
    %  AnalParams.ReferenceChannels=[62:63,105:106];
elseif strcmp(Subject,'D16')
    AnalParams.Channel = [1:41];
elseif strcmp(Subject,'S1');
    % AnalParams.Channel=[1:256];
    AnalParams.Channel=setdiff(1:256,[2,32,64,66,96,128,130,160,192,194,224,256]);
elseif strcmp(Subject,'D17');
    AnalParams.Channel=[1:114];
elseif strcmp(Subject,'D18');
    AnalParams.Channel=[1:122];
elseif strcmp(Subject,'D19');
    AnalParams.Channel=[1:76];
elseif strcmp(Subject,'S6');
    AnalParams.Channel=setdiff(1:256,[12,32,53,66,96,128,130,160,192,204,224,245]);
elseif strcmp(Subject,'D20');
    AnalParams.Channel=[1:120];
elseif strcmp(Subject,'D22');
    AnalParams.Channel=[1:100];
elseif strcmp(Subject,'D23');
    AnalParams.Channel=[1:121];
elseif strcmp(Subject,'D24');
    AnalParams.Channel=[1:52];
elseif strcmp(Subject,'D26');
    AnalParams.Channel=[1:60];
elseif strcmp(Subject,'D27');
    AnalParams.Channel=[1:114];
    badChans=[1,2,21,22];
    AnalParams.Channel=setdiff(AnalParams.Channel,badChans);
  %  AnalParams.ReferenceChannels=[72,99,100];
elseif strcmp(Subject,'D28');
    AnalParams.Channel=[1:108];
    AnalParams.badChannels=[10,20,27,43,77,108];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);    
elseif strcmp(Subject,'D29');
    AnalParams.Channel=[1:140];
    AnalParams.badChannels=[8,56,133,136,137,140];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);
elseif strcmp(Subject,'D30')
    AnalParams.Channel=[1:104];
    AnalParams.badChannels=[12,19,36,37,80,82]; 
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);    
elseif strcmp(Subject,'D31')
    AnalParams.Channel=[1:160];
    AnalParams.badChannels=[9,17,67,68,40,117,148,149]; 
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject,'D33')
    AnalParams.Channel=[1:240];
  %  AnalParams.badChannels=[39,100,101,102,104,175,184,188];
    AnalParams.badChannels=[37,38,39,40,100,101,102,104,105,175,183,184,185,188,222];  
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject,'D34')
    AnalParams.Channel=[1:182];
    AnalParams.badChannels=[40,41,45,100,174];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);       
elseif strcmp(Subject,'D35')
    AnalParams.Channel=[1:174];
    AnalParams.badChannels= [8,26,37,38,39,40,54,79,80,81,82,155];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);           
elseif strcmp(Subject,'D36')
    AnalParams.Channel=[1:216];
    AnalParams.badChannels=[8,32,101,170];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);        
elseif strcmp(Subject,'D37')
    AnalParams.Channel=[1:180];
    AnalParams.badChannels=[89,92,157,158];
    AnalParams.badChannels=[61,76,87,88,89,90,92,93,157,158,179,180];
        AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels);      
elseif strcmp(Subject,'D38')
    AnalParams.Channel=[1:208];
    AnalParams.badChannels=[48,53,178,179,180,197,203];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
elseif strcmp(Subject,'D39')
    AnalParams.Channel=[1:238];
    AnalParams.badChannels=[107,120,121,123,124,125,126,159,213,235];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
elseif strcmp(Subject,'D41')
    AnalParams.Channel=[1:250];
    AnalParams.badChannels=[14,26,31,109,110,177,232];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
elseif strcmp(Subject,'D42')
    AnalParams.Channel=[1:176];
    AnalParams.badChannels=[19,138,142,143];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
elseif strcmp(Subject,'D44')
    AnalParams.Channel=[1:190];
    AnalParams.badChannels=[12,39,40,69,86,98,121,123,125,168,169,183];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
elseif strcmp(Subject,'D47')
    AnalParams.Channel=[1:225];
    AnalParams.badChannels=[7,15,27,34,112];
    AnalParams.Channel=setdiff(AnalParams.Channel,AnalParams.badChannels); 
else
    AnalParams.Channel = [1:64];
end