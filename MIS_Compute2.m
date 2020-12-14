function [Angles, MM1, MM2, counter, Error] = MIS_Compute2(C3D_filenames, MARK_to_MIS, SEGMENT, Er, Error_dir, angle, b, data_path)
% Function computes a systematic error following magnitude and direction on
% the MARK1 and computes kinematics (PyCGM) for each error.

% Outputs:
% Angles: Structure containing kinematic data for each of the computations
% MM: Cell with names of virtual markers creates (for each error)

 %% 1. Run PyGCM2 on renamed files
    cd(data_path)
    counter= 0;    
    dynamic_list = [];
    to_delete = {'LHJC', 'RHJC', 'LKJC', 'RKJC', 'LAJC','RAJC', 'LFEMUR_X',...
        'LFEMUR_Y', 'LFEMUR_Z', 'PELVIS_X','PELVIS_Y','PELVIS_Z', 'LTIBIA_X','LTIBIA_Y','LTIBIA_Z', 'SACR', 'midASIS' };

    
for i = 1: length(C3D_filenames)
    patient_list = {}; %list of filenames relative to the static file
    if isempty(strfind(C3D_filenames{i},'SB'))==0
        %% 1.1 Find respective dynamic file
        static_file = C3D_filenames{i};
        patient_list = {static_file};
        c = 1;
        for j = 1:length(C3D_filenames)
            if isempty(strfind(C3D_filenames{i},C3D_filenames{j})) && isempty(strfind('G',C3D_filenames{j}(end-16)))==0
                if isempty(strfind(static_file(1,end-25:end-18),C3D_filenames{j}(1,end-25:end-18)))==0 && ~isempty(strfind(static_file(1,end-16:end-15),C3D_filenames{j}(1,end-16:end-15)))==0
                        patient_list{end+1} = C3D_filenames{j};
                        dynamic_list = [dynamic_list; string(C3D_filenames{j})];
                end
            end
        end   
        counter = counter +1;
        for s = 1:length(Er)         
            %% 2. DEFINE Error
            E = Er(s);
            if Error_dir == 'AP_DP'
                Error = [E, 0, 0; 0, E, 0; -E, 0, 0; 0, -E, 0];
            elseif Error_dir == 'AP_ML'
                Error = [E, 0 , 0; 0, 0, E; -E, 0, 0; 0, 0, -E];
            elseif Error_dir == 'ML_DP'
                Error = [0, E, 0; 0, 0, E; 0, -E, 0; 0, 0, -E];
            else
                disp('The error direction is not valid.')
            end
            
            if s == 1
                %% 3 Run PyCGM2  % To add the joint centers and direction components for each segment (no need to be runned if already done)
                RunPyCGM2_ff(patient_list, data_path);
                
                %% 4.Save origin PyCGM angles
                dynamic_file = patient_list{2};
                acq = btkReadAcquisition(strcat(data_path, dynamic_file));
                Mark_ori_d = btkGetMarkers(acq);
                Angles(counter).original = btkGetAngles(acq);
                for mar = 1:length(MARK_to_MIS)
                   btkAppendPoint(acq, 'marker', strcat(MARK_to_MIS{mar}, '_Original'), Mark_ori_d.(MARK_to_MIS{mar})); 
                end
                btkWriteAcquisition(acq, dynamic_file);  
                
                acq = btkReadAcquisition(strcat(data_path, static_file));
                Mark_ori_s = btkGetMarkers(acq);
                Angles_static(counter).original = btkGetAngles(acq);
                for mar = 1:length(MARK_to_MIS)
                   btkAppendPoint(acq, 'marker', strcat(MARK_to_MIS{mar}, '_Original'), Mark_ori_s.(MARK_to_MIS{mar})); 
                end
                btkWriteAcquisition(acq, static_file);
            end
            
            %% 5. Create marker with error
            acq=btkReadAcquisition(strcat(data_path, static_file));
            Data_S=btkGetMarkers(acq);
            dynamic_file = patient_list{2};
            acq  =  btkReadAcquisition(strcat(data_path, dynamic_file));
            Data_d  =  btkGetMarkers(acq);
            
            for j=1:size(Error,1)
                % Marker misplacement on marker 1
                [data_static] = MISP_MARK2 (MARK_to_MIS{1}, Data_S, SEGMENT, angle, j, E, Error_dir, s, Error);
                [data_dynamic,  MARKER_MIS1] = MISP_MARK2 (MARK_to_MIS{1}, Data_d, SEGMENT, angle, j, E, Error_dir, s, Error);
                
                C3D_s.acq=btkReadAcquisition(strcat(data_path,static_file));
                C3D_d.acq=btkReadAcquisition(strcat(data_path,dynamic_file));
                btkRemovePoint(C3D_s.acq, char(MARK_to_MIS{1})); % Remove original point
                btkAppendPoint(C3D_s.acq, 'marker', char(MARK_to_MIS{1}),data_static.(MARKER_MIS1)); % Replace original point by the new misplaced point
%                 btkAppendPoint(C3D_s.acq,'marker',char(MARKER_MIS1),data_static.(MARKER_MIS1)); % Create a virtual marker with misplacement (optional)
                
                btkRemovePoint(C3D_d.acq, char(MARK_to_MIS{1})); % Remove original point
                btkAppendPoint(C3D_d.acq, 'marker', char(MARK_to_MIS{1}),data_dynamic.(MARKER_MIS1)); % Replace original point by the new misplaced point
