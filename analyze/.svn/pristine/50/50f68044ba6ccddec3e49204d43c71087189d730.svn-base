function SplitSess = splitSession(SplitSession)
%
%  SplitSess = splitSession(SplitSession)
%

global MONKEYNAME
for iComp = 1:length(SplitSession{6});
  SplitSess{iComp}{1} = SplitSession{1};
  SplitSess{iComp}{2} = SplitSession{2};
  SplitSess{iComp}{3} = SplitSession{3}{iComp};
  SplitSess{iComp}{4} = SplitSession{4}(iComp);
  SplitSess{iComp}{5} = SplitSession{5}(iComp);
  SplitSess{iComp}{6} = SplitSession{6}(iComp);
  if length(SplitSession)>6
    SplitSess{iComp}{7} = SplitSession{7};
  else
    SplitSess{iComp}{7} = MONKEYNAME;
  end
  %Handle MultiunitField sessions that put the fifth element in a cell for
  %some reason.
  if iscell(SplitSess{iComp}{5})
      if iscell(SplitSess{iComp}{5}{1})
          SplitSess{iComp}{5} = SplitSess{iComp}{5}{1};
      end
  end
  if length(SplitSession)>7
      if iscell(SplitSession{8})
          SplitSess{iComp}{8} = SplitSession{8}{iComp};
      else
          SplitSess{iComp}{8} = SplitSession{8};
      end
  else
      SplitSess{iComp}{8}{1} = sessType(SplitSess{iComp});
  end
end
