function [RR, Table1] = MIS_table_RMSD(Angles, Error, Er, MM, counter, data_path, C3D_filenames)
% Create a table with RMSD +SD and ROM +SD for the different angles at 10
% mm of marker misplacement

direction  = {'Lat', 'Prox', 'Med', 'Dist'};
dirs(:,1)  = MM(:,1);
dirs(:,2)  = MM(:,3);
dirs(:,3)  = MM(:,5);
dirs(:,4)  = MM(:,7);
% Plot kinematic data for each direction    
%% 1. Normalize gait cycle
c = 1;
for sub = 1:counter
    acq = btkReadAcquisition(strcat(data_path, C3D_filenames{c}));
    ff = btkGetFirstFrame(acq);
    events = btkGetEvents(acq);
    ev_ff = (round(events.Left_Foot_Strike(1)*100))-ff+1;
    ev_lf = (round(events.Left_Foot_Strike(2)*100))-ff+1;
    ev_fo = (round(events.Left_Foot_Off(1)*100))-ff+1;
    
    fo = ev_fo-ev_ff; lf = ev_lf-ev_ff;
    
    time = 0:100;
    c = c +2;
    
    PT = []; PO = []; PR = [];
    HF = []; HA = []; HR = [];
    KF = []; KA = []; KR = [];
    AF = []; AA = []; AR = []; FP = [];
    %% 2. Original angles
    L_Pelvis= Angles(sub).original.LPelvisAngles_PyCGM1(ev_ff:ev_lf,:);
    L_Hip   = Angles(sub).original.LHipAngles_PyCGM1(ev_ff:ev_lf,:);
    L_Knee  = Angles(sub).original.LKneeAngles_PyCGM1(ev_ff:ev_lf,:);
    L_Ankle = Angles(sub).original.LAnkleAngles_PyCGM1(ev_ff:ev_lf,:);
    L_Foot  = Angles(sub).original.LFootProgressAngles_PyCGM1(ev_ff:ev_lf,:);
    
    %% 3. Calculate RMSD
    for j = 1:length(direction)
        for k = 1:length(Er)
            EE = ['Misp_',num2str(Er(k))];
            Pelvis= strcat('LPelvisAngles_',string(dirs(k,j)));
            Hip   = strcat('LHipAngles_', string(dirs(k,j)));
            Knee  = strcat('LKneeAngles_', string(dirs(k,j)));
            Ankle = strcat('LAnkleAngles_', string(dirs(k,j)));
            Foot  = strcat('LFootProgressAngles_', string(dirs(k,j)));
            
            L_Pelvis_err = Angles(sub).error.(char(Hip))(ev_ff:ev_lf,:); %%sss
            L_Hip_err  = Angles(sub).error.(char(Hip))(ev_ff:ev_lf,:);
            L_Knee_err = Angles(sub).error.(char(Knee))(ev_ff:ev_lf,:);
            L_Ankle_err= Angles(sub).error.(char(Ankle))(ev_ff:ev_lf,:);
            L_Foot_err = Angles(sub).error.(char(Foot))(ev_ff:ev_lf,:);
            
            HF(:,j) =  sqrt((L_Hip_err(:,1) - L_Hip(:,1)).^2);
            HA(:,j) =  sqrt((L_Hip_err(:,2) - L_Hip(:,2)).^2);
            HR(:,j) =  sqrt((L_Hip_err(:,3) - L_Hip(:,3)).^2);
            KF(:,j) =  sqrt((L_Knee_err(:,1) - L_Knee(:,1)).^2);
            KA(:,j) =  sqrt((L_Knee_err(:,2) - L_Knee(:,2)).^2);
            KR(:,j) =  sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2);
            AF(:,j) =  sqrt((L_Ankle_err(:,1) - L_Ankle(:,1)).^2);
            AA(:,j) =  sqrt((L_Ankle_err(:,2) - L_Ankle(:,2)).^2);
            AR(:,j) =  sqrt((L_Ankle_err(:,3) - L_Ankle(:,3)).^2);
