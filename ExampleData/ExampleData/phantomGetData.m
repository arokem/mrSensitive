function [M01, boxSize, meanVal, t1, mask]= phantomGetData(boxsize,loc,smoothkernel)
% Load sample data from the phantom
%
%   [M01 boxSize meanVal,t1, mask ]= phantomGetData(boxsize,loc,smoothkernel)
%
%
% Helper routine to get the data

M0=readFileNifti(fullfile(mrSensitiveRootPath,'ExampleData','AgarPhantom' ,'M0','AllCoilsM0_phantomExample.nii.gz'));
M0=M0.data;

T1=readFileNifti(fullfile(mrSensitiveRootPath,'ExampleData','AgarPhantom','T1','T1_lsq_phantomExample.nii.gz'));
T1=T1.data;

Mask =readFileNifti(fullfile(mrSensitiveRootPath,'ExampleData','AgarPhantom' ,'M0','PhantomMask.nii.gz'));
Mask=logical(Mask.data);

if ~notDefined('smoothkernel')
    for ii=1:size(M0,4)
        tmp=M0(:,:,:,ii);
        M0(:,:,:,ii)=smooth3(tmp,'g',smoothkernel);
    end
        T1(:,:,:)=smooth3(T1,'g',smoothkernel);

end
    
    
% Define the neighborhood for the box based on its size
boxNeighbors = [-boxsize  -boxsize  -boxsize;  boxsize  boxsize    boxsize];

% This is the central voxel of the box
if     loc==1,     Cvoxel=[55 48 40];
elseif loc==2,     Cvoxel=[55 48 30];
elseif loc==3,     Cvoxel=[42 60 50];
elseif loc==4,     Cvoxel=[60 60 50];
elseif loc==5,     Cvoxel=[62 71 60];
    
    % location along the Y axes up to dwon
elseif loc==6,     Cvoxel=[30 60 45];
elseif loc==7,     Cvoxel=[45 60 45];
elseif loc==8,     Cvoxel=[60 60 45];
elseif loc==9,     Cvoxel=[75 60 45];
elseif loc==10,     Cvoxel=[90 60 45];
        
    
end

%Get the positions of the data box
XX(1) = Cvoxel(1) + boxNeighbors(1,1);
XX(2) = Cvoxel(1) + boxNeighbors(2,1);
YY(1) = Cvoxel(2) + boxNeighbors(1,2);
YY(2) = Cvoxel(2) + boxNeighbors(2,2);
ZZ(1) = Cvoxel(3) + boxNeighbors(1,3);
ZZ(2) = Cvoxel(3) + boxNeighbors(2,3);

% Pull out the data
M01 = M0(XX(1):XX(2),YY(1):YY(2),ZZ(1):ZZ(2),:);

% This is the size of the box
boxSize = size(M01);

% Sorting the M0 data according to the mean value of the data.
% Biggest SNR to smallest
[meanVal, coilIndex] = sort(squeeze(mean(mean(mean(M01)))),'descend');
M01     = M01(:,:,:,coilIndex);
meanVal = meanVal(coilIndex);

t1=T1(XX(1):XX(2),YY(1):YY(2),ZZ(1):ZZ(2));

mask=Mask(XX(1):XX(2),YY(1):YY(2),ZZ(1):ZZ(2));

end
