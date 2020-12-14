function M = MIS_PlotCurves(Angles, Er, MM, subject, data_path, C3D_filename, LineColor, Angle1, Angle2, marker, joint, direct)
% Plot kinematic data for each direction for one angle joint   

% Input:
% Angles: Kinematic data
% MM: names misplacements
% subject : number of the subject
% Angle1 and Angle2: values of the angles (°) to plot
% joint: name of the joint to plot kinematics
% direct: direction (for the plot title)

%% 1. Normalize gait cycle
    acq = btkReadAcquisition(strcat(data_path, C3D_filename));
    ff = btkGetFirstFrame(acq);
    events = btkGetEvents(acq);
    event_ff = (round(events.Left_Foot_Strike(1)*100))-ff+1;
    event_lf = round(events.Left_Foot_Strike(2)*100)-ff+1;
    time = 0:100;
%% 2. Original angles
    L_Angles = Angles(subject).original.(strcat('L', joint, 'Angles_PyCGM1'));
    for j = 1:3
        subplot(3,1,j)
        L_Angle_x = interp1 (L_Angles(event_ff:event_lf,j), 1:101);
        plot(time,  L_Angle_x, 'k')
        xlim([0 100])
        hold on
    end
    for i = 1:length(Er)
        L_er = Angles(subject).error.(strcat('L',joint,'Angles_', marker, '_', num2str(Angle1), '_', num2str(Er(i)), '_AP_ML'));
        L_Angle(:,1) = interp1 (L_er(event_ff:event_lf,1), 1:101);
        subplot(3,1,1)
        plot(time,L_Angle(:,1), 'Color', LineColor{i})
        title(strcat(joint, ' Flex/Extension  ', direct))
        xlim([0 100])
        ylim([-35 70])
        hold on
        
        L_Angle(:,2) = interp1 (L_er(event_ff:event_lf,2), 1:101);
        subplot(3,1,2)
        plot(time,L_Angle(:,2), 'Color', LineColor{i})
        title(strcat(joint, ' Add/Abduction  ', direct))
        xlim([0 100])
        ylim([-35 70])
        hold on
        
        L_Angle(:,3) = interp1 (L_er(event_ff:event_lf,3), 1:101);
        subplot(3,1,3)
        plot(time,L_Angle(:,3), 'Color', LineColor{i})
        title(strcat(joint, ' Int/External rotation  ', direct))
        xlim([0 100])
        ylim([-35 70])
        hold on
        
        L_er = Angles(subject).error.(strcat('L',joint,'Angles_', marker, '_', num2str(Angle2), '_', num2str(Er(i)), '_AP_ML'));
        L_Angle(:,1) = interp1 (L_er(event_ff:event_lf,1), 1:101);
        subplot(3,1,1)
        plot(time,L_Angle(:,1), 'Color', LineColor{i})
        xlim([0 100])
        hold on
        
        L_Angle(:,2) = interp1 (L_er(event_ff:event_lf,2), 1:101);
        subplot(3,1,2)
        plot(time,L_Angle(:,2), 'Color', LineColor{i})
        xlim([0 100])
        hold on
        
        L_Angle(:,3) = interp1 (L_er(event_ff:event_lf,3), 1:101);
        subplot(3,1,3)
        plot(time,L_Angle(:,3), 'Color', LineColor{i})
        xlim([0 100])
        hold on
    end
end
