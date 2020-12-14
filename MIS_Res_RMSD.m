function [T_RMSD, T_std, T_max, T_m_RMSD, T_m_max, m_RMSD, m_RMSD_pMagn, T_m_RMSD_pMagn, R,T_m_RMSD_SD_10]  = MIS_Res_RMSD(Angles, Error, Er, MM, counter, direction, MARK, group)

% direction   = {'Ant', 'Ant_Prox', 'Prox', 'Post_Prox', 'Post', 'Post_Dist', 'Dist', 'Ant_Dist'};
% direction   = {'Lat', 'Lat_Prox', 'Prox', 'Med_Prox', 'Med', 'Med_Dist', 'Dist', 'Lat_Dist'};
 
for ii = 1:counter
    RMSD_peltilt = []; RMSD_pelobliq = []; RMSD_pelrot = [];
    RMSD_hipflex   = []; RMSD_hipadd = []; RMSD_hiprot    = [];
    RMSD_kneeflex  = []; RMSD_kneeadd = []; RMSD_kneerot   = [];
    RMSD_ankleflex = []; RMSD_ankleadd  = []; RMSD_anklerot  = [];
    RMSD_footprog  = [];
    %% 1. Original angles
    L_Pelvis = Angles(ii).original.LPelvisAngles_PyCGM1;
    L_Hip = Angles(ii).original.LHipAngles_PyCGM1;
    L_Knee = Angles(ii).original.LKneeAngles_PyCGM1;
    L_Ankle = Angles(ii).original.LAnkleAngles_PyCGM1;
    L_Foot = Angles(ii).original.LFootProgressAngles_PyCGM1;
    %% 2. Calculate RMSD
    for j = 1:length(Error)
        for k = 1:length(Er)
            EE = ['Misp_',num2str(Er(k))];
            Pelvis = strcat('LPelvisAngles_', string(MM(k,j)));
            Hip   = strcat('LHipAngles_', string(MM(k,j)));
            Knee  = strcat('LKneeAngles_', string(MM(k,j)));
            Ankle = strcat('LAnkleAngles_', string(MM(k,j)));
            Foot = strcat('LFootProgressAngles_', string(MM(k,j)));
            
            L_Pelv_err = Angles(ii).error.(char(Pelvis));
            L_Hip_err = Angles(ii).error.(char(Hip));
            L_Knee_err = Angles(ii).error.(char(Knee));
            L_Ankle_err = Angles(ii).error.(char(Ankle));
            L_Foot_err = Angles(ii).error.(char(Foot));
            
            % Calculate RMSD for each angle and each error
            RMSD_peltilt(:,j)   =  sqrt((L_Pelv_err(:,1)-L_Pelvis(:,1)).^2);
            RMSD_pelobliq(:,j)  =  sqrt((L_Pelv_err(:,2)-L_Pelvis(:,2)).^2);
            RMSD_pelrot(:,j)    = sqrt((L_Pelv_err(:,3)-L_Pelvis(:,3)).^2);
            RMSD_hipflex(:,j)   =  sqrt((L_Hip_err(:,1) - L_Hip(:,1)).^2);
            RMSD_hipadd(:,j)    =  sqrt((L_Hip_err(:,2) - L_Hip(:,2)).^2);
            RMSD_hiprot(:,j)    =  sqrt((L_Hip_err(:,3) - L_Hip(:,3)).^2);
            RMSD_kneeflex(:,j)  =  sqrt((L_Knee_err(:,1) - L_Knee(:,1)).^2);
            RMSD_kneeadd(:,j)   =  sqrt((L_Knee_err(:,2) - L_Knee(:,2)).^2);
            RMSD_kneerot(:,j)   =  sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2);
            RMSD_ankleflex(:,j) =  sqrt((L_Ankle_err(:,1) - L_Ankle(:,1)).^2);
            RMSD_ankleadd(:,j)  =  sqrt((L_Ankle_err(:,2) - L_Ankle(:,2)).^2);
            RMSD_anklerot(:,j)  =  sqrt((L_Ankle_err(:,3) - L_Ankle(:,3)).^2);
            RMSD_footprog(:,j)  =  sqrt((L_Foot_err(:,3)- L_Foot(:,3)).^2);
            
            % RMSD
            R.LPelvis_til.(direction{j}).(EE).RMSD(ii) =  mean(RMSD_peltilt(:,j));
            R.LPelvis_obl.(direction{j}).(EE).RMSD(ii) =  mean(RMSD_pelobliq(:,j));
            R.LPelvis_rot.(direction{j}).(EE).RMSD(ii) =  mean(RMSD_pelrot(:,j));
            R.LHip_flex.(direction{j}).(EE).RMSD(ii)   =  mean(RMSD_hipflex(:,j));
            R.LHip_add.(direction{j}).(EE).RMSD(ii)    =  mean(RMSD_hipadd(:,j));
            R.LHip_rot.(direction{j}).(EE).RMSD(ii)    =  mean(RMSD_hiprot(:,j));
            R.LKnee_flex.(direction{j}).(EE).RMSD(ii)  =  mean(RMSD_kneeflex(:,j));
            R.LKnee_add.(direction{j}).(EE).RMSD(ii)   =  mean(RMSD_kneeadd(:,j));
            R.LKnee_rot.(direction{j}).(EE).RMSD(ii)   =  mean(RMSD_kneerot(:,j));
            R.LAnkle_flex.(direction{j}).(EE).RMSD(ii) =  mean(RMSD_ankleflex(:,j));
            R.LAnkle_add.(direction{j}).(EE).RMSD(ii)  =  mean(RMSD_ankleadd(:,j));
            R.LAnkle_rot.(direction{j}).(EE).RMSD(ii)  =  mean(RMSD_anklerot(:,j));
            R.LFoot_prog.(direction{j}).(EE).RMSD(ii)  =  mean(RMSD_footprog(:,j));
            
            % max RMSD
            R.LPelvis_til.(direction{j}).(EE).max_RMSD(ii) = max(RMSD_peltilt(:,j));
            R.LPelvis_obl.(direction{j}).(EE).max_RMSD(ii) =  max(RMSD_pelobliq(:,j));
            R.LPelvis_rot.(direction{j}).(EE).max_RMSD(ii) =  max(RMSD_pelrot(:,j));
            R.LHip_flex.(direction{j}).(EE).max_RMSD(ii)   =  max(RMSD_hipflex(:,j));
            R.LHip_add.(direction{j}).(EE).max_RMSD(ii)    =  max(RMSD_hipadd(:,j));
            R.LHip_rot.(direction{j}).(EE).max_RMSD(ii)    =  max(RMSD_hiprot(:,j));
            R.LKnee_flex.(direction{j}).(EE).max_RMSD(ii)  =  max(RMSD_kneeflex(:,j));
            R.LKnee_add.(direction{j}).(EE).max_RMSD(ii)   =  max(RMSD_kneeadd(:,j));
            R.LKnee_rot.(direction{j}).(EE).max_RMSD(ii)   =  max(RMSD_kneerot(:,j));
            R.LAnkle_flex.(direction{j}).(EE).max_RMSD(ii) =  max(RMSD_ankleflex(:,j));
            R.LAnkle_add.(direction{j}).(EE).max_RMSD(ii)  =  max(RMSD_ankleadd(:,j));
            R.LAnkle_rot.(direction{j}).(EE).max_RMSD(ii)  =  max(RMSD_anklerot(:,j));
            R.LFoot_prog.(direction{j}).(EE).max_RMSD(ii)  =  max(RMSD_footprog(:,j));
            
            % standard deviation RMSD
            R.LPelvis_til.(direction{j}).(EE).SD(ii) = std(RMSD_peltilt(:,j));
            R.LPelvis_obl.(direction{j}).(EE).SD(ii) =  std(RMSD_pelobliq(:,j));
            R.LPelvis_rot.(direction{j}).(EE).SD(ii) =  std(RMSD_pelrot(:,j));
            R.LHip_flex.(direction{j}).(EE).SD(ii)   =  std(RMSD_hipflex(:,j));
            R.LHip_add.(direction{j}).(EE).SD(ii)    =  std(RMSD_hipadd(:,j));
            R.LHip_rot.(direction{j}).(EE).SD(ii)    =  std(RMSD_hiprot(:,j));
            R.LKnee_flex.(direction{j}).(EE).SD(ii)  =  std(RMSD_kneeflex(:,j));
            R.LKnee_add.(direction{j}).(EE).SD(ii)   =  std(RMSD_kneeadd(:,j));
            R.LKnee_rot.(direction{j}).(EE).SD(ii)   =  std(RMSD_kneerot(:,j));
            R.LAnkle_flex.(direction{j}).(EE).SD(ii) =  std(RMSD_ankleflex(:,j));
            R.LAnkle_add.(direction{j}).(EE).SD(ii)  =  std(RMSD_ankleadd(:,j));
            R.LAnkle_rot.(direction{j}).(EE).SD(ii)  =  std(RMSD_anklerot(:,j));
            R.LFoot_prog.(direction{j}).(EE).SD(ii)  =  std(RMSD_footprog(:,j));            
        end
    end
