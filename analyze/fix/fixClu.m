function fixClu(day, rec, sys, ch)
%
%  fixClu(day, rec, sys, ch)
%

global MONKEYDIR

                load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat']);
            load([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.pk.mat']);


            clu1ind = find(clu{ch}(:,2) == 1);

                if length(clu1ind) == size(clu{ch},1)
                    clu{ch} = [];
                    clu{ch}(:,1) = pk{ch}(:,1);
                    clu{ch}(:,2) = 1;
                    save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu')
                    clu1ind = find(clu{ch}(:,2) == 1);
                else %Some clu leave off the last few spikes. Add them as clu = 1
                    ind = find(clu{ch}(:,1) == pk{ch}(1:size(clu{ch},1),1));
                    if length(ind) == size(clu{ch},1)
                        clear tmp
                        tmp(:,1) = pk{ch}(:,1);
                        tmp(:,2) = 1;
                        tmp(1:length(ind),2) = clu{ch}(:,2);
                        clu{ch} = tmp;
                        save([MONKEYDIR '/' day '/' rec '/rec' rec '.' sys '.clu.mat'],'clu')
                        clu1ind = find(clu{ch}(:,2) == 1);
                    else %There's something wrong. Resort!
                        clu
                        pk
                        day
                        rec
                        sys
                        ch
                        disp(['There is something wrong. Resort!']);
                        pause
                    end
                end

