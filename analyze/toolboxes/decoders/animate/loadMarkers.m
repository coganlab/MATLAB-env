function [s,c,d,n] = loadMarkers(path,rec)

addpath '../util'
path2 = [path '/' rec '/rec' rec];
load([path2 '.Body.Marker.mat'])
BodyMarker = Marker;
load([path2 '.Wand.Marker.mat'])
WandMarker = Marker;
load([path2 '.L_PMd.pk.mat'])
lpk = pk;
load([path2 '.R_PMd.pk.mat'])
pk = [pk lpk]; clear lpk

c = [];
d = [];

for i = 1:length(BodyMarker)
    fprintf('Binning Body Marker %u\n',i)
    [s,ci,di] = bin(pk,50,{BodyMarker{i}([1 2],:)', BodyMarker{i}([1 3],:)', BodyMarker{i}([1 4],:)'});
    c = [c,ci];
    d = [d,di];
end

for i = 1:length(WandMarker)
    fprintf('Binning Wand Marker %u\n',i)
    [s,ci,di] = bin(pk,50,{WandMarker{i}([1 2],:)', WandMarker{i}([1 3],:)', WandMarker{i}([1 4],:)'});
    c = [c,ci];
    d = [d,di];
end
[s,c,d] = clean(s,c,d);
n = length(BodyMarker);