end

%% 3. Create and export table .xls
Err_cmp = [];
Magn = [];

Angle.Pel_tilt_RMSD = []; Angle.Pel_obliq_RMSD = []; Angle.Pel_rot_RMSD = [];
Angle.Hip_flex_RMSD = []; Angle.Hip_add_RMSD = []; Angle.Hip_rot_RMSD = [];
Angle.Knee_flex_RMSD = []; Angle.Knee_add_RMSD = []; Angle.Knee_rot_RMSD = [];
Angle.Ankle_flex_RMSD = []; Angle.Ankle_add_RMSD = []; Angle.Ankle_rot_RMSD = [];
Angle.Foot_prog_RMSD = [];

Pel_tilt_max = []; Pel_obliq_max = []; Pel_rot_max = [];
Hip_flex_max  = []; Hip_add_max  = []; Hip_rot_max  = [];
Knee_flex_max  = []; Knee_add_max  = []; Knee_rot_max  = [];
Ankle_flex_max  = []; Ankle_add_max  = []; Ankle_rot_max  = [];
Foot_prog_max  = [];

Pel_tilt_SD = []; Pel_obliq_SD = []; Pel_rot_SD = [];
Hip_flex_SD = []; Hip_add_SD = []; Hip_rot_SD = [];
Knee_flex_SD = []; Knee_add_SD = []; Knee_rot_SD = [];
Ankle_flex_SD = []; Ankle_add_SD = []; Ankle_rot_SD = [];
Foot_prog_SD = [];

