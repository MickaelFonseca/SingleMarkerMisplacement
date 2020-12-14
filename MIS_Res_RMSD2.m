function [T_m_RMSD, R, Angle_names, Joint_Angles]  = MIS_Res_RMSD2(Angles, Error, Magnitude, MM1,MM2, counter, direction, Magnitude_to_tab, Marker_1, Marker_2)
Variable_Names = [];
for ii = 1:counter
    RMSD_peltilt   = [];
    RMSD_pelobliq    = [];
    RMSD_pelrot    = [];
    RMSD_hipflex   = []; RMSD_rhipflex = [];
    RMSD_hipadd    = []; RMSD_rhipadd = [];
    RMSD_hiprot    = []; RMSD_rhiprot = [];
    RMSD_kneeflex  = []; RMSD_rkneeflex = [];
    RMSD_kneeadd   = []; RMSD_rkneeadd = [];
    RMSD_kneerot   = []; RMSD_rkneerot=[];
    RMSD_ankleflex = [];
    RMSD_ankleadd  = [];
    RMSD_anklerot  = [];
    RMSD_footprog  = [];
    %% 1. Original angles
    L_Pelvis = Angles(ii).original.LPelvisAngles_PyCGM1;
    L_Hip = Angles(ii).original.LHipAngles_PyCGM1;
    L_Knee = Angles(ii).original.LKneeAngles_PyCGM1;
    L_Ankle = Angles(ii).original.LAnkleAngles_PyCGM1;
    L_Foot = Angles(ii).original.LFootProgressAngles_PyCGM1;
    R_Hip = Angles(ii).original.RHipAngles_PyCGM1;
    R_Knee = Angles(ii).original.RKneeAngles_PyCGM1;
    
   for D1 = 1:length(direction)
       D = direction{D1};
       for mag = 1:length(Magnitude)
           E = ['Misp_',num2str(Magnitude(mag))];
           for D2 = 1:length(direction)
               DD = direction{D2};
               % Create the same as the computed angles for each joint
               Pelvis= strcat('LPelvisAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               Hip   = strcat('LHipAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               Knee  = strcat('LKneeAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               Ankle = strcat('LAnkleAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               Foot = strcat('LFootProgressAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               RHip = strcat('RHipAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));
               RKnee  = strcat('RKneeAngles_', string(strcat(MM1{mag,D1},'_',MM2{mag,D2})));               
               
               % Get the computed angles
               L_Pelvis_err = Angles(ii).error.(char(Pelvis));
               L_Hip_err = Angles(ii).error.(char(Hip));
               L_Knee_err = Angles(ii).error.(char(Knee));
               L_Ankle_err = Angles(ii).error.(char(Ankle));
               L_Foot_err = Angles(ii).error.(char(Foot));
               R_Hip_err = Angles(ii).error.(char(RHip));
               R_Knee_err = Angles(ii).error.(char(RKnee));
               
               % Calculate RMSD for each angle and each error between
               % misplaced and original angle for each magnitude
               RMSD_peltilt(:,mag)   =  sqrt((L_Pelvis_err(:,1)-L_Pelvis(:,1)).^2);
               RMSD_pelobliq(:,mag)   =  sqrt((L_Pelvis_err(:,2)-L_Pelvis(:,2)).^2);
               RMSD_pelrot(:,mag)   =  sqrt((L_Pelvis_err(:,3)-L_Pelvis(:,3)).^2);               
               RMSD_hipflex(:,mag)   =  sqrt((L_Hip_err(:,1) - L_Hip(:,1)).^2);
               RMSD_hipadd(:,mag)    =  sqrt((L_Hip_err(:,2) - L_Hip(:,2)).^2);
               RMSD_hiprot(:,mag)    =  sqrt((L_Hip_err(:,3) - L_Hip(:,3)).^2);
               RMSD_kneeflex(:,mag)  =  sqrt((L_Knee_err(:,1) - L_Knee(:,1)).^2);
               RMSD_kneeadd(:,mag)   =  sqrt((L_Knee_err(:,2) - L_Knee(:,2)).^2);
               RMSD_kneerot(:,mag)   =  sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2);
               RMSD_ankleflex(:,mag) =  sqrt((L_Ankle_err(:,1) - L_Ankle(:,1)).^2);
               RMSD_ankleadd(:,mag)  =  sqrt((L_Ankle_err(:,2) - L_Ankle(:,2)).^2);
               RMSD_anklerot(:,mag)  =  sqrt((L_Ankle_err(:,3) - L_Ankle(:,3)).^2);
               RMSD_footprog(:,mag)  =  sqrt((L_Foot_err(:,3)- L_Foot(:,3)).^2);
               RMSD_rhipflex(:,mag)   =  sqrt((R_Hip_err(:,1) - R_Hip(:,1)).^2);
               RMSD_rhipadd(:,mag)    =  sqrt((R_Hip_err(:,2) - R_Hip(:,2)).^2);
               RMSD_rhiprot(:,mag)    =  sqrt((R_Hip_err(:,3) - R_Hip(:,3)).^2);
               RMSD_rkneeflex(:,mag)  =  sqrt((R_Knee_err(:,1) - R_Knee(:,1)).^2);
               RMSD_rkneeadd(:,mag)   =  sqrt((R_Knee_err(:,2) - R_Knee(:,2)).^2);
               RMSD_rkneerot(:,mag)   =  sqrt((R_Knee_err(:,3) - R_Knee(:,3)).^2);
               
               R.LPel_flex.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_peltilt(:,mag));
               R.LPel_add.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_pelobliq(:,mag));
               R.LPel_rot.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_pelrot(:,mag));
               R.LHip_flex.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_hipflex(:,mag));
               R.LHip_add.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_hipadd(:,mag));
               R.LHip_rot.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_hiprot(:,mag));
               R.LKnee_flex.(D).(E).(DD).RMSD(ii)  =  mean(RMSD_kneeflex(:,mag));
               R.LKnee_add.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_kneeadd(:,mag));
               R.LKnee_rot.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_kneerot(:,mag));
               R.LAnkle_flex.(D).(E).(DD).RMSD(ii) =  mean(RMSD_ankleflex(:,mag));
               R.LAnkle_add.(D).(E).(DD).RMSD(ii)  =  mean(RMSD_ankleadd(:,mag));
               R.LAnkle_rot.(D).(E).(DD).RMSD(ii)  =  mean(RMSD_anklerot(:,mag));
               R.LFoot_prog.(D).(E).(DD).RMSD(ii)  =  mean(RMSD_footprog(:,mag));
               R.RHip_flex.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_rhipflex(:,mag));
               R.RHip_add.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_rhipadd(:,mag));
               R.RHip_rot.(D).(E).(DD).RMSD(ii)    =  mean(RMSD_rhiprot(:,mag));
               R.RKnee_flex.(D).(E).(DD).RMSD(ii)  =  mean(RMSD_rkneeflex(:,mag));
               R.RKnee_add.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_rkneeadd(:,mag));
               R.RKnee_rot.(D).(E).(DD).RMSD(ii)   =  mean(RMSD_rkneerot(:,mag));
               
               % max RMSD
               R.LPel_flex.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_hipflex(:,mag));
               R.LPel_add.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_hipadd(:,mag));
               R.LPel_rot.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_hiprot(:,mag));
               R.LHip_flex.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_hipflex(:,mag));
               R.LHip_add.(D).(E).(DD).max_RMSD(ii)    =  max(RMSD_hipadd(:,mag));
               R.LHip_rot.(D).(E).(DD).max_RMSD(ii)    =  max(RMSD_hiprot(:,mag));
               R.LKnee_flex.(D).(E).(DD).max_RMSD(ii)  =  max(RMSD_kneeflex(:,mag));
               R.LKnee_add.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_kneeadd(:,mag));
               R.LKnee_rot.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_kneerot(:,mag));
               R.LAnkle_flex.(D).(E).(DD).max_RMSD(ii) =  max(RMSD_ankleflex(:,mag));
               R.LAnkle_add.(D).(E).(DD).max_RMSD(ii)  =  max(RMSD_ankleadd(:,mag));
               R.LAnkle_rot.(D).(E).(DD).max_RMSD(ii)  =  max(RMSD_anklerot(:,mag));
               R.LFoot_prog.(D).(E).(DD).max_RMSD(ii)  =  max(RMSD_footprog(:,mag));
               R.RHip_flex.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_rhipflex(:,mag));
               R.RHip_add.(D).(E).(DD).max_RMSD(ii)    =  max(RMSD_rhipadd(:,mag));
               R.RHip_rot.(D).(E).(DD).max_RMSD(ii)    =  max(RMSD_rhiprot(:,mag));
               R.RKnee_flex.(D).(E).(DD).max_RMSD(ii)  =  max(RMSD_rkneeflex(:,mag));
               R.RKnee_add.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_rkneeadd(:,mag));
               R.RKnee_rot.(D).(E).(DD).max_RMSD(ii)   =  max(RMSD_rkneerot(:,mag));
               
               % standard deviation of RMSD
               R.LPel_flex.(D).(E).(DD).SD(ii)   =  std(RMSD_peltilt(:,mag));
               R.LPel_add.(D).(E).(DD).SD(ii)    =  std(RMSD_pelobliq(:,mag));
               R.LPel_rot.(D).(E).(DD).SD(ii)    =  std(RMSD_pelrot(:,mag));
               R.LHip_flex.(D).(E).(DD).SD(ii)   =  std(RMSD_hipflex(:,mag));
               R.LHip_add.(D).(E).(DD).SD(ii)    =  std(RMSD_hipadd(:,mag));
               R.LHip_rot.(D).(E).(DD).SD(ii)    =  std(RMSD_hiprot(:,mag));
               R.LKnee_flex.(D).(E).(DD).SD(ii)  =  std(RMSD_kneeflex(:,mag));
               R.LKnee_add.(D).(E).(DD).SD(ii)   =  std(RMSD_kneeadd(:,mag));
               R.LKnee_rot.(D).(E).(DD).SD(ii)   =  std(RMSD_kneerot(:,mag));
               R.LAnkle_flex.(D).(E).(DD).SD(ii) =  std(RMSD_ankleflex(:,mag));
               R.LAnkle_add.(D).(E).(DD).SD(ii)  =  std(RMSD_ankleadd(:,mag));
               R.LAnkle_rot.(D).(E).(DD).SD(ii)  =  std(RMSD_anklerot(:,mag));
               R.LFoot_prog.(D).(E).(DD).SD(ii)  =  std(RMSD_footprog(:,mag));
               R.RHip_flex.(D).(E).(DD).SD(ii)   =  std(RMSD_rhipflex(:,mag));
               R.RHip_add.(D).(E).(DD).SD(ii)    =  std(RMSD_rhipadd(:,mag));
               R.RHip_rot.(D).(E).(DD).SD(ii)    =  std(RMSD_rhiprot(:,mag));
               R.RKnee_flex.(D).(E).(DD).SD(ii)  =  std(RMSD_rkneeflex(:,mag));
               R.RKnee_add.(D).(E).(DD).SD(ii)   =  std(RMSD_rkneeadd(:,mag));
               R.RKnee_rot.(D).(E).(DD).SD(ii)   =  std(RMSD_rkneerot(:,mag));             
           end
       end
   end 
