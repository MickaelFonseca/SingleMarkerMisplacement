function MIS_Res_RMSj(Angles, Error, Er, MM, counter, direction, Magnitude)
for ii = 1:counter
    RMSD_pelflex   = [];
    RMSD_peladd    = [];
    RMSD_pelrot    = [];
    RMSD_hipflex   = [];
    RMSD_hipadd    = [];
    RMSD_hiprot    = [];
    RMSD_kneeflex  = [];
    RMSD_kneeadd   = [];
    RMSD_kneerot   = [];
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
    
    %% 2. Calculate RMSD
    for j = 1:length(Error)
        for m = 1:length(Magnitude)
            E = ['Misp_',num2str(Magnitude(m))];
            Pelvis = strcat('LPelvisAngles_', string(MM{m,j}));
            Hip    = strcat('LHipAngles_', string(MM{m,j}));
            Knee   = strcat('LKneeAngles_', string(MM{m,j}));
            Ankle  = strcat('LAnkleAngles_', string(MM{m,j}));
            Foot   = strcat('LFootProgressAngles_', string(MM{m,j}));
            
            L_Pelvis_err = Angles(ii).error.(char(Pelvis));
            L_Hip_err = Angles(ii).error.(char(Hip));
            L_Knee_err = Angles(ii).error.(char(Knee));
            L_Ankle_err = Angles(ii).error.(char(Ankle));
            L_Foot_err = Angles(ii).error.(char(Foot));
        
            % Calculate RMSD for each angle and each error
            RMSD_pelflex(:,m)   =  sqrt((L_Pelvis_err(:,1)-L_Pelvis(:,1)).^2);
            RMSD_peladd(:,m)   =  sqrt((L_Pelvis_err(:,2)-L_Pelvis(:,2)).^2);
            RMSD_pelrot(:,m)   =  sqrt((L_Pelvis_err(:,3)-L_Pelvis(:,3)).^2);
            RMSD_hipflex(:,m)   =  sqrt((L_Hip_err(:,1) - L_Hip(:,1)).^2);
            RMSD_hipadd(:,m)    =  sqrt((L_Hip_err(:,2) - L_Hip(:,2)).^2);
            RMSD_hiprot(:,m)    =  sqrt((L_Hip_err(:,3) - L_Hip(:,3)).^2);
            RMSD_kneeflex(:,m)  =  sqrt((L_Knee_err(:,1) - L_Knee(:,1)).^2);
            RMSD_kneeadd(:,m)   =  sqrt((L_Knee_err(:,2) - L_Knee(:,2)).^2);
            RMSD_kneerot(:,m)   =  sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2);
            RMSD_ankleflex(:,m) =  sqrt((L_Ankle_err(:,1) - L_Ankle(:,1)).^2);
            RMSD_ankleadd(:,m)  =  sqrt((L_Ankle_err(:,2) - L_Ankle(:,2)).^2);
            RMSD_anklerot(:,m)  =  sqrt((L_Ankle_err(:,3) - L_Ankle(:,3)).^2);
            RMSD_footprog(:,m)  =  sqrt((L_Foot_err(:,3)- L_Foot(:,3)).^2);
            % RMSD
            R.LPel_flex.(direction{j}).(E).RMSD(ii)   =  mean(RMSD_pelflex(:,m));
            R.LPel_add.(direction{j}).(E).RMSD(ii)    =  mean(RMSD_peladd(:,m));
            R.LPel_rot.(direction{j}).(E).RMSD(ii)    =  mean(RMSD_pelrot(:,m));
            R.LHip_flex.(direction{j}).(E).RMSD(ii)   =  mean(RMSD_hipflex(:,m));
            R.LHip_add.(direction{j}).(E).RMSD(ii)    =  mean(RMSD_hipadd(:,m));
            R.LHip_rot.(direction{j}).(E).RMSD(ii)    =  mean(RMSD_hiprot(:,m));
            R.LKnee_flex.(direction{j}).(E).RMSD(ii)  =  mean(RMSD_kneeflex(:,m));
            R.LKnee_add.(direction{j}).(E).RMSD(ii)   =  mean(RMSD_kneeadd(:,m));
            R.LKnee_rot.(direction{j}).(E).RMSD(ii)   =  mean(RMSD_kneerot(:,m));
            R.LAnkle_flex.(direction{j}).(E).RMSD(ii) =  mean(RMSD_ankleflex(:,m));
            R.LAnkle_add.(direction{j}).(E).RMSD(ii)  =  mean(RMSD_ankleadd(:,m));
            R.LAnkle_rot.(direction{j}).(E).RMSD(ii)  =  mean(RMSD_anklerot(:,m));
            R.LFoot_prog.(direction{j}).(E).RMSD(ii)  =  mean(RMSD_footprog(:,m));
            
            % max RMSD
            R.LPel_flex.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_hipflex(:,m));
            R.LPel_add.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_hipadd(:,m));
            R.LPel_rot.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_hiprot(:,m));
            R.LHip_flex.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_hipflex(:,m));
            R.LHip_add.(direction{j}).(E).max_RMSD(ii)    =  max(RMSD_hipadd(:,m));
            R.LHip_rot.(direction{j}).(E).max_RMSD(ii)    =  max(RMSD_hiprot(:,m));
            R.LKnee_flex.(direction{j}).(E).max_RMSD(ii)  =  max(RMSD_kneeflex(:,m));
            R.LKnee_add.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_kneeadd(:,m));
            R.LKnee_rot.(direction{j}).(E).max_RMSD(ii)   =  max(RMSD_kneerot(:,m));
            R.LAnkle_flex.(direction{j}).(E).max_RMSD(ii) =  max(RMSD_ankleflex(:,m));
            R.LAnkle_add.(direction{j}).(E).max_RMSD(ii)  =  max(RMSD_ankleadd(:,m));
            R.LAnkle_rot.(direction{j}).(E).max_RMSD(ii)  =  max(RMSD_anklerot(:,m));
            R.LFoot_prog.(direction{j}).(E).max_RMSD(ii)  =  max(RMSD_footprog(:,m));
            
            % standard deviation RMSD
            R.LPel_flex.(direction{j}).(E).SD(ii)   =  std(RMSD_pelflex(:,m));
            R.LPel_add.(direction{j}).(E).SD(ii)    =  std(RMSD_peladd(:,m));
            R.LPel_rot.(direction{j}).(E).SD(ii)    =  std(RMSD_pelrot(:,m));
            R.LHip_flex.(direction{j}).(E).SD(ii)   =  std(RMSD_hipflex(:,m));
            R.LHip_add.(direction{j}).(E).SD(ii)    =  std(RMSD_hipadd(:,m));
            R.LHip_rot.(direction{j}).(E).SD(ii)    =  std(RMSD_hiprot(:,m));
            R.LKnee_flex.(direction{j}).(E).SD(ii)  =  std(RMSD_kneeflex(:,m));
            R.LKnee_add.(direction{j}).(E).SD(ii)   =  std(RMSD_kneeadd(:,m));
            R.LKnee_rot.(direction{j}).(E).SD(ii)   =  std(RMSD_kneerot(:,m));
            R.LAnkle_flex.(direction{j}).(E).SD(ii) =  std(RMSD_ankleflex(:,m));
            R.LAnkle_add.(direction{j}).(E).SD(ii)  =  std(RMSD_ankleadd(:,m));
            R.LAnkle_rot.(direction{j}).(E).SD(ii)  =  std(RMSD_anklerot(:,m));
            R.LFoot_prog.(direction{j}).(E).SD(ii)  =  std(RMSD_footprog(:,m));
        end
    end
 
