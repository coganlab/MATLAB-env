figure('Units','normalized', ...    'Name','SPLINES', ...  'Color',[0.8 0.8 0.8], ...  'Position',[ 0.01375 0.20166 0.0925 0.52 ]);h1021=uimenu('Label','TP SPLINES');uimenu('Parent',h1021, ...  'Callback','help getpts', ...  'Label','getpts (base and targ)');uimenu('Parent',h1021, ...  'Callback','help thinplat', ...  'Label','thinplat');uimenu('Parent',h1021, ...  'Callback','help lstra', ...  'Label','Procrustes (lstra)');%baseuicontrol('Units','normalized', ...  'BackgroundColor',[ 0.175783932249943 0.959990844586862 0.134416723887999 ], ...  'Callback','figure;[base grps]=getpts',...  'Position',[0.156521739130435 0.803664921465969 0.695652173913043 0.120418848167539 ], ...  'String','base');%targetuicontrol('Units','normalized', ...  'BackgroundColor',[ 0.175783932249943 0.959990844586862 0.134416723887999 ], ...  'Callback','figure;[target grps]=getpts',...  'Position',[ 0.165217391304348 0.659685863874346 0.695652173913043 0.120418848167539 ], ...  'String','target');  uicontrol('Units','normalized', ...  'BackgroundColor',[ 0.175783932249943 0.959990844586862 0.134416723887999 ], ...  'Position',[ 0.165217391304348 0.520942408376963 0.704347826086957 0.117801047120419 ], ...  'Callback','figure;[warp,eval,evec,D,theta1,theta2] = thinplate(base,target,1,20);',...  'String','TPS');%sizefreeuicontrol('Units','normalized', ...  'BackgroundColor',[ 0.175783932249943 0.959990844586862 0.134416723887999 ], ...  'Position',[ 0.156521739130435 0.37434554973822 0.704347826086957 0.117801047120419 ], ...  'Callback','figure;lstra(base,target);title(''procrustes rotation'');',...  'String','Proc');%