end

%% 3. Create and export table .xls
Err_cmp = [];
Magn = [];

Angle_names = [];
Pel_flex_RMSD  = []; Pel_add_RMSD  = []; Pel_rot_RMSD   = [];
Hip_flex_RMSD  = []; Hip_add_RMSD   = []; Hip_rot_RMSD   = [];
Knee_flex_RMSD = []; Knee_add_RMSD  = []; Knee_rot_RMSD  = [];
Ankle_flex_RMSD= []; Ankle_add_RMSD = []; Ankle_rot_RMSD = [];
Foot_prog_RMSD = [];
rHip_flex_RMSD  = []; rHip_add_RMSD   = []; rHip_rot_RMSD   = [];
rKnee_flex_RMSD = []; rKnee_add_RMSD  = []; rKnee_rot_RMSD  = [];

Pel_flex_max = []; Pel_add_max = []; Pel_rot_max = [];
Hip_flex_max  = []; Hip_add_max  = []; Hip_rot_max  = [];
Knee_flex_max  = []; Knee_add_max  = []; Knee_rot_max  = [];
Ankle_flex_max  = []; Ankle_add_max  = []; Ankle_rot_max  = [];
Foot_prog_max  = [];
rHip_flex_max  = []; rHip_add_max  = []; rHip_rot_max  = [];
rKnee_flex_max  = []; rKnee_add_max  = []; rKnee_rot_max  = [];

