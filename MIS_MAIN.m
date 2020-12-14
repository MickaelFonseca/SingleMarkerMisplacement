% Create a misplacement of a specific marker and recompute kinematic data
% with PyCGM2
% Author: MFonseca # April 2019
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
MARK = {'LKNE'};
Magnitude = [5, 10, 15, 20, 30];
Error_dir = 'AP_ML';
SEGMENT.name = ('LFEMUR');
SEGMENT.origin = ('LHJC');
SEGMENT.proximal = [SEGMENT.name, '_Z'];
SEGMENT.lateral  = [SEGMENT.name, '_Y'];
SEGMENT.anterior = [SEGMENT.name, '_X'];
b=1;
angle1 = [0; 45; 90; 135; 180; 225; 270; 315];
angle2 = [0; 90; 180; 270];
%% 2. Open .c3d files
% for each patient, open  1 static and 1 gait trial

original_datapath = 'D:\GITLAB\MARK_MISP\MARK_MISP_DATA\TD\Data Healthy TD children\';
data_path  = 'D:\GITLAB\MARK_MISP\MARK_MISP_DATA\MARK_MISP_LKNE_TDC\';
patients   = dir([data_path,'*.c3d']);
[C3D_filenames, C3D_path, FilterIndex]=uigetfile({'*.C3D'},'Sélectionner les ficihers C3D ou GCD',[strcat(original_datapath, '/')],'MultiSelect','on');
cd (original_datapath)

% Move and rename files
for i=1:length(C3D_filenames)
    copyfile(char(C3D_filenames{i}),data_path);
    C3D_filenames{i} = char(C3D_filenames{i});
end
%% 3. Clean data 
% function to remove data (analogs, forces...)

MISP_Clean_c3d(C3D_filenames, data_path)
%% 3. Compute Marker Misplacement + Kinematics
if length(MARK) == 1
    [Angles, MM, counter, Error] = MIS_Compute(C3D_filenames, MARK, SEGMENT, Magnitude, Error_dir, angle1, b, data_path);
elseif length(MARK) == 2
    [Angles, MM1, MM2, counter, Error] = MIS_Compute2(C3D_filenames, MARK, SEGMENT, Magnitude, Error_dir, angle2, b, data_path);
else 
    disp('Invalid marker selection')
end
    save Angles


    