function dicom2nifti(D63,C:\Users\pa112\Desktop\MRI\D63\CT,'CT')

% 
%
% subj = subject name
% subjDir = directory of Subject
% type = 'MRI' or 'CT'
%
%
% Greg Cogan 2021

%dataFolder = 'C:\Users\pa112\Desktop\MRI\D57\'; 

% imageName = 'D57_MRI_2.25.123444207361176921870622712079757679756.dcm';
% 
% % Read in Dicom metadata
% dcmMetaData = dicominfo([dataFolder imageName]);

% MRI Files
 %mriFileNames = dir('D57_MRI_*');
 mriFileNames = dir([subjDir subj '_' type '_*']); 
for iImg  = 1:length(mriFileNames)
    mriImage(:,:,iImg) = dicomread([subjDir mriFileNames(iImg).name]);
    dcmMetaData=dicominfo([subjDir mriFileNames(iImg).name]);
    instanceNumber(iImg)=dcmMetaData.InstanceNumber;
end

[ii jj]=sort(instanceNumber);

mriImage = double(mriImage(:,:,jj));

mriImgNifti = make_nii(mriImage);

save_nii(mriImgNifti,[subjDir '\' subj '_' type '.nii']);