Pel_flex_SD = []; Pel_add_SD = []; Pel_rot_SD = [];
Hip_flex_SD = []; Hip_add_SD = []; Hip_rot_SD = [];
Knee_flex_SD = []; Knee_add_SD = []; Knee_rot_SD = [];
Ankle_flex_SD = []; Ankle_add_SD = []; Ankle_rot_SD = [];
Foot_prog_SD = [];
rHip_flex_SD  = []; rHip_add_SD  = []; rHip_rot_SD  = [];
rKnee_flex_SD  = []; rKnee_add_SD  = []; rKnee_rot_SD  = [];

Mag   = fieldnames(R.LHip_flex.Med);
Error = fieldnames(R.LHip_flex);

for D1 = 1:length(direction)
    D = direction{D1};
    for mag = 1:length(Magnitude_to_tab)
        E = ['Misp_',num2str(Magnitude_to_tab(mag))];
        for D2 = 1:length(direction)
            DD = direction{D2}; 
            Angle_names     = [Angle_names; string(strcat(E, '_', Marker_1,'_', D, '_', Marker_2, '_', DD))];
            Pel_flex_RMSD   = [Pel_flex_RMSD; R.LPel_flex.(D).(E).(DD).RMSD];
            Pel_add_RMSD   = [Pel_add_RMSD; R.LPel_add.(D).(E).(DD).RMSD];
            Pel_rot_RMSD   = [Pel_rot_RMSD; R.LPel_rot.(D).(E).(DD).RMSD];
            Hip_flex_RMSD   = [Hip_flex_RMSD; R.LHip_flex.(D).(E).(DD).RMSD];
            Hip_add_RMSD    = [Hip_add_RMSD; R.LHip_add.(D).(E).(DD).RMSD];
            Hip_rot_RMSD    = [Hip_rot_RMSD; R.LHip_rot.(D).(E).(DD).RMSD];
            Knee_flex_RMSD  = [Knee_flex_RMSD; R.LKnee_flex.(D).(E).(DD).RMSD];
            Knee_add_RMSD   = [Knee_add_RMSD; R.LKnee_add.(D).(E).(DD).RMSD];
            Knee_rot_RMSD   = [Knee_rot_RMSD; R.LKnee_rot.(D).(E).(DD).RMSD];
            Ankle_flex_RMSD = [Ankle_flex_RMSD; R.LAnkle_flex.(D).(E).(DD).RMSD];
            Ankle_add_RMSD  = [Ankle_add_RMSD; R.LAnkle_add.(D).(E).(DD).RMSD];
            Ankle_rot_RMSD  = [Ankle_rot_RMSD; R.LAnkle_rot.(D).(E).(DD).RMSD];
            Foot_prog_RMSD  = [Foot_prog_RMSD; R.LFoot_prog.(D).(E).(DD).RMSD];
            rHip_flex_RMSD   = [rHip_flex_RMSD; R.RHip_flex.(D).(E).(DD).RMSD];
            rHip_add_RMSD    = [rHip_add_RMSD; R.RHip_add.(D).(E).(DD).RMSD];
            rHip_rot_RMSD    = [rHip_rot_RMSD; R.RHip_rot.(D).(E).(DD).RMSD];
            rKnee_flex_RMSD  = [rKnee_flex_RMSD; R.RKnee_flex.(D).(E).(DD).RMSD];
            rKnee_add_RMSD   = [rKnee_add_RMSD; R.RKnee_add.(D).(E).(DD).RMSD];
            rKnee_rot_RMSD   = [rKnee_rot_RMSD; R.RKnee_rot.(D).(E).(DD).RMSD];
            
            Pel_flex_max    = [Pel_flex_max; R.LPel_flex.(D).(E).(DD).max_RMSD];
            Pel_add_max     = [Pel_add_max; R.LPel_add.(D).(E).(DD).max_RMSD];
            Pel_rot_max     = [Pel_rot_max; R.LPel_rot.(D).(E).(DD).max_RMSD];
            Hip_flex_max    = [Hip_flex_max; R.LHip_flex.(D).(E).(DD).max_RMSD];
            Hip_add_max     = [Hip_add_max; R.LHip_add.(D).(E).(DD).max_RMSD];
            Hip_rot_max     = [Hip_rot_max; R.LHip_rot.(D).(E).(DD).max_RMSD];
            Knee_flex_max   = [Knee_flex_max; R.LKnee_flex.(D).(E).(DD).max_RMSD];
            Knee_add_max    = [Knee_add_max; R.LKnee_add.(D).(E).(DD).max_RMSD];
            Knee_rot_max    = [Knee_rot_max; R.LKnee_rot.(D).(E).(DD).max_RMSD];
            Ankle_flex_max  = [Ankle_flex_max; R.LAnkle_flex.(D).(E).(DD).max_RMSD];
            Ankle_add_max   = [Ankle_add_max; R.LAnkle_add.(D).(E).(DD).max_RMSD];
            Ankle_rot_max   = [Ankle_rot_max; R.LAnkle_rot.(D).(E).(DD).max_RMSD];
            Foot_prog_max   = [Foot_prog_max; R.LFoot_prog.(D).(E).(DD).max_RMSD];
            rHip_flex_max    = [rHip_flex_max; R.RHip_flex.(D).(E).(DD).max_RMSD];
            rHip_add_max     = [rHip_add_max; R.RHip_add.(D).(E).(DD).max_RMSD];
            rHip_rot_max     = [rHip_rot_max; R.RHip_rot.(D).(E).(DD).max_RMSD];
            rKnee_flex_max   = [rKnee_flex_max; R.RKnee_flex.(D).(E).(DD).max_RMSD];
            rKnee_add_max    = [rKnee_add_max; R.RKnee_add.(D).(E).(DD).max_RMSD];
            rKnee_rot_max    = [rKnee_rot_max; R.RKnee_rot.(D).(E).(DD).max_RMSD];
            
            Pel_flex_SD   = [Pel_flex_SD; R.LPel_flex.(D).(E).(DD).SD];
            Pel_add_SD    = [Pel_add_SD; R.LPel_flex.(D).(E).(DD).SD];
            Pel_rot_SD    = [Pel_rot_SD; R.LPel_flex.(D).(E).(DD).SD];
            Hip_flex_SD   = [Hip_flex_SD; R.LHip_flex.(D).(E).(DD).SD];
            Hip_add_SD    = [Hip_add_SD; R.LHip_add.(D).(E).(DD).SD];
            Hip_rot_SD    = [Hip_rot_SD; R.LHip_rot.(D).(E).(DD).SD];
            Knee_flex_SD  = [Knee_flex_SD; R.LKnee_flex.(D).(E).(DD).SD];
            Knee_add_SD   = [Knee_add_SD; R.LKnee_add.(D).(E).(DD).SD];
            Knee_rot_SD   = [Knee_rot_SD; R.LKnee_rot.(D).(E).(DD).SD];
            Ankle_flex_SD = [Ankle_flex_SD; R.LAnkle_flex.(D).(E).(DD).SD];
            Ankle_add_SD  = [Ankle_add_SD; R.LAnkle_add.(D).(E).(DD).SD];
            Ankle_rot_SD  = [Ankle_rot_SD; R.LAnkle_rot.(D).(E).(DD).SD];
            Foot_prog_SD  = [Foot_prog_SD; R.LFoot_prog.(D).(E).(DD).SD]; 
            rHip_flex_SD   = [rHip_flex_SD; R.RHip_flex.(D).(E).(DD).SD];
            rHip_add_SD    = [rHip_add_SD; R.RHip_add.(D).(E).(DD).SD];
            rHip_rot_SD    = [rHip_rot_SD; R.RHip_rot.(D).(E).(DD).SD];
            rKnee_flex_SD  = [rKnee_flex_SD; R.RKnee_flex.(D).(E).(DD).SD];
            rKnee_add_SD   = [rKnee_add_SD; R.RKnee_add.(D).(E).(DD).SD];
            rKnee_rot_SD   = [rKnee_rot_SD; R.RKnee_rot.(D).(E).(DD).SD];
        end
    end
