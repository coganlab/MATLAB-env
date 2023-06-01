function nyu_plot2(surf_brain,sph,elec,elecname,color,label,alpha,marksize,sub2,hemi)
nyumc;




if ~exist('color','var')
    color = 'w';
end
if ~exist('label','var')
    label = 2;
end
if ~exist('alpha','var')
    alpha = 1;
end
if ~exist('marksize','var')
    marksize = 11.3;
end

figure;

%col = [.7 .7 .7];
if strcmp(sph,'both')
    sub_sph1.vert = surf_brain.sph1.coords;
    sub_sph1.tri = surf_brain.sph1.faces;

    sub_sph2.vert = surf_brain.sph2.coords;
    sub_sph2.tri = surf_brain.sph2.faces;
    
    %col1=repmat(col(:)', [size(sub_sph1.vert, 1) 1]);
    %col2=repmat(col(:)', [size(sub_sph2.vert, 1) 1]);
    %load([NYUMCDIR '/NY226/surf/colormatrix.mat']);
    
    colormatrix=colorgen(sub2,hemi);
    col1=colormatrix;
    col2=colormatrix;
    trisurf(sub_sph1.tri, sub_sph1.vert(:, 1), sub_sph1.vert(:, 2),sub_sph1.vert(:, 3),...
    'FaceVertexCData', col1,'FaceColor', 'interp','FaceAlpha',alpha);
    hold on;
    trisurf(sub_sph2.tri, sub_sph2.vert(:, 1), sub_sph2.vert(:, 2), sub_sph2.vert(:, 3),...
    'FaceVertexCData', col2,'FaceColor', 'interp','FaceAlpha',alpha);
    
%     trisurf(sub_sph1.tri, sub_sph1.vert(:, 1), sub_sph1.vert(:, 2),sub_sph1.vert(:, 3),...
%         'FaceVertexCData', col1,'FaceAlpha',alpha);
%     hold on;
%     trisurf(sub_sph2.tri, sub_sph2.vert(:, 1), sub_sph2.vert(:, 2), sub_sph2.vert(:, 3),...
%         'FaceVertexCData', col2,'FaceAlpha',alpha);
    
else    
    if isfield(surf_brain,'coords')==0
        sub.vert = surf_brain.surf_brain.coords;
        sub.tri = surf_brain.surf_brain.faces;
    else
        sub.vert = surf_brain.coords;
        sub.tri = surf_brain.faces;
    end
    %col=repmat(col(:)', [size(sub.vert, 1) 1]);
    %col=load([NYUMCDIR '/NY226/surf/colormatrix.mat']);
     colormatrix=colorgen(sub2,hemi);
    col=colormatrix;
    %   color=col.colormatrix % arg
%     trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
%     'FaceVertexCData', col,'FaceColor', 'interp','FaceAlpha',alpha);
trisurf(sub.tri, sub.vert(:, 1), sub.vert(:, 2), sub.vert(:, 3),...
        'FaceVertexCData', col,'FaceColor','flat');

end

shading interp;
lighting gouraud;
material dull;
light;
axis off
hold on;
for i=1:length(elec)
    plot3(elec(i,1),elec(i,2),elec(i,3),[color 'o'],'MarkerFaceColor',color,'MarkerSize',marksize);
    if label==1
        text('Position',[elec(i,1) elec(i,2) elec(i,3)],'String',elecname(i,:),'Color','w', 'FontSize', 24);
    end
end
set(light,'Position',[-1 0 1]); 
    if strcmp(sph,'lh')
        view(270, 0);      
    elseif strcmp(sph,'rh')
        view(90,0);        
    elseif strcmp(sph,'both')
        view(90,90);
    end
    if strcmp(hemi,'lh')
        view(270,0);
    end
%set(gcf, 'color','black','InvertHardCopy', 'off');
axis tight;
axis equal;
end