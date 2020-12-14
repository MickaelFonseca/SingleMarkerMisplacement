function M = MIS_PlotCurves3(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, marker, joint, direct, val, Error_dir)
% Plot kinematic data for each direction for the 3 joint angles 
% Val, line to be ploted on the subplot
%% 1. Normalize gait cycle
    acq = btkReadAcquisition(strcat(data_path, C3D_filename));
    ff = btkGetFirstFrame(acq);
    events = btkGetEvents(acq);
    event_ff = (round(events.Left_Foot_Strike(1)*100))-ff+1;
    event_lf = round(events.Left_Foot_Strike(2)*100)-ff+1;
    time = 0:100;
%% 2. Original angles (mean +- SD)
% [C3D_filenames, C3D_path]=uigetfile({'*.C3D'},'Select dynamic file C3D ou GCD',['D:\Marker Misplacement Simulation\Test\Patient_1\' '/'],'MultiSelect','on');
% [static_file]=uigetfile({'*.C3D'},'Select static file',['D:\Marker Misplacement Simulation\Test\Patient_1\' '/'],'MultiSelect','on');
    
    L_Angles = Angles(subject).original.(strcat('L', joint, 'Angles_PyCGM1'));
    x = 1:size(L_Angles(event_ff:event_lf,1),1);
    for j = 1:3
        if val == 1
            jj = j;
        elseif val == 2;
            jj = j+3;
        elseif val == 3;
            jj = j+6;
        end
        subplot(3,3,jj)
        L_Angle_x = interp1 (L_Angles(event_ff:event_lf,j), linspace(1,length(x),101));
        plot(time,  L_Angle_x, 'k')
        xlim([0 100])
        hold on
    end
    for i = 1:length(Er)
        if val == 1
            jj = 1;
        elseif val == 2;
            jj = 4;
        elseif val == 3;
            jj = 7;
        end
        L_er = Angles(subject).error.(strcat('L',joint,'Angles_', char(marker), '_', num2str(Angle1), '_', num2str(Er(i)), '_', Error_dir));
        L_Angle(:,1) = interp1 (L_er(event_ff:event_lf,1),linspace(1,length(x),101));
        subplot(3,3,jj)
        plot(time,L_Angle(:,1), 'Color', LineColor{i})
        title(strcat(joint, ' Flexion-Extension  '))
        ax=gca;
        ax.FontSize = 12;
        xlim([0 100])
        xlabel('% gait cycle')
        ylabel('Joint angles (°)')
        ylim([-45 80])
        hold on
        
        L_Angle(:,2) = interp1 (L_er(event_ff:event_lf,2), linspace(1,length(x),101));
        subplot(3,3,jj+1)
        plot(time,L_Angle(:,2), 'Color', LineColor{i})
        title(strcat(joint, ' Adduction/Abduction  '))
        ax=gca;
        ax.FontSize = 12;
        xlim([0 100])
        xlabel('% gait cycle')
        ylabel('Joint angles (°)')
        ylim([-45 80])
        hold on
        
        L_Angle(:,3) = interp1 (L_er(event_ff:event_lf,3), linspace(1,length(x),101));
        subplot(3,3,jj+2)
        plot(time,L_Angle(:,3), 'Color', LineColor{i})
        title(strcat(joint, ' Internal/External rotation  '))
        ax=gca;
        ax.FontSize = 12;
        xlim([0 100])
        xlabel('% gait cycle')
        ylabel('Joint angles (°)')
        ylim([-45 80])
        hold on
        
        L_er = Angles(subject).error.(char(strcat('L',joint,'Angles_', marker, '_', num2str(Angle2), '_', num2str(Er(i)), '_', Error_dir)));
        L_Angle(:,1) = interp1 (L_er(event_ff:event_lf,1), linspace(1,length(x),101));
        subplot(3,3,jj)
        plot(time,L_Angle(:,1), 'Color', LineColor{i}, 'LineStyle','--')
        xlim([0 100])
        hold on
        
        L_Angle(:,2) = interp1 (L_er(event_ff:event_lf,2), linspace(1,length(x),101));
        subplot(3,3,jj+1)
        plot(time,L_Angle(:,2), 'Color', LineColor{i}, 'LineStyle','--')
        xlim([0 100])
        hold on
        
        L_Angle(:,3) = interp1 (L_er(event_ff:event_lf,3), linspace(1,length(x),101));
        subplot(3,3,jj+2)
        plot(time,L_Angle(:,3), 'Color', LineColor{i},'LineStyle', '--')
        xlim([0 100])
        hold on
    end
end