end

% Calculate mean RMSD among patients
PF_RMSD_m = round(mean(Pel_flex_RMSD,2),2); PA_RMSD_m = round(mean(Pel_add_RMSD,2),2); PR_RMSD_m = round(mean(Pel_rot_RMSD,2),2);
HF_RMSD_m = round(mean(Hip_flex_RMSD,2),2); HA_RMSD_m = round(mean(Hip_add_RMSD,2),2); HR_RMSD_m = round(mean(Hip_rot_RMSD,2),2);
KF_RMSD_m = round(mean(Knee_flex_RMSD,2),2); KA_RMSD_m = round(mean(Knee_add_RMSD,2),2); KR_RMSD_m = round(mean(Knee_rot_RMSD,2),2);
AF_RMSD_m = round(mean(Ankle_flex_RMSD,2),2); AA_RMSD_m = round(mean(Ankle_add_RMSD,2),2); AR_RMSD_m = round(mean(Ankle_rot_RMSD,2),2);
rHF_RMSD_m = round(mean(rHip_flex_RMSD,2),2); rHA_RMSD_m = round(mean(rHip_add_RMSD,2),2); rHR_RMSD_m = round(mean(rHip_rot_RMSD,2),2);
rKF_RMSD_m = round(mean(rKnee_flex_RMSD,2),2); rKA_RMSD_m = round(mean(rKnee_add_RMSD,2),2); rKR_RMSD_m = round(mean(rKnee_rot_RMSD,2),2);

