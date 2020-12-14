function MISP_Clean_c3d(C3D_filenames, C3D_path)


markers_to_keep = {'LANK','LASI','LHEE','LKNE','LPSI','LTHI','LTIB','LTOE','RASI','RPSI', 'RANK', 'RHEE', 'RKNE', 'RTHI', 'RTIB', 'RTOE'};
md_fields_to_del= {'ANALOG', 'CYCLES', 'PROCESSING', 'SEG'};
metadata_to_del = {'ID_FM_Patient', 'ID_FM_Visite', 'NAMES','A_InterAsisDistance_mm', 'A_Right_FootLength_mm', 'A_Left_FootLength_mm', 'A_Right_ThighPerimeter_mm', 'A_Left_ThighPerimeter_mm',...
    'A_Right_CalfPerimeter_mm', 'A_Left_CalfPerimeter_mm', 'A_Right_FemurLength_mm', 'A_Left_FemurLength_mm', 'A_Right_TibiaLength_mm', 'A_Left_TibiaLength_mm'};

for i = 1:length(C3D_filenames)
%    C3D = Get_C3D_BTK(C3D_path,C3D_filenames{i}, 0);
   C3D = Get_C3D_BTK_Anonyme(C3D_path,C3D_filenames{i}, 0);
    acq  = btkReadAcquisition(C3D_filenames{i});   
    %% 2. Delete parameters
    % Delete MARKERS, KINEMATIC and KINETIC data of interest
    data_fields = fieldnames(C3D.data);
    file_name = C3D_filenames{i};
    for j = 1:length(data_fields)
        if isfield(C3D.data, data_fields{j}) == 1
            if ~any(strcmp(markers_to_keep, data_fields{j})) == 1 
                btkRemovePoint(acq, data_fields{j})
            end
        end
    end
    
    % Delete from Metadata
    for j = 1:length(md_fields_to_del)
        if isfield(C3D.MetaData.children, md_fields_to_del{j}) == 1
            btkRemoveMetaData(acq,md_fields_to_del{j})
        end
    end
     
    % Delete from Metadata.Subjects
%     for j = 1:length(metadata_to_del)
%         if isfield(C3D.MetaData.children.SUBJECTS.children, metadata_to_del{j}) == 1
%             btkRemoveMetaData(acq,'SUBJECTS', metadata_to_del{j})
%         end
%     end
%     
    % Delete Analog
    btkClearAnalogs(acq)
    
    % Translate affected side
    side = char(C3D.MetaData.children.SUBJECTS.children.AFFECTED_SIDE.info.values);
    if  isempty(strfind(side, 'Droit'))== 0
        if isempty(strfind(side, 'Gauche')) == 0
            btkSetMetaDataValue(acq, 'SUBJECTS','AFFECTED_SIDE',1, 'RightLeft')
        else
            btkSetMetaDataValue(acq, 'SUBJECTS','AFFECTED_SIDE',1, 'Right')
        end
    elseif isempty(strfind(side, 'Gauche')) == 0
        btkSetMetaDataValue(acq, 'SUBJECTS','AFFECTED_SIDE',1, 'Left')
    else
        disp('Affected side not well described')
    end

    % Translate Diagnostic
    diagnostic = char(C3D.MetaData.children.SUBJECTS.children.DIAGNOSTIC.info.values);
    if isempty(strfind(diagnostic, 'Hémiparésie congénitale')) == 0
        btkSetMetaDataValue(acq, 'SUBJECTS','DIAGNOSTIC',1, 'Cerebral Palsy - Spastic - Unilateral')
    elseif isempty(strfind(diagnostic, 'Hémiplégie Infantile')) == 0
        btkSetMetaDataValue(acq, 'SUBJECTS','DIAGNOSTIC',1, 'Cerebral Palsy - Spastic - Unilateral')
    elseif isempty(strfind(diagnostic, 'Diplegie Spastique')) == 0
        btkSetMetaDataValue(acq, 'SUBJECTS','DIAGNOSTIC',1, 'Cerebral Palsy - Spastic - Bilateral')
    else
        disp('Diagnostic not recognized')
    end    
    
    btkSetFirstFrame(acq,1,1)
    
    % Name the file
%     filecode = strcat('001_00',file_name(1:2),'_001_',file_name(end-16:end-12),'.c3d');
    %% 3. Write new C3D
    btkWriteAcquisition(acq,strcat(C3D_path,file_name));
    clear acq;
    
end
end