% Create a misplacement of a specific marker and recompute kinematic data
% with PyCGM2
% Author: M.Fonseca # May 2019
close all
clear all
clc


%% 1. Create virtual marke
% rs with Defined error - Define before computation
tic
% Modifiable
MARK1 = ('LKNE'); % MARK1: marker to misplace.
Er = [5, 10, 15, 20, 30]; % Er: error magnitudes in mm.
Error_dir = 'AP_ML'; % Error_dir: 'AP_ML' antero-posteior + medial lateral (e.g. LKNE, LANK);'AP_DP' antero-posteior + proximal distal; 'ML_PD' medial lateral + proximal distal (e.g Lasi);
SEGMENT.name = ('LFEMUR'); % SEGMENT: segment where the marker is used to define the LCS (FEMUR, PELVIS, TIBIA or FOOT).
SEGMENT.origin = ('LHJC'); % seg_origin: segment origin (e.g. midASIS for PELVIS, LHJC for left femur, LKJC for left tibia, LAJC for left foot)
original_datapath = 'D:\Marker Misplacement Simulation\Test\Original_Data\'; % Folder containing original data
data_path  = 'D:\GITLAB\Marker Misplacement PELVIS\Data\MIS_LKNE\'; % Folder hosting new modified data

SEGMENT.proximal = [SEGMENT.name, '_Z'];
SEGMENT.lateral  = [SEGMENT.name, '_Y'];
SEGMENT.anterior = [SEGMENT.name, '_X'];
b=1;
angle = [0; 45; 90; 135; 180; 225; 270; 315];

%% 2. Open .c3d files
% for each patient, open  1 static (SBNN) and 1 gait trial (GBNN)
patients   = dir([data_path,'*.c3d']);
[C3D_filenames, C3D_path, FilterIndex]=uigetfile({'*.C3D'},'Sélectionner les ficihers C3D ou GCD',original_datapath,'MultiSelect','on');
cd(original_datapath)

% Move and rename files
for i=1:length(C3D_filenames)
    copyfile(char(C3D_filenames{i}),data_path);
    C3D_filenames{i} = char(C3D_filenames{i});
end

%% 3. Compute Marker Misplacement + Kinematics
[Angles, MM, counter, Error] = MIS_Computation(C3D_filenames, MARK1, SEGMENT, Er, Error_dir, angle, b, data_path);
save Angles
cd(data_path)
%% 4. Calculate RMSD 
% compute the results and export RMSD, std and max and mean(over patients)
[T_RMSD, T_std, T_max, T_m_RMSD, T_m_max, m_RMSD, m_RMSD_pMagn, T_m_RMSD_pMagn, R]  = MIS_Res_RMSD(Angles, Error, Er, MM, counter); 

[RR, Table1] = MIS_table_RMSD(Angles, Error, Er, MM, counter, data_path, C3D_filenames); 
writetable(Table1, 'Table Results RMSD.xls');

%% 5. Polar Plot
Lable = {'     Ant', 'Ant + Dist', 'Dist', 'Post + Dist', 'Post', 'Post + Prox', 'Prox', 'Ant + Prox'};
LineColor = {'b', 'c', 'g', 'm', 'r'};
LineStyle = {'no', ':'};
LevelNum = 5;
maximo = 17;
figure(1)
MIS_PlotPolar(m_RMSD_pMagn, Error)

%% 6. Plot Curves of one subject 
% Containing only one direction 
C3D_filename = C3D_filenames{1}; % Define c3d file
%Define Angle 1 and 2 in degrees corresponding to existing angles used...
%for marker misplacement
Angle1 = 0; 
Angle2 = 180;
subject = 1; % number o the patient
% 
% figure(10)
% MIS_PlotCurves(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Hip', 'Ant Post')
% 
% figure(11)
% MIS_PlotCurves(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Knee', 'Ant Post')
% 
% figure(12)
% MIS_PlotCurves(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Ankle', 'Ant Post')

% or all combined
figure (2)
MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Hip', 'Ant Post', 1)
MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Knee', 'Ant Post', 2)
MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Ankle', 'Ant Post', 3)
% MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'FootProgress', 'Ant Post', 3)
%% 7.  Scatter Plot

anthro = MIS_anthropometric_data(C3D_filenames, data_path);                 % get anthropometric data
 Leg_length = zeros(1, length(anthro.subject));
 Knee_Width = zeros(1, length(anthro.subject));
 for i = 1:length(anthro.subject)
     Leg_length(i) = str2double(anthro.subject(i).Left_LegLength_mm);
     Knee_Width(i) = str2double(anthro.subject(i).Left_KneeWidth_mm);
 end
 
 % Case 1: Regression for each patient. Plot all regressions. Table with
 % mean values from the overral regressions
 figure(3)
 hold on
 for i = 1:10
    [correl_LL, C, Table2] = MIS_Correlation(Leg_length(i), R, Er, 6, 30, 'Leg length', i);   % correl = correlation between  error and leg_length normalized; norm_errors:
 end
 
 figure (4)
 % Case 2: Combine all values and perform a general regression. 
direction = 'Ant'; 
x_lim = 6;
y_lim = 30;
[Correl_all, C, Table_Correl] = MIS_Correlation_all(Leg_length, R, Er, x_lim, y_lim, counter, direction)

 
