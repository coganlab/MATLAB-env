function camlight_follow(cax)
    cax.ButtonDownFcn = @buttondownfcn;  % assign callback
    cax.NextPlot = 'add';
    hittest_off(cax, 1);
    c = camlight('headlight');              % add light
    set(c,'style','infinite');              % set style of light

    function buttondownfcn(ax,~)
        fig = ancestor(ax,'figure');        % get figure handle
        [oaz, oel] = view(ax);              % get current azimuth and elevation
        oloc = get(0,'PointerLocation');    % get starting point
        set(fig,'windowbuttonmotionfcn',{@rotationcallback,ax,oloc,oaz,oel});
        set(fig,'windowbuttonupfcn',{@donecallback});
    end

    function rotationcallback(~,~,ax,oloc,oaz,oel)
        locend = get(0, 'PointerLocation'); % get mouse location
        dx = locend(1) - oloc(1);           % calculate difference x
        dy = locend(2) - oloc(2);           % calculate difference y
        factor = 2;                         % correction mouse -> rotation
        newaz = oaz-dx/factor;              % calculate new azimuth
        newel = oel-dy/factor;              % calculate new elevation
        view(ax,newaz,newel);               % adjust view
        c = camlight(c,'headlight');        % adjust light
    end

    function donecallback(src,~)
        fig = ancestor(src,'figure');           % get figure handle
        set(fig,'windowbuttonmotionfcn',[]);    % unassign windowbuttonmotionfcn
        set(fig,'windowbuttonupfcn',[]);        % unassign windowbuttonupfcn
    end

end