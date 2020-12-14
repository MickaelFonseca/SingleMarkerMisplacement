function RunPyCGM2_ff(C3D_filenames, C3D_path)
%18/02/2019
% Input

Static=struct();
Dynamic=struct();
Anthropo_fields_ToWrite={'Bodymass';'Height';'LeftLegLength';'RightLegLength';'LeftKneeWidth';'RightKneeWidth';'LeftAnkleWidth';'RightAnkleWidth'};
Anthropo_fields_C3D={'Bodymass';'Height';'LLegLength';'RLegLength';'LKneeWidth';'RKneeWidth';'LAnkleWidth';'RAnkleWidth'};
Anthropo_fields_C3DAnonyme={'A_BodyMass_kg';'A_Height_mm';'A_Left_LegLength_mm';'A_Right_LegLength_mm';'A_Left_KneeWidth_mm';'A_Right_KneeWidth_mm';'A_Left_AnkleWidth_mm';'A_Right_AnkleWidth_mm'};
Anthropo_fields_C3DRange={150;900;400;400;50;50;10;10};
b=0;

%%
File.MP.Required = [];
File.MP.Optional.InterAsisDistance  = 0;
File.MP.Optional.LeftAsisTrocanterDistance   = 0;
File.MP.Optional.LeftTibialTorsion  = 0;
File.MP.Optional.LeftThighRotation  = 0;
File.MP.Optional.LeftShankRotation  = 0;
File.MP.Optional.RightAsisTrocanterDistance  = 0;
File.MP.Optional.RightTibialTorsion  = 0;
File.MP.Optional.RightThighRotation  = 0;
File.MP.Optional.RightShankRotation  = 0;
File.MP.Optional.LeftKneeFuncCalibrationOffset   = 0;
File.MP.Optional.RightKneeFuncCalibrationOffset  = 0;
File.Global.Marker__diameter = '12.5';
File.Global.Point__suffix    = 'PyCGM1';
File.Calibration.Left__flat__foot  = 'True';
File.Calibration.Right__flat__foot = 'True';

%%
counter=0;
b=0;
tic
for i=1:size(C3D_filenames,2)
    C3D_file=char(C3D_filenames{i});
    
    % get the static file
    if isempty(strfind(C3D_file,'SB'))==0
        File.Calibration.StaticTrial   = C3D_file;
        b=b+1;
        A=struct();
        Field=('');
        A=Get_BTK_PyCGM(C3D_path, char(C3D_file));
%        A=Get_C3D_BTK_Anonyme(C3D_path, char(C3D_file),1);
        Field=fieldnames(A);
        for f=1:length(Field)
            Static =setfield(Static,{b,1},char(Field(f)),A.(char(Field(f))));
        end
    end
    % get the dynamic files
    if isempty(strfind(C3D_file,'GB'))==0
        counter = counter + 1;
        A=Get_C3D_BTK_Anonyme(C3D_path, char(C3D_file),0);
        Field=fieldnames(A);
        for f=1:length(Field)
            Dynamic =setfield(Dynamic,{counter,1},char(Field(f)),A.(char(Field(f))));
        end
        File.Fitting.Trials(counter).File = C3D_file;
        File.Fitting.Trials(counter).Mfpa = 'XX';
        %             Foot =  Check_Foot_FP(C3D_path, C3D_filenames{i});                % Check if feet are correctly over the platforms
        %             File.Fitting.Trials(counter).Mfpa = Foot;
    end
end
if b==2
    error('more than one static c3d file is present');
end
if counter==0
    error('no dynamic file found');
end
%IF QUALYSis ELse VICON
for i=1:length(Anthropo_fields_ToWrite)
    if isfield(Static.MetaData.children.SUBJECTS.children,Anthropo_fields_C3DAnonyme{i})==1
        if str2double(Static.MetaData.children.SUBJECTS.children.(Anthropo_fields_C3DAnonyme{i}).info.values)<Anthropo_fields_C3DRange{i} && i>1
            File.MP.Required.(Anthropo_fields_ToWrite{i})=cell2mat(Static.MetaData.children.SUBJECTS.children.(Anthropo_fields_C3DAnonyme{i}).info.values)*10;
        else
            File.MP.Required.(Anthropo_fields_ToWrite{i})=cell2mat(Static.MetaData.children.SUBJECTS.children.(Anthropo_fields_C3DAnonyme{i}).info.values);
        end
    else
        error('no anthropometric parameters in the static c3d file');
    end
end

File.MP.Required.LeftSoleDelta = 0;
File.MP.Required.RightSoleDelta = 0;
File.MP.Required.LeftShoulderOffset = 0;
File.MP.Required.LeftElbowWidth = 0;
File.MP.Required.LeftWristWidth = 0;
File.MP.Required.LeftHandThickness = 0;
File.MP.Required.RightShoulderOffset = 0;
File.MP.Required.RightElbowWidth = 0;
File.MP.Required.RightWristWidth = 0;
File.MP.Required.RightHandThickness = 0;

