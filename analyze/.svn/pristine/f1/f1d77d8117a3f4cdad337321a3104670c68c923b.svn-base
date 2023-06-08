% This is a script file not a function so this will use the same 
% workspace as the sessPotPSTH function.
% These are all vlues of things that the user might need to frequently
% adjust to change the plot, that I thought were handy to keep in one 
% file so one would know where to find everything when looking for it.

%Rasterplot Options


AllMarkers = {'StartAq';      %1
            'TargsOn';      %2
            'Go';           %3
            'SaccStart';    %4
            'ReachStart';   %5
            'TargAq';       %6
            'EffInstOn';       %7
            };
MarkerCode = {'gx';'c^';'cv';'ro';'r.';'g+';'go';'gx';'m.'; 'mx'};
SpecMarkers = 1:7;
%                [1 2 3 4 5 6 7 8 9 10]
SpecMarkerSize = [4 4 4 4 8 4 4 4 8 4] ;
IntSaccLabels{1} = 'L to R';
IntSaccLabels{2} = 'LL to UR';
IntSaccLabels{3} = 'D to U';
IntSaccLabels{4} = 'LR to UL';
IntSaccLabels{5} = 'R to L';
IntSaccLabels{6} = 'UR to LL';
IntSaccLabels{7} = 'U to D';
IntSaccLabels{8} = 'UL to LR';
UseMattscolordefs = 1;
ITcolors = 'kbm';    %Correspond to the different colors of ecah plot on each figure
HandEyeColors = 'kkbbmm';   %X/Y for first IntSacc dir, then X/Y for second IntSacc dir, etc.
CovAreaRatio = 1; %Additional Fraction of Hist y-axis to set apart for rasters
RasIntSpaceFrac = 0.1; %Fraction of raster space devoted to spacing in between rasters
numYTicks = 4; %Number of Ticks to add to the Histogram Y axis
MaxRasPerPlot = 25;

if ~exist('SessionType','var')
    SessionType = 'Spike';
end

%Set Title Properties
InitTitleInfo
Tit.Height = 0.1; %fraction of total figure's height for the top title bar
Tit.HorzBdr = 0.02; %Fraction of the title axis
Tit.VertBdr = 0.05;
Tit.linespace = 0.05;
Tit.numlines = 2;
Tit.numfields = [5,7];
for i = 1:Tit.numlines
    Tit.HorzPos{i} = Tit.HorzBdr+(1-2*Tit.HorzBdr)/Tit.numfields(i)*(0:Tit.numfields(i)-1);
    Tit.VertPos{i} = ones(Tit.numfields(i),1)*Tit.VertBdr+(1-2*Tit.VertBdr)/Tit.numlines*(Tit.numlines-i);
    Tit.fontsize{i} = ones(Tit.numfields(i),1)*(1-2*Tit.VertBdr-Tit.linespace*(Tit.numlines-1))/Tit.numlines;
end
Tit.TBSpace = 0; %Fraction of Figure's height between Title and Task bar
Tit.MaxQlength = 0.1;

Tit.qstr{1,1} = 'Monkey: ';
Tit.qstr{1,2} = 'RecType: ';
Tit.qstr{1,3} = 'db Cell#: ';
Tit.qstr{1,4} = 'Day:';
Tit.qstr{1,5} = 'Rec:';
Tit.qstr{2,1} = 'Sys: ';
Tit.qstr{2,2} = 'X: ';
Tit.qstr{2,3} = 'Y: ';
Tit.qstr{2,4} = 'Ch: ';
Tit.qstr{2,5} = 'Clu: ';
Tit.qstr{2,6}='Dpth:';
Tit.qstr{2,7}='Iso:';

Tit.astr{1,1} = mname;
Tit.astr{1,2} = rectype;
Tit.astr{1,3} = num2str(Sess{6});
Tit.astr{1,4} = Sess{1};
Tit.astr{1,5} = '';
for iRec = 1:length(Sess{2})
    Tit.astr{1,5} = [Tit.astr{1,5} Sess{2}{iRec} ' '];
end
Tit.astr{1,5} = Tit.astr{1,5}(1:end-1);
SysString = [''];
for iSess = 1:length(Sess{3})
    SysString = [SysString ':' Sess{3}{iSess}];
end
Tit.astr{2,1} = SysString;
% if strcmp(Sess{3},'P')
%     if strcmp(Rec.MT1, 'LIP')
%         Tit.astr{2,2} = num2str(Rec.X1);
%         Tit.astr{2,3} = num2str(Rec.Y1);
%     else
%         Tit.astr{2,2} = num2str(Rec.X2);
%         Tit.astr{2,3} = num2str(Rec.Y2);
%     end
% else
%     if strcmp(Rec.MT1, 'PRR')
%         Tit.astr{2,2} = num2str(Rec.X2);
%         Tit.astr{2,3} = num2str(Rec.Y2);
%     else
%         Tit.astr{2,2} = num2str(Rec.X1);
%         Tit.astr{2,3} = num2str(Rec.Y1);
%     end
% end

if(exist([MONKEYDIR '/' Sess{1} '/' Sess{2}{1} '/rec' Sess{2}{1} '.experiment.mat'],'file'))
    tower = findSys(Raw(1).Trials(1),Sess{3}{1});
    Tit.astr{2,2} = num2str(experiment.hardware.microdrive(tower).coordinate.x);
    Tit.astr{2,3} = num2str(experiment.hardware.microdrive(tower).coordinate.y);
else
    Tit.astr{2,2} = '0';
    Tit.astr{2,3} = '0';