Mag   = fieldnames(R.LHip_flex.(direction{1}));
Error = fieldnames(R.LHip_flex);

for j = 1:length(Error)
    A = [repmat(Error(j),1,length(Mag))];
    Err_cmp = [Err_cmp A];
    
    for k = 1:length(Er)
        Angle.Pel_tilt_RMSD   = [Angle.Pel_tilt_RMSD; R.LPelvis_til.(Error{j}).(Mag{k}).RMSD];
        Angle.Pel_obliq_RMSD  = [Angle.Pel_obliq_RMSD; R.LPelvis_obl.(Error{j}).(Mag{k}).RMSD];
        Angle.Pel_rot_RMSD    = [Angle.Pel_rot_RMSD; R.LPelvis_rot.(Error{j}).(Mag{k}).RMSD];
        Angle.Hip_flex_RMSD   = [Angle.Hip_flex_RMSD; R.LHip_flex.(Error{j}).(Mag{k}).RMSD];
        Angle.Hip_add_RMSD    = [Angle.Hip_add_RMSD; R.LHip_add.(Error{j}).(Mag{k}).RMSD]; 
        Angle.Hip_rot_RMSD    = [Angle.Hip_rot_RMSD; R.LHip_rot.(Error{j}).(Mag{k}).RMSD];  
        Angle.Knee_flex_RMSD  = [Angle.Knee_flex_RMSD; R.LKnee_flex.(Error{j}).(Mag{k}).RMSD];
        Angle.Knee_add_RMSD   = [Angle.Knee_add_RMSD; R.LKnee_add.(Error{j}).(Mag{k}).RMSD];
        Angle.Knee_rot_RMSD   = [Angle.Knee_rot_RMSD; R.LKnee_rot.(Error{j}).(Mag{k}).RMSD];  
        Angle.Ankle_flex_RMSD = [Angle.Ankle_flex_RMSD; R.LAnkle_flex.(Error{j}).(Mag{k}).RMSD];
        Angle.Ankle_add_RMSD  = [Angle.Ankle_add_RMSD; R.LAnkle_add.(Error{j}).(Mag{k}).RMSD];
        Angle.Ankle_rot_RMSD  = [Angle.Ankle_rot_RMSD; R.LAnkle_rot.(Error{j}).(Mag{k}).RMSD];
        Angle.Foot_prog_RMSD  = [Angle.Foot_prog_RMSD; R.LFoot_prog.(Error{j}).(Mag{k}).RMSD];

        Pel_tilt_max    = [Pel_tilt_max; R.LPelvis_til.(Error{j}).(Mag{k}).max_RMSD];
        Pel_obliq_max   = [Pel_obliq_max; R.LPelvis_obl.(Error{j}).(Mag{k}).max_RMSD];
        Pel_rot_max     = [Pel_rot_max; R.LPelvis_rot.(Error{j}).(Mag{k}).max_RMSD];        
        Hip_flex_max    = [Hip_flex_max; R.LHip_flex.(Error{j}).(Mag{k}).max_RMSD];
        Hip_add_max     = [Hip_add_max; R.LHip_add.(Error{j}).(Mag{k}).max_RMSD];
        Hip_rot_max     = [Hip_rot_max; R.LHip_rot.(Error{j}).(Mag{k}).max_RMSD];
        Knee_flex_max   = [Knee_flex_max; R.LKnee_flex.(Error{j}).(Mag{k}).max_RMSD];
        Knee_add_max    = [Knee_add_max; R.LKnee_add.(Error{j}).(Mag{k}).max_RMSD];
        Knee_rot_max    = [Knee_rot_max; R.LKnee_rot.(Error{j}).(Mag{k}).max_RMSD];
        Ankle_flex_max  = [Ankle_flex_max; R.LAnkle_flex.(Error{j}).(Mag{k}).max_RMSD];
        Ankle_add_max   = [Ankle_add_max; R.LAnkle_add.(Error{j}).(Mag{k}).max_RMSD];
        Ankle_rot_max   = [Ankle_rot_max; R.LAnkle_rot.(Error{j}).(Mag{k}).max_RMSD];
        Foot_prog_max   = [Foot_prog_max; R.LFoot_prog.(Error{j}).(Mag{k}).max_RMSD];
        
        Pel_tilt_SD   = [Pel_tilt_SD; R.LPelvis_til.(Error{j}).(Mag{k}).SD];
        Pel_obliq_SD  = [Pel_obliq_SD; R.LPelvis_obl.(Error{j}).(Mag{k}).SD];
        Pel_rot_SD    = [Pel_rot_SD; R.LPelvis_rot.(Error{j}).(Mag{k}).SD];    
        Hip_flex_SD   = [Hip_flex_SD; R.LHip_flex.(Error{j}).(Mag{k}).SD];
        Hip_add_SD    = [Hip_add_SD; R.LHip_add.(Error{j}).(Mag{k}).SD]; 
        Hip_rot_SD    = [Hip_rot_SD; R.LHip_rot.(Error{j}).(Mag{k}).SD];  
        Knee_flex_SD  = [Knee_flex_SD; R.LKnee_flex.(Error{j}).(Mag{k}).SD];
        Knee_add_SD   = [Knee_add_SD; R.LKnee_add.(Error{j}).(Mag{k}).SD];
        Knee_rot_SD   = [Knee_rot_SD; R.LKnee_rot.(Error{j}).(Mag{k}).SD];  
        Ankle_flex_SD = [Ankle_flex_SD; R.LAnkle_flex.(Error{j}).(Mag{k}).SD];
        Ankle_add_SD  = [Ankle_add_SD; R.LAnkle_add.(Error{j}).(Mag{k}).SD];
        Ankle_rot_SD  = [Ankle_rot_SD; R.LAnkle_rot.(Error{j}).(Mag{k}).SD];
        Foot_prog_SD  = [Foot_prog_SD; R.LFoot_prog.(Error{j}).(Mag{k}).SD];
        
        Magn = [Magn Mag(k)];
    end