PF_max_m = round(mean(Pel_flex_max,2),2); PA_max_m = round(mean(Pel_add_max,2),2); PR_max_m = round(mean(Pel_rot_max,2),2);
HF_max_m = round(mean(Hip_flex_max,2),2); HA_max_m = round(mean(Hip_add_max,2),2); HR_max_m = round(mean(Hip_rot_max,2),2);
KF_max_m = round(mean(Knee_flex_max,2),2); KA_max_m = round(mean(Knee_add_max,2),2); KR_max_m = round(mean(Knee_rot_max,2),2);
AF_max_m = round(mean(Ankle_flex_max,2),2); AA_max_m = round(mean(Ankle_add_max,2),2); AR_max_m = round(mean(Ankle_rot_max,2),2);
rHF_max_m = round(mean(rHip_flex_max,2),2); rHA_max_m = round(mean(rHip_add_max,2),2); rHR_max_m = round(mean(rHip_rot_max,2),2);
rKF_max_m = round(mean(rKnee_flex_max,2),2); rKA_max_m = round(mean(rKnee_add_max,2),2); rKR_max_m = round(mean(rKnee_rot_max,2),2);

PF_SD_m = round(mean(Pel_flex_SD,2),2); PA_SD_m = round(mean(Pel_add_SD,2),2); PR_SD_m = round(mean(Pel_rot_SD,2),2);
HF_SD_m = round(mean(Hip_flex_SD,2),2); HA_SD_m = round(mean(Hip_add_SD,2),2); HR_SD_m = round(mean(Hip_rot_SD,2),2);
KF_SD_m = round(mean(Knee_flex_SD,2),2); KA_SD_m = round(mean(Knee_add_SD,2),2); KR_SD_m = round(mean(Knee_rot_SD,2),2);
AF_SD_m = round(mean(Ankle_flex_SD,2),2); AA_SD_m = round(mean(Ankle_add_SD,2),2); AR_SD_m = round(mean(Ankle_rot_SD,2),2);
rHF_SD_m = round(mean(rHip_flex_SD,2),2); rHA_SD_m = round(mean(rHip_add_SD,2),2); rHR_SD_m = round(mean(rHip_rot_SD,2),2);
rKF_SD_m = round(mean(rKnee_flex_SD,2),2); rKA_SD_m = round(mean(rKnee_add_SD,2),2); rKR_SD_m = round(mean(rKnee_rot_SD,2),2);