%             AR_swing= mean(sqrt((L_Ankle_err(fo:lf,3))-(L_Ankle(fo+1:lf+1,3))));
            FP(:,j) =  sqrt((L_Foot_err(:,3)-L_Foot(:,3)).^2);
            
            %HIP
            RR.HipFlex.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Hip_err(:,1)))-(max(L_Hip(:,1))))^2);
            RR.HipFlex.(direction{j}).(EE).RMSD(sub) = mean(HF(:,j));
            RR.HipFlex.(direction{j}).(EE).SD(sub)   = std(HF(:,j));
            RR.HipFlex.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Hip_err(:,1))-min(L_Hip_err(:,1)))-(max(L_Hip(:,1))-min(L_Hip(:,1))))^2);

            RR.HipAdd.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Hip_err(:,2)))-(max(L_Hip(:,2))))^2);
            RR.HipAdd.(direction{j}).(EE).RMSD(sub) = mean(HA(:,j));
            RR.HipAdd.(direction{j}).(EE).SD(sub)   = std(HA(:,j));
            RR.HipAdd.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Hip_err(:,2))-min(L_Hip_err(:,2)))-(max(L_Hip(:,2))-min(L_Hip(:,2))))^2);
            
            RR.HipRot.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Hip_err(:,3)))-(max(L_Hip(:,3))))^2);
            RR.HipRot.(direction{j}).(EE).RMSD(sub) = mean(mean(HR(:,j)));
            RR.HipRot.(direction{j}).(EE).SD(sub)   = std(HR(:,j));
            RR.HipRot.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Hip_err(:,3))-min(L_Hip_err(:,3)))-(max(L_Hip(:,3))-min(L_Hip(:,3))))^2);
            
            %KNEE
            RR.KneeFlex.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Knee_err(:,1)))-(max(L_Knee(:,1))))^2);
            RR.KneeFlex.(direction{j}).(EE).RMSD(sub) = mean(KF(:,j));
            RR.KneeFlex.(direction{j}).(EE).SD(sub)   = std(KF(:,j));
            RR.KneeFlex.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Knee_err(:,1))-min(L_Knee_err(:,1)))-(max(L_Knee(:,1))-min(L_Knee(:,1))))^2);
            
            RR.KneeAdd.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Knee_err(:,2)))-(max(L_Knee(:,2))))^2);
            RR.KneeAdd.(direction{j}).(EE).RMSD(sub) = mean(KA(:,j));
            RR.KneeAdd.(direction{j}).(EE).SD(sub)   = std(KA(:,j));
            RR.KneeAdd.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Knee_err(:,2))-min(L_Knee_err(:,2)))-(max(L_Knee(:,2))-min(L_Knee(:,2))))^2);

            RR.KneeRot.(direction{j}).(EE).peak(sub) = sqrt(((max(L_Knee_err(:,3)))-(max(L_Knee(:,3))))^2);
            RR.KneeRot.(direction{j}).(EE).RMSD(sub) = mean(sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2));
            RR.KneeRot.(direction{j}).(EE).SD(sub)   = std(sqrt((L_Knee_err(:,3) - L_Knee(:,3)).^2));
            RR.KneeRot.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Knee_err(:,3))-min(L_Knee_err(:,3)))-(max(L_Knee(:,3))-min(L_Knee(:,3))))^2);
            
            %ANKLE
            RR.AnkleFlex.(direction{j}).(EE).peak(sub) = sqrt(((min(L_Ankle_err(:,1)))-(min(L_Ankle(:,1))))^2);
            RR.AnkleFlex.(direction{j}).(EE).RMSD(sub) = mean(AF(:,j));
            RR.AnkleFlex.(direction{j}).(EE).SD(sub)   = std(AF(:,j));
            RR.AnkleFlex.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Ankle_err(:,1))-min(L_Ankle_err(:,1)))-(max(L_Ankle(:,1))-min(L_Ankle(:,1))))^2);
            
            RR.AnkleAdd.(direction{j}).(EE).RMSD(sub) = mean(AA(:,j));
            RR.AnkleAdd.(direction{j}).(EE).SD(sub)   = std(AA(:,j));
            RR.AnkleAdd.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Ankle_err(:,2))-min(L_Ankle_err(:,2)))-(max(L_Ankle(:,2))-min(L_Ankle(:,2))))^2);
            
