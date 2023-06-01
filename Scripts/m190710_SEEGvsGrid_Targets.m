subjs_S={'D4','D8','D9','D12','D13','D14','D15','D17','D18','D20','D22','D23','D25','D27','D28','D29','D30','D31','D32','D33','D34','D35','D36','D38','D39','D41','D42','D43','D44','D45'};
subjs_G={'D2','D3','D5','D6','D7','D10','D16','D19','D21','D24','D26'};
elecsAll=list_electrodes(subjs_S);

counter=0;
counterL=0;
counterR=0;
subjs_L=subjs_S;
for iS=1:length(subjs_L);
    elecs=list_electrodes(subjs_L{iS});
    for iElec=1:length(elecs)
        tmp=erase(elecs{iElec},[subjs_L{iS} '-']);
        elecSide(iElec+counter)=tmp(1);
        if strcmp(tmp(1),'L')
            counterL=counterL+1;
        elseif strcmp(tmp(1),'R');
            counterR=counterR+1;
        end
    end
    counter=counter+length(elecs);
end
cfg=[];
cfg.hemisphere='l';
plot_elec_density(subjs_S,5,'fsaverage',cfg);
cfg.hemisphere='r';
plot_elec_density(subjs_S,1,'fsaverage',cfg);

cfg.hemisphere='l';
plot_elec_density(subjs_G,1,'fsaverage',cfg);
cfg.hemisphere='r';
plot_elec_density(subjs_G,1,'fsaverage',cfg);