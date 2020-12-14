cd 'D:\GITLAB\MARK_MISP\MARK_MISP_DATA\MARK_MISP_LKNE_TDC'

load Angles

%% 4. Calculate RMSD 
% compute the results and export RMSD, std and max and mean(over patients)
if length(MARK) == 1
    if string(MARK) == 'LASI' || string(MARK) == 'LPSI'
        direction   = {'Lat', 'Lat_Prox', 'Prox', 'Med_Prox', 'Med', 'Post_Dist', 'Dist', 'Lat_Dist'};
    elseif string(MARK) == 'LHEE'
        direction   = {'Prox', 'Lat_Prox', 'Lat', 'Lat_Dist', 'Dist', 'Med_Dist', 'Med', 'Med_Prox'};      
    elseif string(MARK) == 'LTHI' || string(MARK) == 'LTIB' || string(MARK) == 'LANK' || string(MARK) == 'LKNE'
        direction  = {'Ant', 'Ant_Prox', 'Prox', 'Post_Prox', 'Post', 'Post_Dist', 'Dist', 'Dist_Ant'};
    elseif string(MARK) == 'LTOE'
        direction = {'Lat', 'Lat_Post', 'Post', 'Med_Post', 'Med', 'Med_Ant', 'Ant', 'Lat_Ant'}; 
    end
    [T_RMSD, T_std, T_max, T_m_RMSD, T_m_max, m_RMSD, m_RMSD_pMagn, T_m_RMSD_pMagn, R, T_m_RMSD_SD_10]  = MIS_Res_RMSD(Angles, Error, Er, MM, counter, direction, MARK, 'TDC');
%     MIS_Res_RMSj(Angles, Error, Er, MM, counter, direction, Er);
    
%     [RR, Table1] = MIS_table_RMSD(Angles, Error, Er, MM, counter, data_path, C3D_filenames); 
    writetable(T_m_RMSD_SD_10, 'Table Results RMSD.xls');
elseif length(MARK) == 2
    direction   = {'Med', 'Prox', 'Lat', 'Dist'};
    [T_m_RMSD_10, R10, Angle_names, Joint_Angles]  = MIS_Res_RMSD2(Angles, Error, Er, MM1, MM2, counter, direction, Er(2), 'LASI', 'RASI'); 
else
    disp('Invalid marker selection')
end

% % %% 6. Calculate RMSD for 10mm
% % compute the results and export RMSD, std and max and mean(over patients)
% if length(MARK) == 1
%     direction   = {'Ant', 'Ant_Prox', 'Prox', 'Post_Prox', 'Post', 'Post_Dist', 'Dist', 'Ant_Dist'};
%     [T_RMSD, T_std, T_max, T_m_RMSD, T_m_max, m_RMSD, m_RMSD_pMagn, T_m_RMSD_pMagn, R]  = MIS_Res_RMSD(Angles, Error, Er, MM, counter, direction); 
%     
% elseif length(MARK) == 2
%     direction   = {'Med', 'Prox', 'Lat', 'Dist'};
%     [T_m_RMSD, R, Angle_names, Joint_Angles]  = MIS_Res_RMSD2(Angles, Error, Er, MM1, MM2, counter, direction, Er,'LASI','RASI'); 
% 
% else
%     disp('Invalid marker selection')
% end

%% 5. Plot  Results
if length(MARK) == 2
    figure(1)
    suptitle('Misplacement LASI medially')
    MIS_BarChart(T_m_RMSD, Angle_names, Joint_Angles, 'Med', direction, Er)
    
    figure(2)
    suptitle('Misplacement LASI proximally')
    MIS_BarChart(T_m_RMSD, Angle_names, Joint_Angles, 'Prox', direction, Er)
    
    figure(3)
    suptitle('Misplacement LASI laterally')
    MIS_BarChart(T_m_RMSD, Angle_names, Joint_Angles, 'Lat', direction, Er)
    
    figure(4)
    suptitle('Misplacement LASI distally')
    MIS_BarChart(T_m_RMSD, Angle_names, Joint_Angles, 'Dist', direction, Er)
end


if length(MARK) == 1
    %% 5. Polar Plot
    Label = {'     Lat', 'Lat + Prox', 'Prox', 'Prox + Med', 'Med', 'Med + Dist', 'Dist', 'Dist + Lat'};
    % Label = {'     Ant', 'Ant + Dist', 'Dist', 'Post + Dist', 'Post', 'Post + Prox', 'Prox', 'Ant + Prox'};
    % LineStyle = {'no', ':'};
    % LevelNum = 5;
    % maximo = 12;
    figure(1)
    MIS_PlotPolar(m_RMSD_pMagn, Error, Label, MARK)

    %% 6. Plot Curves of one subject 
    % Containing only one direction 
    C3D_filename = '05_02789_04323_20170207-GBNNN-VDEF-17.C3D';
    Angle1 = 90;
    Angle2 = 270;
    subject = 5;
    LineColor = {'b', 'c', 'g', 'm', 'r'};


    % figure(10)
    % MIS_PlotCurves2(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Hip', 'Prox Dist')
    % 
    % figure(11)
    % MIS_PlotCurves2(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Knee', 'Prox Dist')
    % 
    % figure(12)
    % MIS_PlotCurves2(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'Ankle', 'Ant Post')

    % or all combined
    figure (4)
    MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK, 'Pelvis', 'Prox Dist', 1, Error_dir)
    MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK, 'Hip', 'Prox Dist', 2, Error_dir)
    MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK, 'Knee', 'Prox Dist', 3, Error_dir)
    % MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, MARK1, 'FootProgress', 'Ant Post', 3)


    %% 7.  Scatter Plot

    anthro = MIS_anthropometric_data(C3D_filenames, data_path);                 % get anthropometric data
     Leg_length = zeros(1, length(anthro.subject));
     Knee_Width = zeros(1, length(anthro.subject));
     for i = 1:length(anthro.subject)
         Leg_length(i) = str2double(anthro.subject(i).Left_LegLength_mm)*10;
         Knee_Width(i) = str2double(anthro.subject(i).Left_KneeWidth_mm)*10;
         Pelvic_Width(i) = str2double(anthro.subject(i).Pelvic_Width_mm)*10;
     end

     % Case 1: Regression for each patient. Plot all regressions. Table with
     % mean values from the overral regressions
     figure(2)
     hold on
     for i = 1:10
        [correl_LL, C, Table2] = MIS_Correlation(Pelvic_Width(i), R, Er, 2, 20, 'Leg length', i);   % correl = correlation between  error and leg_length normalized; norm_errors:
     end

     figure (3)
     % Case 2: Combine all values and perform a general regression. 
    direction = 'Ant'; 
    x_lim = 2;
    y_lim = 15;
    [Correl_all, C, Table_Correl] = MIS_Correlation_all(Pelvic_Width, R, Er, x_lim, y_lim, counter, direction)

end
