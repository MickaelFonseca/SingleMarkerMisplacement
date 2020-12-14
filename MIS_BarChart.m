function MIS_BarChart(T_m_RMSD, Angle_names, Joint_Angles, dir, direction, Er)

ang = [];
counter = 1;
z = zeros(12,1);
for i = 1:length(direction)
    for mag = 1:length(Er)
        ang = [ang, T_m_RMSD.(char(strcat('Misp_', string(Er(mag)), '_LASI_', dir, '_RASI_', direction{i})))];
        ang_nam{counter} = char(strcat('Misp_', string(Er(mag)), '_LASI_', dir, '_RASI_', direction{i}));
        counter = counter +1;
    end
    ang = [ang, z];
end

for i = 1:size(ang,1)
    subplot(4,3,i)
    title((Joint_Angles{i}))
    xlabel({'RASI Med     RASI Prox      RASI Lat      RASI Dist '})
    ylabel({'RMSD °'})
    ylim([0, 20])
    hold on
%     for j = 1:size(ang,2)
%     y = 0:1:25;
%     x = max(ang(i,:));
%     plot(x, y)

    for j = 1:4
        init = (j-1)*5;
        final= 5*j;
        b = bar(j+init:j+final, ang(i,j+init:j+final))
        if j ==1% j<7
            set(b, 'FaceColor', 'b')
        elseif j == 2%j<13
            set(b, 'FaceColor', 'r')
        elseif j == 3 %j<19
            set(b, 'FaceColor', 'g')            
        elseif j == 4 %j<25
            set(b, 'FaceColor', 'k')
        end
    end
    set(gca, 'xticklabel', {''})
    xlim =get(gca,'xlim')
    plot([0 25],[5 5], 'r')
    plot([0 25], [2 2], 'g')
end
hold off






end