for D1 = 1:length(direction)
    for D2 = 1:length(direction)
        Variable_Names = [Variable_Names, string(strcat(Marker_1, '_', direction{D1}, '_',Marker_2, '_', direction{D2}, '_RMSD')), string(strcat(Marker_1, '_', direction{D1}, '_',Marker_2, '_', direction{D2}, '_SD'))];
    end
end

% Angle_names = ((Angle_names))';
Joint_Angles = {'Misplacement','Pelvic_Tilt_RMSD','Pelvic_Tilt_SD', 'Pelvic_Obliquity_RMSD','Pelvic_Obliquity_SD', 'Pelvic_IntExternal_Rotation_RMSD','Pelvic_IntExternal_Rotation_SD', 'Hip_FlexExtension_RMSD','Hip_FlexExtension_SD',...
    'Hip_AddAbduction_RMSD','Hip_AddAbduction_SD', 'Hip_IntExternal_Rotation_RMSD','Hip_IntExternal_Rotation_SD','Knee_FlexExtension_RMSD','Knee_FlexExtension_SD', 'Knee_AddAbduction_RMSD','Knee_AddAbduction_SD',...
    'Knee_IntExternal_Rotation_RMSD','Knee_IntExternal_Rotation_SD','Ankle_FlexExtension_RMSD','Ankle_FlexExtension_SD','Ankle_AddAbduction_RMSD','Ankle_AddAbduction_SD', 'Ankle_IntExternal_Rotation_RMSD','Ankle_IntExternal_Rotation_SD'};

