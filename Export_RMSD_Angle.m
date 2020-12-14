function Export_RMSD_Angle(Angle, group)
list_angles = {'Hip_flex_RMSD', 'Hip_add_RMSD', 'Hip_rot_RMSD', 'Knee_flex_RMSD', 'Knee_add_RMSD', 'Knee_rot_RMSD', 'Ankle_flex_RMSD', 'Ankle_add_RMSD', 'Ankle_flex_RMSD', 'Foot_prog_RMSD'};
Rows = {'HF_AP', 'HF_PD', 'HA_AP', 'HA_PD', 'HR_AP', 'HR_PD','KF_AP', 'KF_PD', 'KA_AP', 'KA_PD', 'KR_AP', 'KR_PD', 'AF_AP', 'AF_PD', 'AA_AP', 'AA_PD', 'AR_AP', 'AR_PD', 'FP_AP', 'FP_PD'};
count= 1;
for i = 1:length(list_angles)
    Table_RMSD(count,:) = mean(Angle.(list_angles{i})(2,:) + Angle.(list_angles{i})(22,:),1);
    Table_RMSD(count+1,:) = mean(Angle.(list_angles{i})(12,:) + Angle.(list_angles{i})(32,:),1);
    count= count +2;
end
% fname = strcat(angle_name,'.xlsx');
% csvwrite([fname])
Tabela = table(Table_RMSD)
Tabela.Properties.RowNames = Rows;
writetable(Tabela, strcat('Table_RMSD_10mm_AP_ML_All_Population_', group, '.xlsx'), 'Sheet',1, 'WriteRowNames', true)

end