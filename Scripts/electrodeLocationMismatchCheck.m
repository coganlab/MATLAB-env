lengthMismatchIdx=[];
counterL=0;
elecMismatchIdx=[];
counterE=0;
for iS=1:length(subjs_S);
    fid = fopen([RECONDIR '/' subjs_S{iS} '/elec_recon/' subjs_S{iS} '.electrodeNames'], 'rt');
    elecNames = textscan(fid, '%s %*[^\n]', 'headerlines', 2);
    fclose(fid);
    elecNames=elecNames{1}';
    
    elecLocs={};
    fid = fopen([RECONDIR '/' subjs_S{iS} '/elec_recon/' subjs_S{iS} '_elec_locations_RAS.txt'], 'rt');
    elecLocsT = textscan(fid, '%s%s %*[^\n]');
    fclose(fid);
    for iE=1:size(elecLocsT{1},1)
        elecLocs(iE)=strcat(elecLocsT{1}(iE,:),elecLocsT{2}(iE,:));
    end
    
    if length(elecNames)~=length(elecLocs)
        display([subjs_S{iS} ' Length Mismatch!'])
        lengthMismatchIdx(counterL+1)=iS;
        counterL=counterL+1;
    end
    
    for iE=1:length(elecNames)
        if ~strcmp(elecLocs(iE),elecNames(iE))
            display([subjs_S{iS} ' Electrode Mismatch!']);
    elecMismatchIdx(counterE+1,1)=iS;
    elecMismatchIdx(counterE+1,2)=iE;
    counterE=counterE+1;
        end
    end
    display(iS)
end

        
    
    
    elecNames=importdata([RECONDIR '/' subjs_S{iS} '/elec_recon/' subjs_S{iS} '.electrodeNames']);