end
An = fieldnames(R);
for i = 1:length(An)
    c=0;
    for j = 1:length(Error)
        for k = 1:length(Mag)
           c = c+1; 
           m_RMSD(c,i) =  mean(R.(An{i}).(Error{j}).(Mag{k}).RMSD);
           m_std(c,i)  =  mean(R.(An{i}).(Error{j}).(Mag{k}).SD);
           m_max_RMSD(c,i)  =  mean(R.(An{i}).(Error{j}).(Mag{k}).max_RMSD);
        end
    end
end
% T_RMSD = table(Err_cmp',Magn',Hip_flex_RMSD, Hip_add_RMSD, Hip_rot_RMSD, Knee_flex_RMSD, Knee_add_RMSD, Knee_rot_RMSD, Ankle_flex_RMSD, Ankle_add_RMSD, Ankle_rot_RMSD, Foot_prog_RMSD);
% T_std = table(Err_cmp',Magn',Hip_flex_SD, Hip_add_SD, Hip_rot_SD, Knee_flex_SD, Knee_add_SD, Knee_rot_SD, Ankle_flex_SD, Ankle_add_SD, Ankle_rot_SD, Foot_prog_SD);
% T_max  = table(Err_cmp',Magn',Hip_flex_max, Hip_add_max, Hip_rot_max, Knee_flex_max, Knee_add_max, Knee_rot_max, Ankle_flex_max, Ankle_add_max, Ankle_rot_max, Foot_prog_max);
T_RMSD = table(Err_cmp',Magn',Angle.Pel_tilt_RMSD, Angle.Pel_obliq_RMSD, Angle.Pel_rot_RMSD, Angle.Hip_flex_RMSD, Angle.Hip_add_RMSD, Angle.Hip_rot_RMSD, Angle.Knee_flex_RMSD, Angle.Knee_add_RMSD, ...
    Angle.Knee_rot_RMSD, Angle.Ankle_flex_RMSD, Angle.Ankle_add_RMSD, Angle.Ankle_rot_RMSD, Angle.Foot_prog_RMSD);
