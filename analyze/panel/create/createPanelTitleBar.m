function createPanelTitleBar(Session, PlotParams)
%
%  createPanelTitleBar(Session, PlotParams)
%


global MONKEYNAME

axes('position',[PlotParams.Margins.Outer, ...
    1 - PlotParams.Margins.Outer - PlotParams.TitleBar.Height, ...
    1 - 2*PlotParams.Margins.Outer, ...
    PlotParams.TitleBar.Height]);
axis off;

SessionType = sessType(Session);
%BSArea = getBSArea(Session);
BSArea = {{''},{''},{''}};

SSess = splitSession(Session);

for iSess = 1:length(SSess)
    Sess = SSess{iSess};
    Type = getSessionType(Sess);
    switch Type
        case 'Spike'
            Day = Sess{1};
            Sys = sessTower(Sess);
            Sys = Sys{1};
            if iscell(Sys); Sys = Sys{1}; end
            Ch = sessElectrode(Sess);
            Cl = sessContact(Sess);
            SessNum = Sess{6};
            SessionString{iSess} = [MONKEYNAME ' Spike Session: ' num2str(SessNum) ...
                ' Day: ' Day ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ' Cell: ' num2str(Cl) ...
                ' Area: ' removeUnderscore(BSArea{1}{1})];
        case 'Multiunit'
            Day = Sess{1};
            Rec = Sess{2}{1};
            Sys = sessTower(Sess);
            Sys = Sys{1};
            if iscell(Sys); Sys = Sys{1}; end
            Ch = sessElectrode(Sess);
            SessNum = Sess{6};
            SessionString{iSess} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum) ...
                ' Day: ' Day ' Rec: ' Rec ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ...
                ' Area: ' removeUnderscore(BSArea{1}{1})];
        case 'Field'
            Day = Sess{1};
            Sys = sessTower(Sess);
            Sys = Sys{1};
            if iscell(Sys); Sys = Sys{1}; end
            Ch = sessElectrode(Sess);
            Depth = sessCellDepthInfo(Sess);
            Depth = Depth{1}(1);
            SessNum = Sess{6};
            SessionString{iSess} = [MONKEYNAME ' Field Session: ' num2str(SessNum) ...
                ' Day: ' Day ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ' Depth: ' num2str(Depth) ...
                ' Area: ' removeUnderscore(BSArea{iSess}{1})];
    end
end

h = text(0,0.5,SessionString{1});
set(h, 'VerticalAlignment','bottom');
if length(SessionString) > 1
    text(0,1,SessionString{2});
end
if length(SessionString) > 2
    text(0,1.5,SessionString{3});
end
if length(SessionString) > 3
    text(0,2,SessionString{4});
end

% global MONKEYNAME
% 
% axes('position',[PlotParams.Margins.Outer, ...
%     1 - PlotParams.Margins.Outer - PlotParams.TitleBar.Height, ...
%     1 - 2*PlotParams.Margins.Outer, ...
%     PlotParams.TitleBar.Height]);
% axis off;
% 
% SessionType = sessType(Session);
% %BSArea = sessBSArea(Session);
% BSArea = {{''},{''},{''}};
% 
% switch SessionType
%     case 'Spike'
%         Day = Session{1};
%         Sys = Session{3}{1};
%         Ch = Session{4};
%         Cl = Session{5}(1);
%         SessNum = Session{6};
%         SessionString{1} = [MONKEYNAME ' Spike Session: ' num2str(SessNum) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ' Cell: ' num2str(Cl) ...
% 	    ' Area: ' removeUnderscore(BSArea{1}{1})];
%     case 'Multiunit'
%         Day = Session{1};
%         Rec = Session{2}{1};
%         Sys = Session{3}{1};
%         Ch = Session{4};
%         SessNum = Session{6};
%         SessionString{1} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum) ...
%             ' Day: ' Day ' Rec: ' Rec ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ...
% 	    ' Area: ' removeUnderscore(BSArea{1}{1})];
%     case 'Field'
%         Day = Session{1};
%         Sys = Session{3}{1};
%         Ch = Session{4};
%         Depth = Session{5}{1}(1);
%         SessNum = Session{6};
%         SessionString{1} = [MONKEYNAME ' Field Session: ' num2str(SessNum) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys) ' Channel: ' num2str(Ch) ' Depth: ' num2str(Depth) ...
% 	    ' Area: ' removeUnderscore(BSArea{1}{1})];
%     case 'SpikeField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%      case 'MultiunitField'
%         Day = Session{1};
%         Rec = Session{2}{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Rec: ' Rec ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1)  ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%     case 'FieldField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Depth1 = Session{5}{1}(1);
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Field Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Depth: ' num2str(Depth1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth2 = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%     case 'SpikeSpike'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl1 = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Cl2 = Session{5}{2};
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Spike Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Cell: ' num2str(Cl2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%     case 'MultiunitMultiunit'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Multiunit Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Multiunit Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%     case 'SpikeMultiunit'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%     case 'SpikeFieldField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
%     case 'MultiunitFieldField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Rec = Session{2}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Rec: ' Rec ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1)  ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
%     case 'SpikeSpikeField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl1 = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Cl2 = Session{5}{2};
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Spike Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Cell: ' num2str(Cl2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
%     case 'MultiunitMultiunitField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Multiunit Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Multiunit Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
%     case 'SpikeMultiunitField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Cl = Session{5}{1};
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Spike Session: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Cell: ' num2str(Cl) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Multiunit Session: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
%     case 'FieldFieldField'
%         Day = Session{1};
%         Sys1 = Session{3}{1};
%         Ch1 = Session{4}(1);
%         Depth1 = Session{5}{1}(1);
%         SessNum1 = Session{6}(1);
%         SessionString{1} = [MONKEYNAME ' Field Session 1: ' num2str(SessNum1) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys1) ' Channel: ' num2str(Ch1) ' Depth: ' num2str(Depth1) ...
%             ' Area: ' removeUnderscore(BSArea{1}{1})];
%         Day = Session{1};
%         Sys2 = Session{3}{2};
%         Ch2 = Session{4}(2);
%         Depth2 = Session{5}{2}(1);
%         SessNum2 = Session{6}(2);
%         SessionString{2} = [MONKEYNAME ' Field Session 2: ' num2str(SessNum2) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys2) ' Channel: ' num2str(Ch2) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{2}{1})];
%         Day = Session{1};
%         Sys3 = Session{3}{3};
%         Ch3 = Session{4}(3);
%         Depth2 = Session{5}{2}(1);
%         SessNum3 = Session{6}(3);
%         SessionString{3} = [MONKEYNAME ' Field Session: ' num2str(SessNum3) ...
%             ' Day: ' Day ' Sys: ' removeUnderscore(Sys3) ' Channel: ' num2str(Ch3) ' Depth: ' num2str(Depth2) ...
%             ' Area: ' removeUnderscore(BSArea{3}{1})];
% end
% 
% h = text(0,0.5,SessionString{1});
% set(h, 'VerticalAlignment','bottom');
% if length(SessionString) > 1
%     text(0,1,SessionString{2});
% end
% if length(SessionString) > 2
%     text(0,1.5,SessionString{3});
% end
