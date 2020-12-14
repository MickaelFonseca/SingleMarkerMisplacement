% CHECK MISPLACEMENT
% 1. Add error
% 2. Calcule kinematics
% 3. Add inverse error
% 4. Calculate kinematics

% with PyCGM2
% Author: MFonseca # October 2019
close all
clear all
clc


%% 1. Create virtual marke
% rs with Defined error - Define before computation
% MAR1: marker to misplace.
% SEGMENT: segment where the marker is used to define the LCS.
% Er: error magnitudes in mm.
% Error_dir: 'AP_ML' antero-posteior + medial lateral (e.g. LKNE, LANK);'AP_DP' antero-posteior + proximal distal; 'ML_PD' medial lateral + proximal distal (e.g Lasi);
% seg_origin: segment origin
tic
MARK = {'LASI'};
Er = [30];
Error_dir = 'ML_DP';

SEGMENT.name = ('PELVIS');
SEGMENT.origin = ('midASIS');
SEGMENT.proximal = [SEGMENT.name, '_Z'];
SEGMENT.lateral  = [SEGMENT.name, '_Y'];
SEGMENT.anterior = [SEGMENT.name, '_X'];
b=1;
angle = [0];

%% 2. Open .c3d files
% for each patient, open  1 static and 1 gait trial

original_datapath = 'D:\Marker Misplacement Simulation\Test\Original_Data\';
data_path  = 'D:\GITLAB\Test\';
patients   = dir([data_path,'*.c3d']);
[C3D_filenames, C3D_path, FilterIndex]=uigetfile({'*.C3D'},'Sélectionner les ficihers C3D ou GCD',[strcat(original_datapath, '/')],'MultiSelect','on');
cd (original_datapath)

% Move and rename files
for i=1:length(C3D_filenames)
    copyfile(char(C3D_filenames{i}),data_path);
    C3D_filenames{i} = char(C3D_filenames{i});
end

%% 3. Compute Marker Misplacement + Kinematics
MIS_Compute_check(C3D_filenames, MARK, SEGMENT,  b, data_path);