T_std = table(Err_cmp',Magn',Pel_tilt_SD, Pel_obliq_SD, Pel_rot_SD, Hip_flex_SD, Hip_add_SD, Hip_rot_SD, Knee_flex_SD, Knee_add_SD, Knee_rot_SD, Ankle_flex_SD, Ankle_add_SD, Ankle_rot_SD, Foot_prog_SD);
T_max  = table(Err_cmp',Magn',Pel_tilt_max, Pel_obliq_max, Pel_rot_max,Hip_flex_max, Hip_add_max, Hip_rot_max, Knee_flex_max, Knee_add_max, Knee_rot_max, Ankle_flex_max, Ankle_add_max, Ankle_rot_max, Foot_prog_max);
% Names = {'Error direction', 'Error mm', 'Hip Flex RMSD', 'Hip Flex SD', 'Hip Add RMSD', 'Hip Add SD', 'Hip Rot RMSD', 'Hip Rot SD', 'Knee Flex RMSD', 'Knee Flex SD', 'Knee Add RMSD', 'Knee Add SD', ...
% 'Knee Rot RMSD', 'Knee Rot SD', 'Ankle Flex RMSD', 'Ankle Flex SD', 'Ankle Add RMSD', 'Ankle Add SD', 'Ankle Rot RMSD', 'Ankle Rot SD'};

T_m_RMSD = table(Err_cmp',Magn',m_RMSD(:,1),m_std(:,1),m_RMSD(:,2),m_std(:,2),m_RMSD(:,3),m_std(:,3),m_RMSD(:,4),m_std(:,4),m_RMSD(:,5),m_std(:,5),m_RMSD(:,6),m_std(:,6),m_RMSD(:,7),m_std(:,7),m_RMSD(:,8),m_std(:,8),m_RMSD(:,9),m_std(:,9),m_RMSD(:,10),m_std(:,10),m_RMSD(:,11),m_std(:,11),m_RMSD(:,12),m_std(:,12), m_RMSD(:,13),m_std(:,13)); %, 'VariableNames', Names);
T_m_max  = table(Err_cmp',Magn',m_max_RMSD);

count = 0;
m_RMSD_pMagn = zeros (size(m_RMSD));
m_SD_pMagn = zeros(size(m_RMSD));
for j = 1:length(Er)
    c = j;
    for i=1:length(Error)
       count = count+1;
       m_RMSD_pMagn(count,:) = m_RMSD(c,:);
       m_SD_pMagn(count,:) = m_RMSD(c,:);
       c = c +5;
    end