%             RR.AnkleRot.(direction{j}).(EE).swing(sub) = mean(sqrt(((L_Ankle_err(fo:lf,3))-(L_Ankle(fo+1:lf+1,3))).^2));
%             RR.AnkleRot.(direction{j}).(EE).swingROM(sub)= sqrt(((max(L_Ankle_err(fo:lf,3))-min(L_Ankle_err(fo:lf,3)))-(max(L_Ankle(fo:lf,3))-min(L_Ankle(fo:lf,3))))^2);
            RR.AnkleRot.(direction{j}).(EE).RMSD(sub)  = mean(AR(:,j));
            RR.AnkleRot.(direction{j}).(EE).SD(sub)    = std(AR(:,j));
            RR.AnkleRot.(direction{j}).(EE).ROM(sub)   = sqrt(((max(L_Ankle_err(:,3))-min(L_Ankle_err(:,3)))-(max(L_Ankle(:,3))-min(L_Ankle(:,3))))^2);
            
            %Foot progression
            RR.FootProg.(direction{j}).(EE).RMSD(sub) = mean(FP(:,j));
            RR.FootProg.(direction{j}).(EE).SD(sub)   = std(FP(:,j));
            RR.FootProg.(direction{j}).(EE).ROM(sub)  = sqrt(((max(L_Foot_err(:,3))-min(L_Foot_err(:,3)))-(max(L_Foot(:,3))-min(L_Foot(:,3))))^2);
        end
    end
end

