function MM = MIS_PlotPolar(m_RMSD_pMagn, Error, Label, MARK)

PelTilt = vec2mat(m_RMSD_pMagn(:,1),length(Error));
PelTilt = [PelTilt(:,1) fliplr(PelTilt(:,2:8))];
PelObli = vec2mat(m_RMSD_pMagn(:,2),length(Error));
PelObli = [PelObli(:,1) fliplr(PelObli(:,2:8))];
PelRot  = vec2mat(m_RMSD_pMagn(:,3), length(Error));
PelRot  = [PelRot(:,1) fliplr(PelRot(:,2:8))];

HipFlex = vec2mat(m_RMSD_pMagn(:,4),length(Error));
HipFlex = [HipFlex(:,1) fliplr(HipFlex(:,2:8))];
HipAdd  = vec2mat(m_RMSD_pMagn(:,5),length(Error));
HipAdd = [HipAdd(:,1) fliplr(HipAdd(:,2:8))];
HipRot  = vec2mat(m_RMSD_pMagn(:,6),length(Error));
HipRot = [HipRot(:,1) fliplr(HipRot(:,2:8))];

KneeFlex = vec2mat(m_RMSD_pMagn(:,7),length(Error));
KneeFlex = [KneeFlex(:,1) fliplr(KneeFlex(:,2:8))];
KneeAdd  = vec2mat(m_RMSD_pMagn(:,8),length(Error));
KneeAdd = [KneeAdd(:,1) fliplr(KneeAdd(:,2:8))];
KneeRot  = vec2mat(m_RMSD_pMagn(:,9),length(Error));
KneeRot = [KneeRot(:,1) fliplr(KneeRot(:,2:8))];

AnkleFlex = vec2mat(m_RMSD_pMagn(:,10),length(Error));
AnkleFlex = [AnkleFlex(:,1) fliplr(AnkleFlex(:,2:8))];
AnkleAdd  = vec2mat(m_RMSD_pMagn(:,11),length(Error));
AnkleAdd = [AnkleAdd(:,1) fliplr(AnkleAdd(:,2:8))];
AnkleRot  = vec2mat(m_RMSD_pMagn(:,12),length(Error));
AnkleRot = [AnkleRot(:,1) fliplr(AnkleRot(:,2:8))];

% Lable = {'     Ant', 'Ant + Dist', 'Dist', 'Post + Dist', 'Post', 'Post + Prox', 'Prox', 'Ant + Prox'};
LineColor = {'b', 'c', 'g', 'm', 'r'};
LineStyle = {'no', ':'};
LevelNum = 5;
maximo = 16;
Font_size = 20;
% Plot
subplot(4,3,1)
MIS_Radar_Plot(PelTilt, Label, LineColor, LineStyle, LevelNum, maximo)
t = title('Pelvic Tilt')
t.FontSize = Font_size;
set(t, 'position', get(t,'position')-[0 -0.5 0])

subplot(4,3,2)
MIS_Radar_Plot(PelObli, Label, LineColor, LineStyle, LevelNum, maximo)
t = title('Pelvic Obliquity')
t.FontSize = Font_size;
set(t, 'position', get(t,'position')-[0 -0.5 0])

subplot(4,3,3)
MIS_Radar_Plot(PelRot, Label, LineColor, LineStyle, LevelNum, maximo)
t = title('Pelvic Rotation')
t.FontSize = Font_size;
set(t, 'position', get(t,'position')-[0 -0.5 0])

subplot(4,3,4)
MIS_Radar_Plot(HipFlex,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Hip Flexion-Extension')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,5)
MIS_Radar_Plot(HipAdd,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Hip Adduction-Abduction')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,6)
MIS_Radar_Plot(HipRot,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Hip Internal-External Rotation')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])
l=legend('5 mm', '10 mm', '15 mm', '20 mm', '30 mm');

subplot(4,3,7)
MIS_Radar_Plot(KneeFlex,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Knee Flexion-Extension')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,8)
MIS_Radar_Plot(KneeAdd,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Knee Adduction-Abduction')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,9)
MIS_Radar_Plot(KneeRot,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Knee Internal-External Rotation')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,10)
MIS_Radar_Plot(AnkleFlex,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Ankle Flexion-Extension')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,11)
MIS_Radar_Plot(AnkleAdd,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Ankle Adduction-Abduction')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

subplot(4,3,12)
MIS_Radar_Plot(AnkleRot,Label,LineColor,LineStyle,LevelNum, maximo)
t=title('Ankle Internal-External Rotation')
t.FontSize = Font_size
set(t,'position',get(t,'position')-[0 -0.5 0])

saveas(figure(1), char(strcat(MARK,'.pdf')))
end