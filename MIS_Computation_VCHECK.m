function [Angles, MM, counter, Error] = MIS_Computation_VCHECK(C3D_filenames, MARK1, SEGMENT, Er, Error_dir, angle, b, data_path)

% Function computes a systematic error following magnitude and direction on
% the MARK1 and computes kinematics (PyCGM) for each error.
 %% 1. Run PyGCM2 on renamed files
    cd 'D:\Marker Misplacement Simulation\Test\CHECK\'
    counter= 0;    
    dynamic_list = [];
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
                Error = [E, 0 , 0];
            
            if s == 1
                %% 3 Run PyCGM2  % To add the joint centers and direction components for each segment (no need to be runned if already done)
                RunPyCGM2_ff(patient_list, data_path);
                
                %% 4.Save origin PyCGM angles (because translators are not working, save the original markers to restore after each calculation)
                dynamic_file = patient_list{2};
                acq = btkReadAcquisition(strcat(data_path, dynamic_file));
                Mark_ori = btkGetMarkers(acq);
                MARK1_original_dynamic = Mark_ori.(char(MARK1));
                Angles(counter).original = btkGetAngles(acq);
                btkAppendPoint(acq,'marker','LKNE_Original',MARK1_original_dynamic);
                btkWriteAcquisition(acq, dynamic_file);
                
                acq = btkReadAcquisition(strcat(data_path, static_file));
                Mark_ori = btkGetMarkers(acq);
                MARK1_original_static = Mark_ori.(char(MARK1));
                Angles_static(counter).original = btkGetAngles(acq);
                btkWriteAcquisition(acq, static_file);
            end
            
            %% 5. Create marker with error
            for j=1:size(Error,1)
                %% 5.1 Get MARK1 in STATIC file
                acq=btkReadAcquisition(strcat(data_path, static_file));
                data_static=btkGetMarkers(acq);
                btkWriteAcquisition(acq, static_file);
                
                %% 5.2 calculate LCS and add error to MARK1 in STATIC
                MARK1_GCS     =  data_static.(char(MARK1));
                MARK1_LCS     =  zeros(size(data_static.(SEGMENT.origin),1),4);
                MARK1_Mis_LCS =  zeros(size(data_static.(SEGMENT.origin),1),3);
                MARKER_MIS    =  char(strcat(MARK1,'_', num2str(angle(j)),'_', num2str(E), '_', Error_dir));
                MM{s,j}         =  MARKER_MIS;
                data_static.(MARKER_MIS)  =  zeros(size(data_static.LHJC,1),4);
                marker.(MARKER_MIS) = [];
           
                % INPUT ERROR
                for m = 1:size(data_static.(SEGMENT.origin),1)
                    % Rotation matrix from GCS to LCS (3x3)
                    mat_left_fem(:,:,m) = Femur_Mat_Rot(data_static.(SEGMENT.origin)(m,:),data_static.(SEGMENT.proximal)(m,:),data_static.(SEGMENT.lateral)(m,:),data_static.(SEGMENT.anterior)(m,:) );
                    % Transformation matrix (4x4)
                    T = [mat_left_fem(:,1,m), mat_left_fem(:,2,m), mat_left_fem(:,3,m), (data_static.(SEGMENT.origin)(m,:))'; 0, 0, 0, 1];
                    Transf = Tinv_array3(T);
                    % Calculate marker coordinates in LCS
                    MARK1_LCS(m,:) = (Transf*[MARK1_GCS(m,:)'; 1])';
                    % Add an error on the marker in LCS
                    MARK1_Mis_LCS(m,:) = [MARK1_LCS(m,1)+Error(j,1), MARK1_LCS(m,2)+Error(j,2), MARK1_LCS(m,3)+Error(j,3)];
                    % Calculate marker coordinates in GCS
                    data_static.(MARKER_MIS)(m,:) = (inv(Transf)*[MARK1_Mis_LCS(m,:),1]')';
                end
                data_static.(MARKER_MIS)(:,4) = [];
                % DELETE ERROR
                MARK1_GCS     =  data_static.(MARKER_MIS);
                MARK1_LCS     =  zeros(size(data_static.(SEGMENT.origin),1),4);
                MARK1_Mis_LCS =  zeros(size(data_static.(SEGMENT.origin),1),3);
%                 MARKER_MIS    =  [MARK1,'_', num2str(angle(j)),'_', num2str(E), '_', Error_dir];
%                 MM{s,j}         =  MARKER_MIS;
                MARKER_CHECK = 'LKNE_CHECK';
                data_static.(MARKER_CHECK)  =  zeros(size(data_static.('LHJC'),1),4);
                marker.(MARKER_CHECK) = [];
                for m = 1:size(data_static.(SEGMENT.origin),1)
                    % Rotation matrix from GCS to LCS (3x3)
                    mat_left_fem(:,:,m) = Femur_Mat_Rot(data_static.(SEGMENT.origin)(m,:),data_static.(SEGMENT.proximal)(m,:),data_static.(SEGMENT.lateral)(m,:),data_static.(SEGMENT.anterior)(m,:) );
                    % Transformation matrix (4x4)
                    T = [mat_left_fem(:,1,m), mat_left_fem(:,2,m), mat_left_fem(:,3,m), (data_static.(SEGMENT.origin)(m,:))'; 0, 0, 0, 1];
                    Transf = Tinv_array3(T);
                    % Calculate marker coordinates in LCS
                    MARK1_LCS(m,:) = (Transf*[MARK1_GCS(m,:)'; 1])';
                    % Add an error on the marker in LCS
                    MARK1_Mis_LCS(m,:) = [MARK1_LCS(m,1)-Error(j,1), MARK1_LCS(m,2)-Error(j,2), MARK1_LCS(m,3)-Error(j,3)];
                    % Calculate marker coordinates in GCS
                    data_static.(MARKER_CHECK)(m,:) = (inv(Transf)*[MARK1_Mis_LCS(m,:),1]')';
                end
                data_static.(MARKER_CHECK)(:,4) = [];

                %% 5.3 read C3D in DYNAMIC
                dynamic_file = patient_list{2};
                acq  =  btkReadAcquisition(strcat(data_path, dynamic_file));
                data_dynamic  =  btkGetMarkers(acq);
                btkWriteAcquisition(acq, dynamic_file);
                
                %% 5.4 calculate LCS and add error to MARK1 in Dynamic
                MARK1_GCS     =  data_dynamic.(char(MARK1));
                MARK1_LCS     =  zeros(size(data_dynamic.(SEGMENT.origin),1),4);
                MARK1_Mis_LCS =  zeros(size(data_dynamic.(SEGMENT.origin),1),3);
                data_dynamic.(MARKER_MIS)  =  zeros(size(data_dynamic.(SEGMENT.origin),1),4);
                marker.(MARKER_MIS)  =  [];
                % INPUT ERROR
                for m = 1:size(data_dynamic.(SEGMENT.origin),1)
                    mat_left_fem(:,:,m)  =  Femur_Mat_Rot(data_dynamic.(SEGMENT.origin)(m,:),data_dynamic.(SEGMENT.proximal)(m,:),data_dynamic.(SEGMENT.lateral)(m,:),data_dynamic.(SEGMENT.anterior)(m,:) );
                    T = [mat_left_fem(:,1,m), mat_left_fem(:,2,m), mat_left_fem(:,3,m), (data_dynamic.(SEGMENT.origin)(m,:))'; 0, 0, 0, 1];
                    Transf = Tinv_array3(T);
                    MARK1_LCS(m,:)  =  (Transf*[MARK1_GCS(m,:)'; 1])';
                    MARK1_Mis_LCS(m,:) =  [MARK1_LCS(m,1)+Error(j,1), MARK1_LCS(m,2)+Error(j,2), MARK1_LCS(m,3)+Error(j,3)];
                    data_dynamic.(MARKER_MIS)(m,:)  =  (inv(Transf)*[MARK1_Mis_LCS(m,:),1]')';
                end
                data_dynamic.(MARKER_MIS)(:,4)=[];
                
                % DELETE ERROR
                MARK1_GCS     =  data_dynamic.(MARKER_MIS);
                MARK1_LCS     =  zeros(size(data_dynamic.(SEGMENT.origin),1),4);
                MARK1_Mis_LCS =  zeros(size(data_dynamic.(SEGMENT.origin),1),3);
                data_dynamic.(MARKER_CHECK)  =  zeros(size(data_dynamic.(SEGMENT.origin),1),4);
                marker.(MARKER_CHECK)  =  [];
                % INPUT ERROR
                for m = 1:size(data_dynamic.(SEGMENT.origin),1)
                    mat_left_fem(:,:,m)  =  Femur_Mat_Rot(data_dynamic.(SEGMENT.origin)(m,:),data_dynamic.(SEGMENT.proximal)(m,:),data_dynamic.(SEGMENT.lateral)(m,:),data_dynamic.(SEGMENT.anterior)(m,:) );
                    T = [mat_left_fem(:,1,m), mat_left_fem(:,2,m), mat_left_fem(:,3,m), (data_dynamic.(SEGMENT.origin)(m,:))'; 0, 0, 0, 1];
                    Transf = Tinv_array3(T);
                    MARK1_LCS(m,:)  =  (Transf*[MARK1_GCS(m,:)'; 1])';
                    MARK1_Mis_LCS(m,:) =  [MARK1_LCS(m,1)-Error(j,1), MARK1_LCS(m,2)-Error(j,2), MARK1_LCS(m,3)-Error(j,3)];
                    data_dynamic.(MARKER_CHECK)(m,:)  =  (inv(Transf)*[MARK1_Mis_LCS(m,:),1]')';
                end
                data_dynamic.(MARKER_CHECK)(:,4)=[];
                %% 5.5 Delete joint centers and restore append virtual markers in the 2 files
                to_delete = {'LHJC', 'RHJC', 'LKJC', 'RKJC', 'LAJC','RAJC', 'LFEMUR_X', 'LFEMUR_Y', 'LFEMUR_Z', 'PELVIS_X','PELVIS_Y','PELVIS_Z', 'LTIBIA_X','LTIBIA_Y','LTIBIA_Z', 'SACR', 'midASIS' };
                C3D_s.acq=btkReadAcquisition(strcat(data_path,static_file));
                for d = 1:length(to_delete)
                    btkRemovePoint(C3D_s.acq,to_delete{d}); %Remove calculated virtual points, if they already exist PyCGM won't recalculate them
                end
                btkRemovePoint(C3D_s.acq, char(MARK1)); % Remove original point
                btkAppendPoint(C3D_s.acq, 'marker', char(MARK1),data_static.(MARKER_CHECK)); % Replace original point by the new misplaced point
                btkAppendPoint(C3D_s.acq,'marker','LKNE_CHECK',data_static.(MARKER_CHECK)); % Create a virtual marker with misplacement (optional)
                btkWriteAcquisition(C3D_s.acq, static_file);

                C3D_d.acq=btkReadAcquisition(strcat(data_path,dynamic_file));
                for d = 1:length(to_delete)
                    btkRemovePoint(C3D_d.acq,to_delete{d});
                end
                btkRemovePoint(C3D_d.acq, char(MARK1));
                btkAppendPoint(C3D_d.acq, 'marker', char(MARK1), data_dynamic.(MARKER_CHECK));
                btkAppendPoint(C3D_d.acq,'marker','LKNE_CHECK',data_dynamic.(MARKER_CHECK));
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
                change = (['    Point suffix: ',strcat(MARKER_MIS)]); % Change cell AA
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
                disp(['End of computation for marker:', strcat(MARKER_MIS)]);
                disp(['----------------------------------------------']);
                
                delete('CGM1.1 [0].completeSettings')
                
            end
        end    
    end
end       