end    
T_m_RMSD_pMagn = table(Err_cmp',Magn', m_RMSD_pMagn) ;
T_m_SD_pMagn = table(Err_cmp', Magn',m_SD_pMagn);

%% Export table RMSD + SD for 10mm misplacement
counter = 2;
values_tab =[];
for i = 1:8
    values_tab = [values_tab; mean(Angle.Pel_tilt_RMSD(counter,:)),mean(Angle.Pel_obliq_RMSD(counter,:)),mean(Angle.Pel_rot_RMSD(counter,:)),mean(Angle.Hip_flex_RMSD(counter,:)),mean(Angle.Hip_add_RMSD(counter,:)), mean(Angle.Hip_rot_RMSD(counter,:)),...
        mean(Angle.Knee_flex_RMSD(counter,:)), mean(Angle.Knee_add_RMSD(counter,:)), mean(Angle.Knee_rot_RMSD(counter,:)),  mean(Angle.Ankle_flex_RMSD(counter,:)), mean(Angle.Ankle_add_RMSD(counter,:)), mean(Angle.Ankle_rot_RMSD(counter,:)),mean(Angle.Foot_prog_RMSD(counter,:));...
        mean(Pel_tilt_SD(counter,:)), mean(Pel_obliq_SD(counter,:)),  mean(Pel_rot_SD(counter,:)),mean(Hip_flex_SD(counter,:)), mean(Hip_add_SD(counter,:)), mean(Hip_rot_SD(counter,:)), ...
        mean(Knee_flex_SD(counter,:)), mean(Knee_add_SD(counter,:)),mean(Knee_rot_SD(counter,:)),mean(Ankle_flex_SD(counter,:)), mean(Ankle_add_SD(counter,:)), mean(Ankle_rot_SD(counter,:)),mean(Foot_prog_SD(counter,:))];
    counter = counter +5; %get the line 2 and multiples for misplacement of 10mm ()
end
A = transpose(values_tab);
RNames = {'Pelvic tilt','Pelvic obliquity','Pelvic Rotation', 'Hip flexion-extension','Hip adduction-abduction','Hip internal-external rotation',...
    'Knee flexion-extension','Knee adduction-abduction', 'Knee internal-external rotation','Ankle flexion-extension', 'Ankle adduction-abduction', ...
    'Ankle internal-external rotation', 'Internal foot progression'};
direction2 = {'Lat_RMSD',' Lat_SD','Lat_Prox_RMSD','Lat_Prox_SD', 'Prox_RMSD', 'Prox_SD', 'Med_Prox_RMSD','Med_Prox_SD', 'Med_RMSD','Med_SD', 'Med_Dist_RMSD','Med_Dist_SD',...
    'Dist_RMSD', 'Dist_SD', 'Lat_Dist_RMSD', 'Lat_Dist_SD'};
Table_RMSD_SD = array2table(A, 'RowNames', RNames , 'VariableNames', direction2)
writetable(Table_RMSD_SD, 'RMSD_SD_10.xlsx', 'Sheet', 1, 'WriteRowNames', true)
Joint_Angles = {'Pelvic_Tilt_RMSD','Pelvic_Tilt_SD', 'Pelvic_Obliquity_RMSD','Pelvic_Obliquity_SD', 'Pelvic_IntExternal_Rotation_RMSD','Pelvic_IntExternal_Rotation_SD', 'Hip_FlexExtension_RMSD','Hip_FlexExtension_SD',...
    'Hip_AddAbduction_RMSD','Hip_AddAbduction_SD', 'Hip_IntExternal_Rotation_RMSD','Hip_IntExternal_Rotation_SD','Knee_FlexExtension_RMSD','Knee_FlexExtension_SD', 'Knee_AddAbduction_RMSD','Knee_AddAbduction_SD',...
    'Knee_IntExternal_Rotation_RMSD','Knee_IntExternal_Rotation_SD','Ankle_FlexExtension_RMSD','Ankle_FlexExtension_SD','Ankle_AddAbduction_RMSD','Ankle_AddAbduction_SD', 'Ankle_IntExternal_Rotation_RMSD','Ankle_IntExternal_Rotation_SD', 'Internal_Foot_Progression_RMSD', 'Internal_Foot_Progression_SD'};
 
