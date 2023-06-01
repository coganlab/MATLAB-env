function Fig=DetectISacc(Fig,iFig)

% Detects if current fig has a Horz or Vert ISacc and 
% optionally throws out directions along the interevening 
% saccade axis if the NoIntSaccAxisGraphs field is set to 1
% and trials with those directions exist

Fig(iFig).VertISacc=0;
Fig(iFig).HorzISacc=0;
if any(Fig(iFig).ITs)
    if any(Fig(iFig).ITs==1|Fig(iFig).ITs==5)
        Fig(iFig).HorzISacc=1;
        if Fig(iFig).NoIntSaccAxisGraphs
            if any(Fig(iFig).dirs==1|Fig(iFig).dirs==5)
                disp('Detected trials with targets along horizontal interevening saccade axis. Throwing these out.')
                Fig(iFig).dirs=Fig(iFig).dirs(find(Fig(iFig).dirs~=1&Fig(iFig).dirs~=5));
            end
        end
    end
    if any(Fig(iFig).ITs==3|Fig(iFig).ITs==7)
        Fig(iFig).VertISacc=1;
        if Fig(iFig).NoIntSaccAxisGraphs
            if any(Fig(iFig).dirs==3|Fig(iFig).dirs==7)
                disp('Detected trials with targets along vertical interevening saccade axis. Throwing these out.')
                Fig(iFig).dirs=Fig(iFig).dirs(find(Fig(iFig).dirs~=3&Fig(iFig).dirs~=7));
            end
        end
        
    end
end 