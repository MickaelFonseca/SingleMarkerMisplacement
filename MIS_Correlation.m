function [Correl, C, Table2] = MIS_Correlation(Parameter, R, Er, x_lim, y_lim, Anthro_param, patient)

    % Function Calculates the correlation between error and % of leg length
    % for each patient
    %
    % Parameter: vector containing leg length parameter of population
    % R : Structure containing RMSD error for each magnitude, direction and
    % joint angles
    % Er: Vector containing values of misplacement magnitude
    % x_lim, y_lim: setup for the scatter plot
    % Anthro_param: anthropometric variable to compare (Leg Length)
    % patient: number of the patients
    
    Angle_name = {'LHip_flex', 'LHip_add', 'LHip_rot', 'LKnee_flex', 'LKnee_add', 'LKnee_rot', 'LAnkle_flex', 'LAnkle_add', 'LAnkle_rot'};
    top = {'Leg_length','RMSD_Error_5mm', 'RMSD_Error_10mm', 'RMSD_Error_15mm', 'RMSD_Error_20mm','RMSD_Error_30mm'};
    direction = {'Dist'}%, 'Prox','Post', 'Dist'};
    % Table normalized error magnitude by leg length
    for i = 1:length(Parameter)
        for j = 1:length(Er)
            norm_err(i,j) = (Er(j)*10)/Parameter(i);
        end
    end
    norm_error = table(Parameter', norm_err(:,1), norm_err(:,2), norm_err(:,3), norm_err(:,4),norm_err(:,5));
    norm_error.Properties.VariableNames = {'Pelvic_width', 'Error_5mm', 'Error_10mm', 'Error_15mm', 'Error_20mm','Error_30mm'};
    col = 1;
    for d = 1:length(direction)
        for i = 1:length(Angle_name)
            corr_Anterior = table(Parameter, R.(Angle_name{i}).(direction{d}).Misp_5.RMSD(patient), R.(Angle_name{i}).(direction{d}).Misp_10.RMSD(patient), R.(Angle_name{i}).(direction{d}).Misp_15.RMSD(patient), R.(Angle_name{i}).(direction{d}).Misp_20.RMSD(patient), R.(Angle_name{i}).(direction{d}).Misp_30.RMSD(patient));
            %corr_Anterior = table(Leg_length', R.(Angle_name{i}).(direction{d}).Misp_5.RMSD', R.(Angle_name{i}).Ant.Misp_10.RMSD', R.(Angle_name{i}).Ant.Misp_15.RMSD', R.(Angle_name{i}).Ant.Misp_20.RMSD', R.(Angle_name{i}).Ant.Misp_30.RMSD');
            corr_Anterior.Properties.VariableNames = top;
            % figure(2);
            s = subplot(3,3,i);
            title(char(Angle_name{i}));
            for j=1:length(Parameter)
                s = scatter(norm_error{j,2:end},corr_Anterior{j,2:end});
                hold on
                if patient == 1
                    a5=area([0 100],[5 5], 'FaceColor', [0.9290, 0.6940, 0.1250], 'EdgeColor',[0.9290, 0.6940, 0.1250]);
                    a5.FaceAlpha = 0.15; a5.EdgeAlpha = 0.15;
                    a2=area([0 100],[2 2], 'FaceColor', 'g', 'EdgeColor', 'g');
                    a2.FaceAlpha = 0.15; a2.EdgeAlpha = 0.15;
                    a30=area([0 100],[30 30], 'FaceColor', 'r', 'EdgeColor', 'r');
                    a30.FaceAlpha = 0.15; a30.EdgeAlpha = 0.15;
                end
            end
            xlim([0 x_lim])
            ylim([0 y_lim])
            ylabel('RMSD (°)');
            xlabel(['misplacement in percentage of ' Anthro_param]);           
            title(char(Angle_name{i}));

            matA=norm_error{:,2:end};
            norm_errors=matA(:)';
            matB=corr_Anterior{:,2:end};
            RMSD_errors = matB(:)';
            [correl, p] = corrcoef(norm_errors,RMSD_errors);
            Correl.(direction{d}).(Angle_name{i}).R = correl;
            Correl.(direction{d}).(Angle_name{i}).p = p;
            
            x  = norm_errors;
            y  = RMSD_errors;
            b1 = x/y;
            P = polyfit(x,y,1);
            Correl.(direction{d}).(Angle_name{i}).slope = P(1);
            Correl.(direction{d}).(Angle_name{i}).intercept = P(2);
            yfit = P(1)*x + P(2);
            f = polyval(P,x);
            plot(x,f,'-')
        end   
        C.HF(col)=Correl.(direction{d}).LHip_flex.R(1,2);  C.HF(col+1)=Correl.(direction{d}).LHip_flex.slope;   C.HF(col+2)=Correl.(direction{d}).LHip_flex.intercept;  
        C.HA(col)=Correl.(direction{d}).LHip_add.R(1,2);   C.HA(col+1)=Correl.(direction{d}).LHip_add.slope;    C.HA(col+2)=Correl.(direction{d}).LHip_add.intercept;
        C.HR(col)=Correl.(direction{d}).LHip_rot.R(1,2);   C.HR(col+1)=Correl.(direction{d}).LHip_rot.slope;    C.HR(col+2)=Correl.(direction{d}).LHip_rot.intercept;
        C.KF(col)=Correl.(direction{d}).LKnee_flex.R(1,2); C.KF(col+1)=Correl.(direction{d}).LKnee_flex.slope;  C.KF(col+2)=Correl.(direction{d}).LKnee_flex.intercept;  
        C.KA(col)=Correl.(direction{d}).LKnee_add.R(1,2);  C.KA(col+1)=Correl.(direction{d}).LKnee_add.slope;   C.KA(col+2)=Correl.(direction{d}).LKnee_add.intercept;
        C.KR(col)=Correl.(direction{d}).LKnee_rot.R(1,2);  C.KR(col+1)=Correl.(direction{d}).LKnee_rot.slope;   C.KR(col+2)=Correl.(direction{d}).LKnee_rot.intercept;
        C.AF(col)=Correl.(direction{d}).LAnkle_flex.R(1,2);C.AF(col+1)=Correl.(direction{d}).LAnkle_flex.slope; C.AF(col+2)=Correl.(direction{d}).LAnkle_flex.intercept;  
        C.AA(col)=Correl.(direction{d}).LAnkle_add.R(1,2); C.AA(col+1)=Correl.(direction{d}).LAnkle_add.slope;  C.AA(col+2)=Correl.(direction{d}).LAnkle_add.intercept;
        C.AR(col)=Correl.(direction{d}).LAnkle_rot.R(1,2); C.AR(col+1)=Correl.(direction{d}).LAnkle_rot.slope;  C.AR(col+2)=Correl.(direction{d}).LAnkle_rot.intercept;
        col = col+3;
    end
    Var_Names = {string('R'), string('m'), string('b')}; Var_Names = repmat(Var_Names,1,4);
    Table2_mat= [C.HF; C.HA; C.HR; C.KF; C.KA; C.KR; C.AF; C.AA; C.AR];
    Table2 = table(Table2_mat);
    Table2.Properties.VariableDescriptions;
end