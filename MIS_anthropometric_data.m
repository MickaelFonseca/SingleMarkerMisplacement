function anthro = MIS_anthropometric_data(filenames, C3D_path)
c=0;
    for i=1:length(filenames)
        if isempty(strfind(filenames{i},'SB'))==0
            c = c+1;
            acq  = btkReadAcquisition(strcat(C3D_path, char(filenames(i))));
            meta = btkGetMetaData(acq);
            a=struct();
            markers = btkGetMarkers(acq);
            pelvic_width = markers.LASI-markers.RASI;
            if isfield(meta.children,'SUBJECTS')==1
                a=fieldnames(meta.children.SUBJECTS.children);
                anthro.subject(c).Filenames    = filenames{i};
                anthro.subject(c).Age          = meta.children.SUBJECTS.children.AGE.info.values;
                anthro.subject(c).Height_mm    = meta.children.SUBJECTS.children.A_Height_mm.info.values;
                anthro.subject(c).BodyMass_kg  = meta.children.SUBJECTS.children.A_BodyMass_kg.info.values;
                anthro.subject(c).Left_LegLength_mm  = meta.children.SUBJECTS.children.A_Left_LegLength_mm.info.values;
                anthro.subject(c).Left_KneeWidth_mm  = meta.children.SUBJECTS.children.A_Left_KneeWidth_mm.info.values;
                anthro.subject(c).Left_AnkleWidth_mm = meta.children.SUBJECTS.children.A_Left_AnkleWidth_mm.info.values;
                anthro.subject(c).Right_LegLength_mm  = meta.children.SUBJECTS.children.A_Right_LegLength_mm.info.values;
                anthro.subject(c).Right_KneeWidth_mm  = meta.children.SUBJECTS.children.A_Right_KneeWidth_mm.info.values;
                anthro.subject(c).Right_AnkleWidth_mm = meta.children.SUBJECTS.children.A_Right_AnkleWidth_mm.info.values;
                anthro.subject(c).Pelvic_Width_mm = meta.children.SUBJECTS.children.A_InterAsisDistance_mm.info.values;
            end
        end

    end  
end