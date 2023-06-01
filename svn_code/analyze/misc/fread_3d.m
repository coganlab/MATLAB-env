function X=fread_3d(fid,sz,length);
% FREAD_3D Read three-dimensional arrays
%   X = FREAD_3D(FID,SZ,LENGTH)
%

%  Author:  Bijan Pesaran
%

X=zeros(sz);
N=size(sz);
N=N(2);
for i=1:sz(N);
	tmp=fread(fid,sz([1:N-1]),length);
	X(:,:,i)=tmp;
end

