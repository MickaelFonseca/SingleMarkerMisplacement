%% Wilcoxon test between two tables.

%% 1. Import tables of both populations 
% CP 
cd 'D:\GITLAB\MARK_MISP\MARK_MISP_DATA\MARK_MISP_LKNE'
Table_CP = readtable('Table_RMSD_10mm_AP_ML_All_Population_CP.xlsx', 'ReadRowNames', false);

% TDC
cd 'D:\GITLAB\MARK_MISP\MARK_MISP_DATA\MARK_MISP_LKNE_TDC'
Table_TDC = readtable('Table_RMSD_10mm_AP_ML_All_Population_TDC.xlsx', 'ReadRowNames', false);

%% 2. Wilcoxon test
Rows = {'HF_AP', 'HF_PD', 'HA_AP', 'HA_PD', 'HR_AP', 'HR_PD','KF_AP', 'KF_PD', 'KA_AP', 'KA_PD', 'KR_AP', 'KR_PD', 'AF_AP', 'AF_PD', 'AA_AP', 'AA_PD', 'AR_AP', 'AR_PD', 'FP_AP', 'FP_PD'};

for i = 1: length(Rows)
    row_CP = table2array(Table_CP(i,2:end));
    row_TDC = table2array(Table_TDC(i,2:end));
    [p(i), h(i)] = signrank(row_CP, row_TDC)
end

