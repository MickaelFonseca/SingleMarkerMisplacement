function [Correl, C, Table_Correl] = MIS_Correlation_all(Parameter, R, Er, x_lim, y_lim, counter, direction)

c=1;
for i=1:counter
    for j = 1:length(Er)
        
        % Calculate % of leg length for each error (vector 1 x (number of patients*5))
        Param(c) = (Er(j)*10)/Parameter(i);
        
        % Vector for each angle with all RMSD of patients for a specific
        % direction (e.g. ant)
        RMSD.(direction).LPelvic_tilt(c) = R.LPelvis_til.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LPelvic_obliquity(c) = R.LPelvis_obl.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LPelvic_rot(c) = R.LPelvis_rot.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LHip_flex(c) = R.LHip_flex.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LHip_add(c) = R.LHip_add.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LHip_rot(c) = R.LHip_rot.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LKnee_flex(c) = R.LKnee_flex.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LKnee_add(c) = R.LKnee_add.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LKnee_rot(c) = R.LKnee_rot.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LAnkle_flex(c) = R.LAnkle_flex.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LAnkle_add(c) = R.LAnkle_add.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        RMSD.(direction).LAnkle_rot(c) = R.LAnkle_rot.(direction).(strcat('Misp_',num2str(Er(j)))).RMSD(i);
        c = c+1;        
    end
end

% Scatter Plot
% Angle_name = {'LHip_flex', 'LHip_add', 'LHip_rot', 'LKnee_flex', 'LKnee_add', 'LKnee_rot', 'LAnkle_flex', 'LAnkle_add', 'LAnkle_rot'};
Angle_name = {'LPelvic_tilt', 'LPelvic_obliquity','LPelvic_rot' ,'LHip_flex', 'LHip_add', 'LHip_rot', 'LKnee_flex', 'LKnee_add', 'LKnee_rot', 'LAnkle_flex', 'LAnkle_add', 'LAnkle_rot'};
Title_name = {'Pelvic Tilt', 'Pelvic Obliquity','Pelvic Internal-External Rotation' ,'Hip Flexion-Extension', 'Hip Adduction/Abduction', ...
    'Hip Internal-External Rotation', 'Knee Flexion-Extension', 'Knee Adduction-Abduction', 'Knee Internal-External Rotation', 'Ankle Flex', 'Ankle add', 'Ankle rot'};

col = 1;

for i = 1:12   
    s = subplot(4,3,i)
    s = scatter(Param,RMSD.(direction).(Angle_name{i}))
    hold on
    a5=area([0 100],[5 5], 'FaceColor', [0.9290, 0.6940, 0.1250], 'EdgeColor',[0.9290, 0.6940, 0.1250]);
    a5.FaceAlpha = 0.15; a5.EdgeAlpha = 0.15;
    a2=area([0 100],[2 2], 'FaceColor', 'g', 'EdgeColor', 'g');
    a2.FaceAlpha = 0.15; a2.EdgeAlpha = 0.15;
    xlim([0 x_lim])
    ylim([0 y_lim])
    ylabel('RMSD (°)');
    xlabel(['misplacement in percentage of Pelvic Width']);
    title(char(Title_name{i}));
    ax = gca;
    ax.FontSize = 12;
    [correl, p] = corrcoef(Param,RMSD.(direction).(Angle_name{i}));
    Correl.(direction).(Angle_name{i}).R = correl;
    Correl.(direction).(Angle_name{i}).p = p;
    
    x  = Param;
    y  = RMSD.(direction).(Angle_name{i});
    b1 = x/y;
    P = polyfit(x,y,1);
    Correl.(direction).(Angle_name{i}).slope = P(1);
    Correl.(direction).(Angle_name{i}).intercept = P(2);
    yfit = P(1)*x + P(2);
    f = polyval(P,x);
    plot(x,f,'-')
end
 C.PT(col)=Correl.(direction).LPelvic_tilt.R(1,2); C.PT(col+1)=Correl.(direction).LPelvic_tilt.slope; C.PT(col+2)= Correl.(direction).LPelvic_tilt.intercept;
 C.PO(col)=Correl.(direction).LPelvic_obliquity.R(1,2); C.PO(col+1)=Correl.(direction).LPelvic_obliquity.slope; C.PO(col+2)= Correl.(direction).LPelvic_obliquity.intercept;
 C.PR(col)=Correl.(direction).LPelvic_rot.R(1,2); C.PR(col+1)=Correl.(direction).LPelvic_rot.slope; C.PR(col+2)= Correl.(direction).LPelvic_rot.intercept;
 C.HF(col)=Correl.(direction).LHip_flex.R(1,2);  C.HF(col+1)=Correl.(direction).LHip_flex.slope;   C.HF(col+2)=Correl.(direction).LHip_flex.intercept;  
 C.HA(col)=Correl.(direction).LHip_add.R(1,2);   C.HA(col+1)=Correl.(direction).LHip_add.slope;    C.HA(col+2)=Correl.(direction).LHip_add.intercept;
 C.HR(col)=Correl.(direction).LHip_rot.R(1,2);   C.HR(col+1)=Correl.(direction).LHip_rot.slope;    C.HR(col+2)=Correl.(direction).LHip_rot.intercept;
 C.KF(col)=Correl.(direction).LKnee_flex.R(1,2); C.KF(col+1)=Correl.(direction).LKnee_flex.slope;  C.KF(col+2)=Correl.(direction).LKnee_flex.intercept;
 C.KA(col)=Correl.(direction).LKnee_add.R(1,2);  C.KA(col+1)=Correl.(direction).LKnee_add.slope;   C.KA(col+2)=Correl.(direction).LKnee_add.intercept;
 C.KR(col)=Correl.(direction).LKnee_rot.R(1,2);  C.KR(col+1)=Correl.(direction).LKnee_rot.slope;   C.KR(col+2)=Correl.(direction).LKnee_rot.intercept;
 C.AF(col)=Correl.(direction).LAnkle_flex.R(1,2);C.AF(col+1)=Correl.(direction).LAnkle_flex.slope; C.AF(col+2)=Correl.(direction).LAnkle_flex.intercept;
 C.AA(col)=Correl.(direction).LAnkle_add.R(1,2); C.AA(col+1)=Correl.(direction).LAnkle_add.slope;  C.AA(col+2)=Correl.(direction).LAnkle_add.intercept;
 C.AR(col)=Correl.(direction).LAnkle_rot.R(1,2); C.AR(col+1)=Correl.(direction).LAnkle_rot.slope;  C.AR(col+2)=Correl.(direction).LAnkle_rot.intercept;
 col = col+3;
 
 Var_Names = {string('R'), string('m'), string('b')}; Var_Names = repmat(Var_Names,1,4);
 Table2_mat= [C.PT; C.PO; C.PR; C.HF; C.HA; C.HR; C.KF; C.KA; C.KR; C.AF; C.AA; C.AR];
 Table_Correl = table(Table2_mat);
 Table_Correl.Properties.VariableDescriptions;

end