%% 3. Mean over all patients 
for i = 1:length(direction)
    HF_peak_m(i)   = mean(RR.HipFlex.(direction{i}).Misp_10.peak);
    HF_peak_std(i) = std(RR.HipFlex.(direction{i}).Misp_10.peak);
    HF_m(i) = mean(RR.HipFlex.(direction{i}).Misp_10.RMSD);
    HF_std(i) = std(RR.HipFlex.(direction{i}).Misp_10.RMSD);
    HF_ROM_m(i)   = mean(RR.HipFlex.(direction{i}).Misp_10.ROM);
    HF_ROM_std(i) = std(RR.HipFlex.(direction{i}).Misp_10.ROM);
    
    HA_peak_m(i)   = mean(RR.HipAdd.(direction{i}).Misp_10.peak);
    HA_peak_std(i) = std(RR.HipAdd.(direction{i}).Misp_10.peak);
    HA_m(i) = mean(RR.HipAdd.(direction{i}).Misp_10.RMSD);
    HA_std(i) = std(RR.HipAdd.(direction{i}).Misp_10.RMSD);
    HA_ROM_m(i)   = mean(RR.HipAdd.(direction{i}).Misp_10.ROM);
    HA_ROM_std(i) = std(RR.HipAdd.(direction{i}).Misp_10.ROM);
    
    HR_peak_m(i)   = mean(RR.HipRot.(direction{i}).Misp_10.peak);
    HR_peak_std(i) = std(RR.HipRot.(direction{i}).Misp_10.peak);
    HR_m(i) = mean(RR.HipRot.(direction{i}).Misp_10.RMSD);
    HR_std(i) = std(RR.HipRot.(direction{i}).Misp_10.RMSD);
    HR_ROM_m(i)   = mean(RR.HipRot.(direction{i}).Misp_10.ROM);
    HR_ROM_std(i) = std(RR.HipRot.(direction{i}).Misp_10.ROM);
    
    KF_peak_m(i)   = mean(RR.KneeFlex.(direction{i}).Misp_10.peak);
    KF_peak_std(i) = std(RR.KneeFlex.(direction{i}).Misp_10.peak);
    KF_m(i) = mean(RR.KneeFlex.(direction{i}).Misp_10.RMSD);
    KF_std(i) = std(RR.KneeFlex.(direction{i}).Misp_10.RMSD);
    KF_ROM_m(i)   = mean(RR.KneeFlex.(direction{i}).Misp_10.ROM);
    KF_ROM_std(i) = std(RR.KneeFlex.(direction{i}).Misp_10.ROM);
    
    KA_peak_m(i)   = mean(RR.KneeAdd.(direction{i}).Misp_10.peak);
    KA_peak_std(i) = std(RR.KneeAdd.(direction{i}).Misp_10.peak);
    KA_m(i) = mean(RR.KneeAdd.(direction{i}).Misp_10.RMSD);
    KA_std(i) = std(RR.KneeAdd.(direction{i}).Misp_10.RMSD);
    KA_ROM_m(i)   = mean(RR.KneeAdd.(direction{i}).Misp_10.ROM);
    KA_ROM_std(i) = std(RR.KneeAdd.(direction{i}).Misp_10.ROM);
    
    KR_peak_m(i)   = mean(RR.KneeRot.(direction{i}).Misp_10.peak);
    KR_peak_std(i) = std(RR.KneeRot.(direction{i}).Misp_10.peak);
    KR_m(i) = mean(RR.KneeRot.(direction{i}).Misp_10.RMSD);
    KR_std(i) = std(RR.KneeRot.(direction{i}).Misp_10.RMSD);
    KR_ROM_m(i)   = mean(RR.KneeRot.(direction{i}).Misp_10.ROM);
    KR_ROM_std(i) = std(RR.KneeRot.(direction{i}).Misp_10.ROM);
    
    AF_peak_m(i)   = mean(RR.AnkleFlex.(direction{i}).Misp_10.peak);
    AF_peak_std(i) = std(RR.AnkleFlex.(direction{i}).Misp_10.peak);
    AF_m(i) = mean(RR.AnkleFlex.(direction{i}).Misp_10.RMSD);
    AF_std(i) = std(RR.AnkleFlex.(direction{i}).Misp_10.RMSD);
    AF_ROM_m(i)   = mean(RR.AnkleFlex.(direction{i}).Misp_10.ROM);
    AF_ROM_std(i) = std(RR.AnkleFlex.(direction{i}).Misp_10.ROM);
    
    AA_m(i) = mean(RR.AnkleAdd.(direction{i}).Misp_10.RMSD);
    AA_std(i) = std(RR.AnkleAdd.(direction{i}).Misp_10.RMSD);
    AA_ROM_m(i)   = mean(RR.AnkleAdd.(direction{i}).Misp_10.ROM);
    AA_ROM_std(i) = std(RR.AnkleAdd.(direction{i}).Misp_10.ROM);
    
%     AR_swing_m(i)   = mean(RR.AnkleRot.(direction{i}).Misp_10.swing);
%     AR_swing_std(i)  = std(RR.AnkleRot.(direction{i}).Misp_10.swing);
%     AR_swing_ROM(i) = mean(RR.AnkleRot.(direction{i}).Misp_10.swingROM);
%     AR_swing_ROM_std(i) = std(RR.AnkleRot.(direction{i}).Misp_10.swingROM);
    AR_m(i) = mean(RR.AnkleRot.(direction{i}).Misp_10.RMSD);
    AR_std(i) = std(RR.AnkleRot.(direction{i}).Misp_10.RMSD);
    AR_ROM_m(i)   = mean(RR.AnkleRot.(direction{i}).Misp_10.ROM);
    AR_ROM_std(i) = std(RR.AnkleRot.(direction{i}).Misp_10.ROM);
    
    FP_m(i) = mean(RR.FootProg.(direction{i}).Misp_10.RMSD);
    FP_std(i) = std(RR.FootProg.(direction{i}).Misp_10.RMSD);
    FP_ROM_m(i) = mean(RR.FootProg.(direction{i}).Misp_10.ROM);
    FP_ROM_std(i) = std(RR.FootProg.(direction{i}).Misp_10.ROM);
