function radarplot(R,Lable,LineColor,LineStyle, LevelNum, maximo)
%Creates a radar (spider) plot for multi-data series.
%edit by Cheng Li
%Tsinghua University

%INPUT: 
%R
%   Data, if R is a m*n matrix, means m samples with n options
 
% Label
%   Label, Label of options
% 	Cells of string
% Lable = {'0', '45', '90', '135', '180', '225', '270', '315'};
% Lable = {'0', '315', '270', '225', '180', '135', '90', '45'};

% LineColor
% 	Color of Line
% 	Cells of MatLab colors
%FillColor
%	Cells of MatLab colors
% %
% LineStyle
% 	Cells of MatLab colors
% %
% %LevelNum
% %	number of axis's levels
% %Example:
%radarplot([1 2 3 4 5 6])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5])
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','','c','d'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{},{'b','r'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'})
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','','','','',''},{'r','g'},{'b','r'},{'no',':'}
%radarplot([1 2 3 4 5 6;7 8 9 10 11 12.5],{'option1','a','b','c','','e'},{'r','g'},{'b','r'},{'no',':'},5)
% R =  [1.0, 0.9, 0.02, 0.9, 1.0, 0.9, 0.02, 0.9; 2.1, 1.8, 0.07, 1.8, 2.1, 1.8, 0.06, 1.7; 3.2, 2.7, 0.16, 2.7, 3.1, 2.6, 0.14, 2.5; 4.2, 3.6, 0.28, 3.6,...
%      4.0, 3.4, 0.24, 3.3; 6.4, 5.4, 0.66, 5.5, 5.9, 5.0, 0.51, 4.8];
% Lable = {'Ant', 'Ant + Dist', 'Dist', 'Post + Dist', 'Post', 'Post + Prox', 'Prox', 'Ant + Prox'};
% LineColor = {'b', 'c', 'g', 'm', 'r'};
% LineStyle = {'-','-.', ':', '--','-'};
% LevelNum = 5;
n=size(R,2); % numero de colunas (error direction)
m=size(R,1); % numero de linhas (error magnitude)

% if nargin<6
%     LevelNum=4;
% end


R=[R R(:,1)]; % para fechar o circulo voltar ao valor inicial

[Theta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(R,1)));
Theta = Theta - 0.3927 + pi/2;
X=R.*sin(Theta);
Y=R.*cos(Theta);

A=plot(X',Y','LineWidth',1);


MAXAXIS=max(max(R))*1.1;
axis([-maximo maximo -maximo maximo]);
% axis([-MAXAXIS MAXAXIS -MAXAXIS MAXAXIS]);

axis equal
axis off


if LevelNum>0
%     AxisR=linspace(0,max(max(R)),LevelNum);
    AxisR = [2, 5, 8, 12, 16];
    for i=1:LevelNum
%         text(AxisR(i)*sin(pi/n-0.3),AxisR(i)*cos(pi/n-0.3),num2str(AxisR(i),2),'FontSize',8)
        text(AxisR(i)*sin(pi/1.69-0.3),AxisR(i)*cos(pi/1.69-0.3),num2str(AxisR(i),2),'FontSize',8)
        text(AxisR(i)*sin(pi/-2.5-0.3),AxisR(i)*cos(pi/-2.5-0.3),num2str(AxisR(i),2),'FontSize',8)
        text(AxisR(i)*sin(pi/12.2-0.3),AxisR(i)*cos(pi/12.2-0.3),num2str(AxisR(i),2),'FontSize',8)
        text(AxisR(i)*sin(pi/-1.12-0.3),AxisR(i)*cos(pi/-1.12-0.3),num2str(AxisR(i),2),'FontSize',8)
%         text(AxisR(i)*sin(pi/8-0.03),0,num2str(AxisR(i),2),'FontSize',8)
    end
    [M,AxisR]=meshgrid(ones(1,n),AxisR);
    AxisR=[AxisR AxisR(:,1)];
    [AxisTheta,M]=meshgrid(2*pi/n*[0:n]+pi/n,ones(1,size(AxisR,1)));
    AxisTheta = AxisTheta - 0.3927 + pi/2;
    AxisX=AxisR.*sin(AxisTheta);
    AxisY=AxisR.*cos(AxisTheta);
    hold on
    plot(AxisX,AxisY,':k')
    plot(AxisX',AxisY',':k')
%     plot(AxisX(2,:)', AxisY(2,:)','--r', 'LineWidth',1)
end


if nargin>1
    if length(Lable)>=n
        LableTheta=2*pi/n*[0:n-1]+pi/n;
        LableTheta = LableTheta - 0.3927 + pi/2;
%         LableR=MAXAXIS;
        LableR = 17;
        LableX=LableR.*sin(LableTheta);
        LableY=LableR.*cos(LableTheta);
        for i=1:n
            if ~sum(strcmpi({'' },Lable(i)))
                text(LableX(i), LableY(i),cell2mat(Lable(i)), 'FontSize',10,'HorizontalAlignment','center','Rotation',0)
            end
        end
    end
else
    return
end

if nargin>1
    if length(LineColor)>=m
        for i=1:m
            if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },LineColor(i)))
                set(A(i),'Color',cell2mat(LineColor(i)))
            end
        end
    end
else
    return
end
% if nargin>3
%     if length(FillColor)>=m
%         for i=1:m
%             if sum(strcmpi({'y' 'm' 'c' 'r' 'g' 'b' 'w' 'k' },FillColor(i)))
%                 hold on;
%                 F=fill(X(i,:),Y(i,:),cell2mat(FillColor(i)),'LineStyle','none');
%                 set(F,'FaceAlpha',0.3)
%             end
%         end
%     end
% else
%     return
% end
% legend('5 mm', '10 mm', '15 mm', '20 mm', '30 mm')
if nargin>3
    if length(LineStyle)>=m
        for i=1:m
            if sum(strcmpi({'-' '-' '-' '-' '-', '-'},LineStyle(i)))
                set(A(i),'LineStyle',cell2mat(LineStyle(i)))
            end
        end
    end
else
    return
end

