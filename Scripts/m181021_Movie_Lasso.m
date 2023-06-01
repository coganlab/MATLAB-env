for iChan=1:length(iiA2);gvalT(iChan,:)=smooth(sq(LassoVals(iiA2(iChan),:,1)),5);end;
tscale=linspace(-.5,1.5,40);
for iT=1:40;
    cfg=[];
    cfg.show_labels=false;   
cmap=zeros(30,3);
cmap(:,1)=linspace(1,0,30);
cmap(:,2)=linspace(0,1,30);
cmap(:,3)=linspace(1,0,30);
gval=gvalT(:,iT);
idx=iiA2;
grouping_idx=zeros(length(idx),1);
minval=-.3; %min(gval);
maxval=.3; %max(gval);
valRange=linspace(minval,maxval,30);
for iC=1:30;
    if iC==1
    ii=find(gval<minval);
    grouping_idx(idx(ii))=iC;
    elseif iC==30;
        ii=find(gval>maxval);
        grouping_idx(idx(ii))=iC;
    else
        ii=find(gval>valRange(iC-1) & gval<valRange(iC));
        grouping_idx(idx(ii))=iC;
    end
end
cfg.elec_colors=cmap;
% %  
%grouping_idx(1:704)=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{3}(iiPPos)))=1;
%grouping_idx(intersect(iiSig{1}(iiLPos),iiSig{2}(iiTNeg)))=2;
%grouping_idx(intersect(iiSig{3}(iiPPos),iiSig{2}(iiTNeg)))=3;

%grouping_idx(iiSig{3}(iiPNeg))=2;
%grouping_idx(iiSig{3})=3;
%grouping_idx(setdiff(totalActiveElecsJustDA,iiAC))=3;
%grouping_idx(iiA)=4;
% grouping_idx(ii6)=6;
%cfg.elec_size=150;
cfg.hemisphere='r';

plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);
%view(270,0) % LH
view(90,0); % RH
title([num2str(tscale(iT)) ' Time from Onset (s)']) 
% cfg.hemisphere='r';
% 
% %cfg.elec_colors=[1 1 1;0 1 0;0 0 1;1 0 0];
% plot_subjs_on_average_grouping(subj_labels, grouping_idx, 'fsaverage', cfg);




M(iT)=getframe(gcf);
   close
   display(iT);
end


M2=[];for iChan=1:40;M2=cat(2,M2,repmat(M(iChan),1,10));end;
% % write movie
 v=VideoWriter('Lex_Lasso2_03_RH.avi');
 open(v);
 writeVideo(v,M2);
 close(v);