Contralateral_Angles = {'c_Hip_FlexExtension_RMSD','c_Hip_FlexExtension_SD', 'c_Hip_AddAbduction_RMSD','c_Hip_AddAbduction_SD', 'c_Hip_IntExternal_Rotation_RMSD', 'c_Hip_Rotation_SD','c_Knee_Flex_RMSD','c_Knee_Flex_SD', 'c_Knee_Add_RMSD','c_Knee_Add_SD','c_Knee_Rotation_RMSD' ,'c_Knee_Rotation_SD'};

% writetable(T_m_RMSD, 'RMSD.xlsx', 'Sheet', 1, 'WriteRowNames', true)
AA = [Angle_names,string(PF_RMSD_m), string(PF_SD_m), string(PA_RMSD_m), string(PA_SD_m),string(PR_RMSD_m),string(PR_SD_m),string(HF_RMSD_m),string(HF_SD_m),string(HA_RMSD_m),string(HA_SD_m),string(HR_RMSD_m),string(HR_SD_m),string(KF_RMSD_m),string(KF_SD_m),string(KA_RMSD_m),string(KA_SD_m),...
    string(KR_RMSD_m),string(KR_SD_m),string(AF_RMSD_m),string(AF_SD_m),string(AA_RMSD_m),string(AA_SD_m), string(AR_RMSD_m),(AR_SD_m), string(rHF_RMSD_m),string(rHF_SD_m), string(rHA_RMSD_m),string(rHA_SD_m), string(rHR_RMSD_m),string(rHR_SD_m), string(rKF_RMSD_m),...
    string(rKF_SD_m), string(rKA_RMSD_m),string(rKA_SD_m), string(rKR_RMSD_m),string(rKR_SD_m)];

Table_RMSD_SD = array2table(AA, 'VariableNames', [Joint_Angles,Contralateral_Angles])

% Table_RMSD_SD = varfun(@(var) round(var, 1), Table_RMSD_SD)
writetable(Table_RMSD_SD, 'RMSD_SD_10mm.xlsx', 'Sheet', 1, 'WriteRowNames', true)

Joint_Angles = {'Pelvic Tilt', 'Pelvic Obliquity', 'Pelvic Internal-External Rotation', 'Hip Flexion-Extension', 'Hip Adduction-Abduction', 'Hip Internal-External Rotation','Knee Flexion-Extension', 'Knee Adduction-Abduction','Knee Internal-External Rotation','Ankle Flexion-Extension','Ankle Adduction-Abduction', 'Ankle Internal-External Rotation'};
T_m_RMSD = table(PF_RMSD_m,PA_RMSD_m,PR_RMSD_m,HF_RMSD_m,HA_RMSD_m,HR_RMSD_m,KF_RMSD_m,KA_RMSD_m,KR_RMSD_m,AF_RMSD_m,AA_RMSD_m, AR_RMSD_m);
T_m_RMSD_x = table2cell(T_m_RMSD);
T_m_RMSD = cell2table(T_m_RMSD_x', 'RowNames', Joint_Angles, 'VariableNames', cellstr(Angle_names))

end