% T_RMSD_SD = table(mean(Pel_tilt_RMSD,2), mean(Pel_tilt_SD,2), mean(Pel_obliq_RMSD,2), mean(Pel_obliq_SD,2), mean(Pel_rot_RMSD,2), mean(Pel_rot_SD,2),...
%     mean(Hip_flex_RMSD,2), mean(Hip_flex_SD,2), mean(Hip_add_RMSD,2), mean(Hip_add_SD,2), mean(Hip_rot_RMSD,2), mean(Hip_rot_SD,2),...
%     mean(Knee_flex_RMSD,2), mean(Knee_flex_SD,2), mean(Knee_add_RMSD,2), mean(Knee_add_SD,2), mean(Knee_rot_RMSD,2), mean(Knee_rot_SD,2),...
%     mean(Ankle_flex_RMSD,2), mean(Ankle_flex_SD,2), mean(Ankle_add_RMSD,2), mean(Ankle_add_SD,2), mean(Ankle_rot_RMSD,2), mean(Ankle_rot_SD,2),'VariableNames',  Joint_Angles);
% writetable(T_RMSD_SD, 'RMSD_SD_10mm.xlsx', 'Sheet', 1)

%% Export a table with RMSD for each angle * all patients. (10mm) 

Export_RMSD_Angle(Angle, group)


%% Create a table containing only RMSD +SD for 10 mm (rows: direction, columns: joint angles RMSD & SD)
count = 2; % second line = 10mm
T_m_RMSD_SD_10 = [];
for i = 1:length(Error)
    Tabb= table(mean(Angle.Pel_tilt_RMSD(count,:),2), mean(Pel_tilt_SD(count,:),2), mean(Angle.Pel_obliq_RMSD(count,:),2), mean(Pel_obliq_SD(count,:),2), mean(Angle.Pel_rot_RMSD(count,:),2), mean(Pel_rot_SD(count,:),2),...
        mean(Angle.Hip_flex_RMSD(count,:),2), mean(Hip_flex_SD(count,:),2), mean(Angle.Hip_add_RMSD(count,:),2), mean(Hip_add_SD(count,:),2), mean(Angle.Hip_rot_RMSD(count,:),2), mean(Hip_rot_SD(count,:),2),...
        mean(Angle.Knee_flex_RMSD(count,:),2), mean(Knee_flex_SD(count,:),2), mean(Angle.Knee_add_RMSD(count,:),2), mean(Knee_add_SD(count,:),2), mean(Angle.Knee_rot_RMSD(count,:),2), mean(Knee_rot_SD(count,:),2),...
        mean(Angle.Ankle_flex_RMSD(count,:),2), mean(Ankle_flex_SD(count,:),2), mean(Angle.Ankle_add_RMSD(count,:),2), mean(Ankle_add_SD(count,:),2), mean(Angle.Ankle_rot_RMSD(count,:),2), mean(Ankle_rot_SD(count,:),2), mean(Angle.Foot_prog_RMSD(count,:),2), mean(Foot_prog_SD(count,:),2),'VariableNames',  Joint_Angles);
    T_m_RMSD_SD_10 = [T_m_RMSD_SD_10; Tabb];
    count = count+5;
end
T_m_RMSD_SD_10.Properties.RowNames = direction;
writetable(T_m_RMSD_SD_10, 'RMSD_SD_10mm.xlsx', 'Sheet', 1)

TT1 = T_m_RMSD_SD_10([1,5],:);
TT1 = array2table(mean(TT1.Variables,1));
TT2 = T_m_RMSD_SD_10([3,7],:);
TT2 = array2table(mean(TT2.Variables,1));
T_m_RMSD_SD_10_4dir = [TT1;TT2];
T_m_RMSD_SD_10_4dir.Properties.VariableNames = Joint_Angles;
T_m_RMSD_SD_10_4dir.Properties.RowNames = {char(strcat(MARK, '_', direction{1},'_',direction{5})), char(strcat(MARK, '_', direction{3}, '_', direction{7})) };

writetable(T_m_RMSD_SD_10_4dir, 'T_m_RMSD_SD_10_4dir.xlsx', 'Sheet', 1, 'WriteRowNames', true)

end