end
Angle_names = [];
Pel_tilt_RMSD = []; Pel_obliq_RMSD = []; Pel_rot_RMSD=[];
Hip_flex_RMSD=[]; Hip_add_RMSD=[]; Hip_rot_RMSD=[];
Knee_flex_RMSD=[]; Knee_add_RMSD=[]; Knee_rot_RMSD=[];
Ankle_flex_RMSD=[]; Ankle_add_RMSD=[]; Ankle_rot_RMSD=[];
Foot_prog_RMSD=[];
Pel_tilt_max = []; Pel_obliq_max = []; Pel_rot_max=[];
Hip_flex_max=[]; Hip_add_max=[]; Hip_rot_max=[];
Knee_flex_max=[]; Knee_add_max=[]; Knee_rot_max=[];
Ankle_flex_max=[]; Ankle_add_max=[]; Ankle_rot_max=[];
Foot_prog_max=[];
Pel_tilt_SD = []; Pel_obliq_SD = []; Pel_rot_SD=[];
Hip_flex_SD=[]; Hip_add_SD=[]; Hip_rot_SD=[];
Knee_flex_SD=[]; Knee_add_SD=[]; Knee_rot_SD=[];
Ankle_flex_SD=[]; Ankle_add_SD=[]; Ankle_rot_SD=[];
Foot_prog_SD=[];
for j = 1:length(direction)
    for m = 1:length(Magnitude)
        E = ['Misp_',num2str(Magnitude(m))];
            Angle_names     = [Angle_names; string(strcat(E, '_LASI'))];
            Pel_tilt_RMSD   = [Pel_tilt_RMSD; R.LPel_flex.(direction{j}).(E).RMSD];
            Pel_obliq_RMSD   = [Pel_obliq_RMSD; R.LPel_add.(direction{j}).(E).RMSD];
            Pel_rot_RMSD   = [Pel_rot_RMSD; R.LPel_rot.(direction{j}).(E).RMSD];
            Hip_flex_RMSD   = [Hip_flex_RMSD; R.LHip_flex.(direction{j}).(E).RMSD];
            Hip_add_RMSD    = [Hip_add_RMSD; R.LHip_add.(direction{j}).(E).RMSD];
            Hip_rot_RMSD    = [Hip_rot_RMSD; R.LHip_rot.(direction{j}).(E).RMSD];
            Knee_flex_RMSD  = [Knee_flex_RMSD; R.LKnee_flex.(direction{j}).(E).RMSD];
            Knee_add_RMSD   = [Knee_add_RMSD; R.LKnee_add.(direction{j}).(E).RMSD];
            Knee_rot_RMSD   = [Knee_rot_RMSD; R.LKnee_rot.(direction{j}).(E).RMSD];
            Ankle_flex_RMSD = [Ankle_flex_RMSD; R.LAnkle_flex.(direction{j}).(E).RMSD];
            Ankle_add_RMSD  = [Ankle_add_RMSD; R.LAnkle_add.(direction{j}).(E).RMSD];
            Ankle_rot_RMSD  = [Ankle_rot_RMSD; R.LAnkle_rot.(direction{j}).(E).RMSD];
            Foot_prog_RMSD  = [Foot_prog_RMSD; R.LFoot_prog.(direction{j}).(E).RMSD];
            
            Pel_tilt_max    = [Pel_tilt_max; R.LPel_flex.(direction{j}).(E).max_RMSD];
            Pel_obliq_max     = [Pel_obliq_max; R.LPel_add.(direction{j}).(E).max_RMSD];
            Pel_rot_max     = [Pel_rot_max; R.LPel_rot.(direction{j}).(E).max_RMSD];
            Hip_flex_max    = [Hip_flex_max; R.LHip_flex.(direction{j}).(E).max_RMSD];
            Hip_add_max     = [Hip_add_max; R.LHip_add.(direction{j}).(E).max_RMSD];
            Hip_rot_max     = [Hip_rot_max; R.LHip_rot.(direction{j}).(E).max_RMSD];
            Knee_flex_max   = [Knee_flex_max; R.LKnee_flex.(direction{j}).(E).max_RMSD];
            Knee_add_max    = [Knee_add_max; R.LKnee_add.(direction{j}).(E).max_RMSD];
            Knee_rot_max    = [Knee_rot_max; R.LKnee_rot.(direction{j}).(E).max_RMSD];
            Ankle_flex_max  = [Ankle_flex_max; R.LAnkle_flex.(direction{j}).(E).max_RMSD];
            Ankle_add_max   = [Ankle_add_max; R.LAnkle_add.(direction{j}).(E).max_RMSD];
            Ankle_rot_max   = [Ankle_rot_max; R.LAnkle_rot.(direction{j}).(E).max_RMSD];
            Foot_prog_max   = [Foot_prog_max; R.LFoot_prog.(direction{j}).(E).max_RMSD];
            
            Pel_tilt_SD   = [Pel_tilt_SD; R.LPel_flex.(direction{j}).(E).SD];
            Pel_obliq_SD    = [Pel_obliq_SD; R.LPel_flex.(direction{j}).(E).SD];
            Pel_rot_SD    = [Pel_rot_SD; R.LPel_flex.(direction{j}).(E).SD];
            Hip_flex_SD   = [Hip_flex_SD; R.LHip_flex.(direction{j}).(E).SD];
            Hip_add_SD    = [Hip_add_SD; R.LHip_add.(direction{j}).(E).SD];
            Hip_rot_SD    = [Hip_rot_SD; R.LHip_rot.(direction{j}).(E).SD];
            Knee_flex_SD  = [Knee_flex_SD; R.LKnee_flex.(direction{j}).(E).SD];
            Knee_add_SD   = [Knee_add_SD; R.LKnee_add.(direction{j}).(E).SD];
            Knee_rot_SD   = [Knee_rot_SD; R.LKnee_rot.(direction{j}).(E).SD];
            Ankle_flex_SD = [Ankle_flex_SD; R.LAnkle_flex.(direction{j}).(E).SD];
            Ankle_add_SD  = [Ankle_add_SD; R.LAnkle_add.(direction{j}).(E).SD];
            Ankle_rot_SD  = [Ankle_rot_SD; R.LAnkle_rot.(direction{j}).(E).SD];
            Foot_prog_SD  = [Foot_prog_SD; R.LFoot_prog.(direction{j}).(E).SD];           
        end
    end
end