end
Ch = sessElectrode(Sess);
Tit.astr{2,4} = num2str(Ch);
CellDepthString = [''];
Sess{5}
%pause
if iscell(Sess{5})
    for iSys = 1:length(Sess{5})
        CellDepthString = [CellDepthString num2str(Sess{5}{iSys}(1))];
    end
else
    CellDepthString = num2str(Sess{5}(1));
end
Tit.astr{2,5} = CellDepthString;
Tit.astr{2,6}=num2str(myRoundForDisp(Depth,0));
Tit.astr{2,7}=num2str(IsoQual);

% Set Title Field Offsets from even spacing
Tit.HorzPos{2}(7)=Tit.HorzPos{2}(7)+.03;


%Set Taskbar Properties
for iFig = 1:numfigs
    Fig(iFig).TB.Height  = 0.05; %Fraction of Total Figure's Height
    Fig(iFig).TB.HorzBdr = 0.05;
    Fig(iFig).TB.VertBdr = 0.15;
    Fig(iFig).TB.linespace = 0.05;
    Fig(iFig).TB.numlines = 1;
    Fig(iFig).TB.numfields = 6;
    for i = 1:Fig(iFig).TB.numlines
        Fig(iFig).TB.HorzPos{i} = Fig(iFig).TB.HorzBdr + ...
                                    (1-2*Fig(iFig).TB.HorzBdr)/Fig(iFig).TB.numfields(i)*(0:Fig(iFig).TB.numfields(i)-1);
        Fig(iFig).TB.VertPos{i} = ones(Fig(iFig).TB.numfields(i),1)*Fig(iFig).TB.VertBdr + ...
                                    (1-2*Fig(iFig).TB.VertBdr)/Fig(iFig).TB.numlines*(Fig(iFig).TB.numlines-i);
        Fig(iFig).TB.fontsize{i} = ones(Fig(iFig).TB.numfields(i),1)*...
                                    (1-2*Fig(iFig).TB.VertBdr-Fig(iFig).TB.linespace*(Fig(iFig).TB.numlines-1))/Fig(iFig).TB.numlines;
    end
    Fig(iFig).TB.MaxQlength=.1;
    
    Fig(iFig).TB.qstr{1,1}  = 'Task:';
    Fig(iFig).TB.qstr{1,2}  = 'ITs:';
    Fig(iFig).TB.qstr{1,3}  = 'Align Event:';
    Fig(iFig).TB.qstr{1,4}  = 'bn:';
    Fig(iFig).TB.qstr{1,5}  = 'number:';
    Fig(iFig).TB.qstr{1,6}  = 'sm:';
    
    Fig(iFig).TB.astr{1,1} = '';
    Fig(iFig).TB.astr{1,2} = '';
    
    for iTask = 1:length(Fig(iFig).Task)
        Fig(iFig).TB.astr{1,1} = [Fig(iFig).TB.astr{1,1} Fig(iFig).Task{iTask} ' '];
        Fig(iFig).TB.astr{1,2} = [Fig(iFig).TB.astr{1,2} num2str(Fig(iFig).ITs(iTask)) ' '];
    end
    
    Fig(iFig).TB.astr{1,1} = Fig(iFig).TB.astr{1,1}(1:end-1);
    Fig(iFig).TB.astr{1,2} = Fig(iFig).TB.astr{1,2}(1:end-1);
    Fig(iFig).TB.astr{1,3} = Field;
    Fig(iFig).TB.astr{1,4} = [num2str(bn) ' (ms)'];
    Fig(iFig).TB.astr{1,5} = num2str(number);
    Fig(iFig).TB.astr{1,6} = num2str(sm);
    
    %Set TaskBar  Offsets from even spacing
    Fig(iFig).TB.HorzPos{1}(2) = Fig(iFig).TB.HorzPos{1}(2) + 0.2;
    Fig(iFig).TB.HorzPos{1}(3) = Fig(iFig).TB.HorzPos{1}(3) + 0.15;
    Fig(iFig).TB.HorzPos{1}(6) = Fig(iFig).TB.HorzPos{1}(6) + 0.03;
    
    %Fig(iFig).TB.HorzPos{1}(5)=Fig(iFig).TB.HorzPos{1}(5)-.10;
    Fig(iFig).TB.HorzPos{1}(4:5) = Fig(iFig).TB.HorzPos{1}(6);
    Fig(iFig).TB.fontsize{1}(4:6) = 0.95/3 - Fig(iFig).TB.linespace;
    Fig(iFig).TB.VertPos{1}(6) = -0.05;
    Fig(iFig).TB.VertPos{1}(4) = Fig(iFig).TB.VertPos{1}(6) + ...
                                    2*(Fig(iFig).TB.fontsize{i}(4)+Fig(iFig).TB.linespace);
    Fig(iFig).TB.VertPos{1}(5) = Fig(iFig).TB.VertPos{1}(6) + ...
                                    (Fig(iFig).TB.fontsize{i}(4)+Fig(iFig).TB.linespace);
                                
    Fig(iFig).TB.LastColEntries = 3;                                
    
%     disp(['TB Horz Pos for Fig ' num2str(iFig) ' is :' num2str(Fig(iFig).TB.HorzPos{1})])
%     disp(['TB Vert Pos for Fig ' num2str(iFig) ' is :' num2str(Fig(iFig).TB.VertPos{1}')])

    %Some Legend Options- for the rest go to the specific Add functions for adding each type of legend
    Fig(iFig).HorzISaccLegHeight = 0.1;
    Fig(iFig).VertISaccLegWidth  = 0.1;

end