end

%% 4. Define table
col = 1;
for i = 1:length(direction)
%     HF_peak(col)=HF_peak_m(i); HF_peak(col+1)=HF_peak_std(i); HF_peak(col+2:col+3)=0;
    HF_c(col)=HF_m(i); HF_c(col+1)=HF_std(i); HF_c(col+2)=HF_ROM_m(i); HF_c(col+3)=HF_ROM_std(i);
%     HA_peak(col)=HA_peak_m(i); HA_peak(col+1)=HA_peak_std(i); HA_peak(col+2:col+3)=0;
    HA_c(col)=HA_m(i); HA_c(col+1)=HA_std(i); HA_c(col+2)=HA_ROM_m(i); HA_c(col+3)=HA_ROM_std(i); 
%     HR_peak(col)=HR_peak_m(i); HR_peak(col+1)=HR_peak_std(i); HR_peak(col+2:col+3)=0;
    HR_c(col)=HR_m(i); HR_c(col+1)=HR_std(i); HR_c(col+2)=HR_ROM_m(i); HR_c(col+3)=HR_ROM_std(i);
    
%     KF_peak(col)=KF_peak_m(i); KF_peak(col+1)=KF_peak_std(i); KF_peak(col+2:col+3)=0;
    KF_c(col)=KF_m(i); KF_c(col+1)=KF_std(i); KF_c(col+2)=KF_ROM_m(i); KF_c(col+3)=KF_ROM_std(i);
%     KA_peak(col)=KA_peak_m(i); KA_peak(col+1)=KA_peak_std(i); KA_peak(col+2:col+3)=0;
    KA_c(col)=KA_m(i); KA_c(col+1)=KA_std(i); KA_c(col+2)=KA_ROM_m(i); KA_c(col+3)=KA_ROM_std(i); 
%     KR_peak(col)=KR_peak_m(i); KR_peak(col+1)=KR_peak_std(i); KR_peak(col+2:col+3)=0;
    KR_c(col)=KR_m(i); KR_c(col+1)=KR_std(i); KR_c(col+2)=KR_ROM_m(i); KR_c(col+3)=KR_ROM_std(i);
    
%     AF_peak(col)=AF_peak_m(i); AF_peak(col+1)=AF_peak_std(i); AF_peak(col+2:col+3)=0;
%     AF_c(col)=AF_m(i); AF_c(col+1)=AF_std(i); AF_c(col+2)=AF_ROM_m(i); AF_c(col+3)=HF_ROM_std(i);
%     AA_c(col)=AA_m(i); AA_c(col+1)=AA_std(i); AA_c(col+2)=AA_ROM_m(i); AA_c(col+3)=HA_ROM_std(i); 
%     AR_c(col)=AR_m(i); AR_c(col+1)=AR_std(i); AR_c(col+2)=AR_ROM_m(i); AR_c(col+3)=HR_ROM_std(i);
%     AR_swing(col)=AR_swing_m(i); AR_swing(col+2)=AR_swing_std(i); AR_swing(col+3)=AR_swing_ROM(i); AR_swing(col+3)=AR_swing_ROM_std(i);
    
    FP_c(col)=FP_m(i); FP_c(col+1)=FP_std(i); FP_c(col+2)=FP_ROM_m(i); FP_c(col+3)=FP_ROM_std(i);
    col = col+4;
end

table_mat = [HF_peak;HF_c;HA_peak;HA_c;HR_peak;HR_c; KF_peak;KF_c;KA_peak;KA_c;KR_peak;KR_c; AF_peak;AF_c;AA_c;AR_c; FP_c]; %AR_swing;
Table1 = table(table_mat);

end