%% WRITE YAML FILE
file_name = [C3D_path, 'CGM1_1.userSettings'];
fid = fopen(file_name,'w+');
disp(['The file ''',file_name,''' file was created.']);
yaml_space='    ';
f = fieldnames(File);

fprintf(fid, [f{1}, ':', '\n']);
ff = fieldnames(File.MP);
for k = 1 : size(ff,1)
    fprintf(fid, [yaml_space, ff{k}, ':', '\n']);
    fff = fieldnames(File.(f{1}).(ff{k}));
    for m = 1 : size(fff,1)
        fprintf(fid, [yaml_space, yaml_space, fff{m}, ':', ' ', num2str(File.(f{1}).(ff{k}).(fff{m})), '\n']);
    end
end
fprintf(fid, '\n');
for j = 2:3
    fprintf(fid, [f{j}, ':', '\n']);
    ff = fieldnames(File.(f{j}));
    for k = 1 : size(ff,1)
        newStr = strrep(ff{k},'__',' ');
        fprintf(fid, [yaml_space, newStr, ':', ' ', File.(f{j}).(ff{k}), '\n']);
    end
    fprintf(fid, '\n');
end
fprintf(fid, ['Fitting:', '\n']);
fprintf(fid, [yaml_space, 'Trials:', '\n']);
ff = fieldnames(File.Fitting.Trials);
for j = 1 : counter
    fprintf(fid, [yaml_space, yaml_space, '- ', ff{1}, ': ', File.Fitting.Trials(j).(ff{1}), '\n']);
    fprintf(fid, [yaml_space, yaml_space, '  ', ff{2}, ': ', File.Fitting.Trials(j).(ff{2}), '\n']);
end
fclose(fid);
% Replace in translators, MARK1 = None for MARK1 = (virtual marker (m))
trans = {'LASI','RASI','LPSI','RPSI','RTHI','RKNE','RKNM','RTIB','RANK','RMED','RHEE','RTOE','LTHI','LKNE','LKNM','LTIB','LANK','LMED','LHEE','LTOE','C7',...
    'T10','CLAV','STRN','LFHD','LBHD','RFHD','RBHD','LSHO','LELB','LWRB','LWRA','LFIN','RSHO','RELB','RWRB','RWRA','RFIN'};
for t = 1:length(trans)
    File_T.Translators.(trans{t})='None';
end
file_name = [C3D_path, 'CGM1_1.translators'];
fid = fopen(file_name,'w+');
f = fieldnames(File_T);
fprintf(fid, [f{1},':','\n']);
ff= fieldnames(File_T.Translators);
for k=1:size(ff,1)
    fprintf(fid,['    ',ff{k},': ',char(File_T.Translators.(ff{k})),'\n']);
end
fclose(fid);

%%

commandStr1 = ['cd /d ' C3D_path];
commandStr2 = ['python.exe ' 'pyCGM2_CGM11_modelling.py'];
[status, commandOut] = system([commandStr1 ' & ' commandStr2],'-echo');
delete('CGM1.1 [0].completeSettings')
toc
disp('End of computation');

    function C3D=Get_BTK_PyCGM(C3D_path,C3D_filename)
        warning off;
        file = [C3D_path C3D_filename];
        C3D.filename = C3D_filename;
        C3D.pathname = C3D_path;
        acq=btkReadAcquisition(strcat(C3D_path,C3D_filename));%'\',
        md = btkFindMetaData(acq, 'MANUFACTURER', 'COMPANY');
        if isstruct(md)==1
            MANUFACTURER=char(md.info.values);
            C3D.Manufacturer=MANUFACTURER;
        else
            MANUFACTURER='Vicon';
        end
        C3D.acq=acq;
        
        % GET Anthro parameters
        temp=btkGetMetaData(acq);
        C3D.MetaData=temp;
        a=struct();
        if isfield(temp.children,'PROCESSING')==1
            a=fieldnames(temp.children.PROCESSING.children);
            for i=1:length(a)
                C3D.SubjectParam.(a{i})=temp.children.PROCESSING.children.(a{i}).info.values;
            end
            if isfield(C3D.SubjectParam,'BodyMass')==1
                Process=1;
            end
            
        end
        Subject=0;
        if isfield(temp.children,'SUBJECTS')==1
            Subject=1;
%             C3D.SubjectParam.name=temp.children.SUBJECTS.children.NAMES.info.values;
            C3D.SubjectParam.name=temp.children.SUBJECT_PARAM.info.values;
%             C3D.SubjectParam.marker_set=temp.children.SUBJECTS.children.MARKER_SETS.info.values;
        end
        
        if strcmp(MANUFACTURER,'Qualisys')
            if isfield(temp.children,'ANALYSIS')==1
                if isfield(temp.children.ANALYSIS.children,'VALUES')==1
                    VAL=temp.children.ANALYSIS.children.VALUES.info.values;
                    Names=temp.children.ANALYSIS.children.NAMES.info.values;
                    for i=1:length(VAL)
                        C3D.SubjectParam.(Names{i})=VAL(i);
                    end
                end
            end
        end
        C3D.StartFrame = btkGetFirstFrame(acq);
        C3D.fRate.Point = btkGetPointFrequency(acq);
        C3D.fRate.Analog = btkGetAnalogFrequency(acq);
        EventFrame=struct();
        E=btkGetEvents(acq);
        if isempty(E)==0
            a=fieldnames(E);
            if isempty(a)==0
                for i=1:length(a)
                    Event.(char(a{i}))=sort(E.(char(a{i})));
                    EventFrame.(char(a{i}))=round(Event.(char(a{i}))*C3D.fRate.Point+1-single(C3D.StartFrame)+1);%+1 pour la convertion temporelle  et +1 pour la différence entre frame
                    for j=1:length( EventFrame.(char(a{i})))
                        if    EventFrame.(char(a{i}))(j)<1
                            EventFrame.(char(a{i}))(j)=1;
                        end
                    end
                end
                C3D.Event=Event;
                C3D.EventFrame=EventFrame;
            end
        end
    end
end