%                 btkAppendPoint(C3D_d.acq,'marker',char(MARKER_MIS1),data_dynamic.(MARKER_MIS1)); % Create a virtual marker with misplacement (optional)
                btkWriteAcquisition(C3D_s.acq, static_file);
                btkWriteAcquisition(C3D_d.acq, dynamic_file);
                MM1{s,j} = MARKER_MIS1;
                for m2 = 1:4
                    % Marker misplacement on marker 2
                    [data_static] = MISP_MARK2_2 (MARK_to_MIS{2}, Data_S, SEGMENT, angle(m2), j, E, Error_dir, s, Error(m2,:));
                    [data_dynamic,  MARKER_MIS2] = MISP_MARK2_2 (MARK_to_MIS{2}, Data_d, SEGMENT, angle(m2), j, E, Error_dir, s, Error(m2,:));
                    
                    MM2{s, m2} = MARKER_MIS2;
                    C3D_s.acq=btkReadAcquisition(strcat(data_path,static_file));
                    C3D_d.acq=btkReadAcquisition(strcat(data_path,dynamic_file));
                    btkRemovePoint(C3D_s.acq, char(MARK_to_MIS{2})); % Remove original point
                    btkAppendPoint(C3D_s.acq, 'marker', char(MARK_to_MIS{2}),data_static.(MARKER_MIS2)); % Replace original point by the new misplaced point
                    %                     btkAppendPoint(C3D_s.acq,'marker',char(MARKER_MIS2),data_static.(MARKER_MIS2)); % Create a virtual marker with misplacement (optional)
                    
                    btkRemovePoint(C3D_d.acq, char(MARK_to_MIS{2})); % Remove original point
                    btkAppendPoint(C3D_d.acq, 'marker', char(MARK_to_MIS{2}),data_dynamic.(MARKER_MIS2)); % Replace original point by the new misplaced point
                    %                     btkAppendPoint(C3D_d.acq,'marker',char(MARKER_MIS2),data_dynamic.(MARKER_MIS2)); % Create a virtual marker with misplacement (optional)
                    for d = 1:length(to_delete)
                        btkRemovePoint(C3D_s.acq,to_delete{d}); %Remove calculated virtual points, if they already exist PyCGM won't recalculate them
                        btkRemovePoint(C3D_d.acq,to_delete{d});
                    end
                    
                    btkWriteAcquisition(C3D_s.acq, static_file);
                    btkWriteAcquisition(C3D_d.acq, dynamic_file);
                    
                    %% 7. Update suffix on CGM1_1.userSettings
                    fid = fopen('CGM1_1.userSettings','r');
                    bb = 1;
                    tline = fgetl(fid);
                    AA{bb} = tline;
                    while ischar(tline)
                        bb = bb+1;
                        tline = fgetl(fid);
                        AA{bb} = tline;
                    end
                    fclose(fid);
                    change = (['    Point suffix: ',strcat(MARKER_MIS1, '+', MARKER_MIS2)]); % Change cell AA
                    AA{36} = strjoin(cellstr(change));
                    
                    % Write cell AA into txt
                    fid = fopen('CGM1_1.userSettings', 'w');
                    for t = 1:numel(AA)
                        if AA{t+1} == -1
                            fprintf(fid,'%s', AA{t});
                            break
                        else
                            fprintf(fid,'%s\n', AA{t});
                        end
                    end
                    fclose(fid);
                    
                    %% 8. Run PyGCM2
                    commandStr1 = ['cd /d ' data_path];
                    commandStr2 = ['python.exe ' 'pyCGM2_CGM11_modelling.py'];
                    [status, commandOut] = system([commandStr1 ' & ' commandStr2],'-echo');
                    disp(['----------------------------------------------']);
                    disp(['End of computation for marker:', strcat(MARKER_MIS1, '+', MARKER_MIS2)]);
                    disp(['----------------------------------------------']);
                    
                    delete('CGM1.1 [0].completeSettings')
                    
                    %% 9. Restore MARK1 data (to avoid error)
                    acq_s = btkReadAcquisition(strcat(data_path,char(static_file)));
                    acq_d = btkReadAcquisition(strcat(data_path,char(dynamic_file)));
                    
                    btkRemovePoint(acq_s, MARK_to_MIS{2});
                    btkAppendPoint(acq_s, 'marker',char(MARK_to_MIS{2}),Mark_ori_s.(MARK_to_MIS{2}))
                    btkRemovePoint(acq_d, MARK_to_MIS{2});
                    btkAppendPoint(acq_d, 'marker',char(MARK_to_MIS{2}),Mark_ori_d.(MARK_to_MIS{2}))
                end
                
                btkWriteAcquisition(acq_s, static_file);
                btkWriteAcquisition(acq_d, dynamic_file);
            end
            acq_s = btkReadAcquisition(strcat(data_path,char(static_file)));
            acq_d = btkReadAcquisition(strcat(data_path,char(dynamic_file)));
            
            btkRemovePoint(acq_s, MARK_to_MIS{1});
            btkAppendPoint(acq_s, 'marker',char(MARK_to_MIS{1}),Mark_ori_s.(MARK_to_MIS{1}))
            btkRemovePoint(acq_d, MARK_to_MIS{1});
            btkAppendPoint(acq_d, 'marker',char(MARK_to_MIS{1}),Mark_ori_d.(MARK_to_MIS{1}))
            btkWriteAcquisition(acq_s, static_file);
            btkWriteAcquisition(acq_d, dynamic_file);
            
        end
        %% 10. Store kinematic data
        acq = btkReadAcquisition(strcat(data_path,char(dynamic_file)));
        Angles(counter).error = btkGetAngles(acq);
        btkWriteAcquisition(acq, dynamic_file);
        
        acq = btkReadAcquisition(strcat(data_path,char(static_file)));
        Angles_static(counter).error = btkGetAngles(acq);
        btkWriteAcquisition(acq, static_file);
            
    end
end