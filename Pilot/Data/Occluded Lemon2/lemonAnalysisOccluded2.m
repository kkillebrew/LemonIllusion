% rawdata(n,1) = % Ratios 1=.1 2=.3 3=.5 4=.7
% rawdata(n,2) = amount occluded (1=0% of distance between tangent and edge
%    of circle 2=33% 3=66% 4=100%)
% rawdata(n,3) = responded it was curved(1) or straight(2)

clear all
close all

lineColor{1}='r';
lineColor{2}='b';

% fileList = {'riley_test_orientation_040314_001.mat'};
fileList = {'BKN_lemonOccluded2_050914_001','test_lemonOccluded2_050814_001','002_lemonOccluded2_051214_001','003_lemonOccluded2_051214_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/Occluded Lemon2/';

graphLabel = {'No Occlucion', '33% Occluded', '66% Occluded', 'Fully Occluded'};

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    % Ratio = .1 (minimum left/right curvature)
    % ratio(p,4,2)= 100% occlusion, 1=curved
    % ratio(p,4,1)= 100% occlusion, 2=straight
    ratio1(p,4,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==4),3)==1);
    ratio1(p,4,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==4),3)==2);
    
    % ratio(p,3,2)= 66% occlusion, 1=curved
    % ratio(p,3,1)= 66% occlusion, 2=straight
    ratio1(p,3,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==3),3)==1);
    ratio1(p,3,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==3),3)==2);
    
    % ratio(p,2,2)= 33% occlusion, 1=curved
    % ratio(p,2,1)= 33% occlusion, 2=straight
    ratio1(p,2,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==2),3)==1);
    ratio1(p,2,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==2),3)==2);
    
    % ratio(p,1,1)= 0% occlusion, 1=curved
    % ratio(p,1,2)= 0% occlusion, 2=straight
    ratio1(p,1,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==1),3)==1);
    ratio1(p,1,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==1),3)==2);
    
    
    % Ratio = .3
    % ratio(p,4,2)= 100% occlusion, 1=curved
    % ratio(p,4,1)= 100% occlusion, 2=straight
    ratio2(p,4,1) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==4),3)==1);
    ratio2(p,4,2) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==4),3)==2);
    
    % ratio(p,3,2)= 66% occlusion, 1=curved
    % ratio(p,3,1)= 66% occlusion, 2=straight
    ratio2(p,3,1) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==3),3)==1);
    ratio2(p,3,2) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==3),3)==2);
    
    % ratio(p,2,2)= 33% occlusion, 1=curved
    % ratio(p,2,1)= 33% occlusion, 2=straight
    ratio2(p,2,1) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==2),3)==1);
    ratio2(p,2,2) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==2),3)==2);
    
    % ratio(p,1,1)= 0% occlusion, 1=curved
    % ratio(p,1,2)= 0% occlusion, 2=straight
    ratio2(p,1,1) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==1),3)==1);
    ratio2(p,1,2) = mean(rawdata(and(rawdata(:,1)==2,rawdata(:,2)==1),3)==2);
    
    
    % Ratio = .5
    % ratio(p,4,2)= 100% occlusion, 1=curved
    % ratio(p,4,1)= 100% occlusion, 2=straight
    ratio3(p,4,1) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==4),3)==1);
    ratio3(p,4,2) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==4),3)==2);
    
    % ratio(p,3,2)= 66% occlusion, 1=curved
    % ratio(p,3,1)= 66% occlusion, 2=straight
    ratio3(p,3,1) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==3),3)==1);
    ratio3(p,3,2) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==3),3)==2);
    
    % ratio(p,2,2)= 33% occlusion, 1=curved
    % ratio(p,2,1)= 33% occlusion, 2=straight
    ratio3(p,2,1) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==2),3)==1);
    ratio3(p,2,2) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==2),3)==2);
    
    % ratio(p,1,1)= 0% occlusion, 1=curved
    % ratio(p,1,2)= 0% occlusion, 2=straight
    ratio3(p,1,1) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==1),3)==1);
    ratio3(p,1,2) = mean(rawdata(and(rawdata(:,1)==3,rawdata(:,2)==1),3)==2);
    
    
    % Ratio = .7
    % ratio(p,4,2)= 100% occlusion, 1=curved
    % ratio(p,4,1)= 100% occlusion, 2=straight
    ratio4(p,4,1) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==4),3)==1);
    ratio4(p,4,2) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==4),3)==2);
    
    % ratio(p,3,2)= 66% occlusion, 1=curved
    % ratio(p,3,1)= 66% occlusion, 2=straight
    ratio4(p,3,1) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==3),3)==1);
    ratio4(p,3,2) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==3),3)==2);
    
    % ratio(p,2,2)= 33% occlusion, 1=curved
    % ratio(p,2,1)= 33% occlusion, 2=straight
    ratio4(p,2,1) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==2),3)==1);
    ratio4(p,2,2) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==2),3)==2);
    
    % ratio(p,1,1)= 0% occlusion, 1=curved
    % ratio(p,1,2)= 0% occlusion, 2=straight
    ratio4(p,1,1) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==1),3)==1);
    ratio4(p,1,2) = mean(rawdata(and(rawdata(:,1)==4,rawdata(:,2)==1),3)==2);
    
    
    figure()
    bar([ratio1(p,1,1), ratio1(p,2,1), ratio1(p,3,1), ratio1(p,4,1); ratio2(p,1,1), ratio2(p,2,1), ratio2(p,3,1), ratio2(p,4,1); ...
        ratio3(p,1,1), ratio3(p,2,1), ratio3(p,3,1), ratio3(p,4,1); ratio4(p,1,1), ratio4(p,2,1), ratio4(p,3,1), ratio4(p,4,1)]);
    %     hold on
    %     set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved for each ratio at each occlusion level for participant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Ratio','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',{'Ratio .1', 'Ratio .3', 'Ratio .5', 'Ratio .7'});
    legend(graphLabel);
    
end

% Ratio .1
% 0 Occ Curved
ratio1Ave(1,1) = mean(ratio1(:,1,1));
ratio1Std(1,1) = std(ratio1(:,1,1))/sqrt(length(fileList));
% 0 Occ Straight
ratio1Ave(1,2) = mean(ratio1(:,1,2));
ratio1Std(1,2) = std(ratio1(:,1,2))/sqrt(length(fileList));
% 33 Occ Curved
ratio1Ave(2,1) = mean(ratio1(:,2,1));
ratio1Std(2,1) = std(ratio1(:,2,1))/sqrt(length(fileList));
% 33 Occ Straight
ratio1Ave(2,2) = mean(ratio1(:,2,2));
ratio1Std(2,2) = std(ratio1(:,2,2))/sqrt(length(fileList));
% 66 Occ Curved
ratio1Ave(3,1) = mean(ratio1(:,3,1));
ratio1Std(3,1) = std(ratio1(:,3,1))/sqrt(length(fileList));
% 66 Occ Straight
ratio1Ave(3,2) = mean(ratio1(:,3,2));
ratio1Std(3,2) = std(ratio1(:,3,2))/sqrt(length(fileList));
% 100 Occ Curved
ratio1Ave(4,1) = mean(ratio1(:,4,1));
ratio1Std(4,1) = std(ratio1(:,4,1))/sqrt(length(fileList));
% 100 Occ Straight
ratio1Ave(4,2) = mean(ratio1(:,4,2));
ratio1Std(4,2) = std(ratio1(:,4,2))/sqrt(length(fileList));


% Ratio .3
% 0 Occ Curved
ratio2Ave(1,1) = mean(ratio2(:,1,1));
ratio2Std(1,1) = std(ratio2(:,1,1))/sqrt(length(fileList));
% 0 Occ Straight
ratio2Ave(1,2) = mean(ratio2(:,1,2));
ratio2Std(1,2) = mean(ratio2(:,1,2))/sqrt(length(fileList));
% 33 Occ Curved
ratio2Ave(2,1) = mean(ratio2(:,2,1));
ratio2Std(2,1) = mean(ratio2(:,2,1))/sqrt(length(fileList));
% 33 Occ Straight
ratio2Ave(2,2) = mean(ratio2(:,2,2));
ratioStd(2,2) = std(ratio2(:,2,2))/sqrt(length(fileList));
% 66 Occ Curved
ratio2Ave(3,1) = mean(ratio2(:,3,1));
ratio2Std(3,1) = std(ratio2(:,3,1))/sqrt(length(fileList));
% 66 Occ Straight
ratio2Ave(3,2) = mean(ratio2(:,3,2));
ratio2Std(3,2) = std(ratio2(:,3,2))/sqrt(length(fileList));
% 100 Occ Curved
ratio2Ave(4,1) = mean(ratio2(:,4,1));
ratio2Std(4,1) = std(ratio2(:,4,1))/sqrt(length(fileList));
% 100 Occ Straight
ratio2Ave(4,2) = mean(ratio2(:,4,2));
ratio2Std(4,2) = std(ratio2(:,4,2))/sqrt(length(fileList));


% Ratio .5
% 0 Occ Curved
ratio3Ave(1,1) = mean(ratio3(:,1,1));
ratio3Std(1,1) = std(ratio3(:,1,1))/sqrt(length(fileList));
% 0 Occ Straight
ratio3Ave(1,2) = mean(ratio3(:,1,2));
ratio3Std(1,2) = std(ratio3(:,1,2))/sqrt(length(fileList));
% 33 Occ Curved
ratio3Ave(2,1) = mean(ratio3(:,2,1));
ratio3Std(2,1) = std(ratio3(:,2,1))/sqrt(length(fileList));
% 33 Occ Straight
ratio3Ave(2,2) = mean(ratio3(:,2,2));
ratio3Std(2,2) = std(ratio3(:,2,2))/sqrt(length(fileList));
% 66 Occ Curved
ratio3Ave(3,1) = mean(ratio3(:,3,1));
ratio3Std(3,1) = std(ratio3(:,3,1))/sqrt(length(fileList));
% 66 Occ Straight
ratio3Ave(3,2) = mean(ratio3(:,3,2));
ratio3Std(3,2) = std(ratio3(:,3,2))/sqrt(length(fileList));
% 100 Occ Curved
ratio3Ave(4,1) = mean(ratio3(:,4,1));
ratio3Std(4,1) = std(ratio3(:,4,1))/sqrt(length(fileList));
% 100 Occ Straight
ratio3Ave(4,2) = mean(ratio3(:,4,2));
ratio3Std(4,2) = std(ratio3(:,4,2))/sqrt(length(fileList));


% Ratio .7
% 0 Occ Curved
ratio4Ave(1,1) = mean(ratio4(:,1,1));
ratio4Std(1,1) = std(ratio4(:,1,1))/sqrt(length(fileList));
% 0 Occ Straight
ratio4Ave(1,2) = mean(ratio4(:,1,2));
ratio4Std(1,2) = std(ratio4(:,1,2))/sqrt(length(fileList));
% 33 Occ Curved
ratio4Ave(2,1) = mean(ratio4(:,2,1));
ratio4Std(2,1) = std(ratio4(:,2,1))/sqrt(length(fileList));
% 33 Occ Straight
ratio4Ave(2,2) = mean(ratio4(:,2,2));
ratio4Std(2,2) = std(ratio4(:,2,2))/sqrt(length(fileList));
% 66 Occ Curved
ratio4Ave(3,1) = mean(ratio4(:,3,1));
ratio4Std(3,1) = std(ratio4(:,3,1))/sqrt(length(fileList));
% 66 Occ Straight
ratio4Ave(3,2) = mean(ratio4(:,3,2));
ratio4Std(3,2) = std(ratio4(:,3,2))/sqrt(length(fileList));
% 100 Occ Curved
ratio4Ave(4,1) = mean(ratio4(:,4,1));
ratio4Std(4,1) = std(ratio4(:,4,1))/sqrt(length(fileList));
% 100 Occ Straight
ratio4Ave(4,2) = mean(ratio4(:,4,2));
ratio4Std(4,2) = std(ratio4(:,4,2))/sqrt(length(fileList));


figure()
c=[ratio1Ave(1,1), ratio1Ave(2,1), ratio1Ave(3,1), ratio1Ave(4,1); ratio2Ave(1,1), ratio2Ave(2,1), ratio2Ave(3,1), ratio2Ave(4,1); ...
    ratio3Ave(1,1), ratio3Ave(2,1), ratio3Ave(3,1), ratio3Ave(4,1); ratio4Ave(1,1), ratio4Ave(2,1), ratio4Ave(3,1), ratio4Ave(4,1)];
b=[ratio1Std(1,1), ratio1Std(2,1), ratio1Std(3,1), ratio1Std(4,1); ratio2Std(1,1), ratio2Std(2,1), ratio2Std(3,1), ratio2Std(4,1); ...
    ratio3Std(1,1), ratio3Std(2,1), ratio3Std(3,1), ratio3Std(4,1); ratio4Std(1,1), ratio4Std(2,1), ratio4Std(3,1), ratio4Std(4,1)];
h = bar(c);

% Code from barweb.m to align the error bars with the bar groups
set(h,'BarWidth',1);    % The bars will now touch each other
set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
set(get(gca,'YLabel'),'String','U')
hold on;
numgroups = size(c, 1);
numbars = size(c, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
end

str = {'Percentage seen curved for each ratio at each occlusion level'}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Ratio','FontSize',15);
ylabel('Percentage (%)','FontSize',15);
set(gca,'XTickLabel',{'Ratio .1', 'Ratio .3', 'Ratio .5', 'Ratio .7'});
legend(graphLabel);





% figure()
% subplot(1,2,1)
% % Plotting the number accuracy
% c=[mean(ratio1(:,1,1)), mean(ratio1(:,1,2)); mean(ratio1(:,2,1)), mean(ratio1(:,2,2)); mean(ratio1(:,3,1)), mean(ratio1(:,3,2)); mean(ratio1(:,4,1)), mean(ratio1(:,4,2))];
% b=[std(ratio1(:,1,1))/sqrt(length(fileList)), std(ratio1(:,1,2))/sqrt(length(fileList)); std(ratio1(:,2,1))/sqrt(length(fileList)),...
%     std(ratio1(:,2,2))/sqrt(length(fileList)); std(ratio1(:,3,1))/sqrt(length(fileList)), std(ratio1(:,3,2))/sqrt(length(fileList));...
%     std(ratio1(:,4,1))/sqrt(length(fileList)), std(ratio1(:,4,2))/sqrt(length(fileList))];
% h=bar(c);
%
% % Code from barweb.m to align the error bars with the bar groups
% set(h,'BarWidth',1);    % The bars will now touch each other
% set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
% set(get(gca,'YLabel'),'String','U')
% hold on;
% numgroups = size(c, 1);
% numbars = size(c, 2);
% groupwidth = min(0.8, numbars/(numbars+1.5));
% for i = 1:numbars
%       % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%       x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%       errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
% end
% %%%%%%%%
% %     hold on
% %     set(gca,'ylim',[0,100]);
% %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
% str = {'','Average percentage seen curved and straight for top/bot accross occlusion levels',''}; % cell-array method
% title(str,'FontSize',15,'FontWeight','bold')
% xlabel('Occlusion Level','FontSize',15);
% ylabel('Percentage (%)','FontSize',15);
% set(gca,'XTickLabel',graphLabel);
% legend('Seen as curved', 'Seen as straight');
%
% subplot(1,2,2)
% % Plotting the number accuracy
% c=[mean(lr(:,1,1)), mean(lr(:,1,2)); mean(lr(:,2,1)), mean(lr(:,2,2)); mean(lr(:,3,1)), mean(lr(:,3,2)); mean(lr(:,4,1)), mean(lr(:,4,2))];
% b=[std(lr(:,1,1))/sqrt(length(fileList)), std(lr(:,1,2))/sqrt(length(fileList)); std(lr(:,2,1))/sqrt(length(fileList)),...
%     std(lr(:,2,2))/sqrt(length(fileList)); std(lr(:,3,1))/sqrt(length(fileList)), std(lr(:,3,2))/sqrt(length(fileList));...
%     std(lr(:,4,1))/sqrt(length(fileList)), std(lr(:,4,2))/sqrt(length(fileList))];
% h=bar(c);
%
% % Code from barweb.m to align the error bars with the bar groups
% set(h,'BarWidth',1);    % The bars will now touch each other
% set(gca,'XTicklabel','Modelo1|Modelo2|Modelo3')
% set(get(gca,'YLabel'),'String','U')
% hold on;
% numgroups = size(c, 1);
% numbars = size(c, 2);
% groupwidth = min(0.8, numbars/(numbars+1.5));
% for i = 1:numbars
%       % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%       x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%       errorbar(x, c(:,i), b(:,i), '.k', 'linewidth', 2);
% end
% %%%%%%%%
% %     hold on
% %     set(gca,'ylim',[0,100]);
% %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
% str = {'','Average percentage seen curved and straight for left/right accross occlusion levels',''}; % cell-array method
% title(str,'FontSize',15,'FontWeight','bold')
% xlabel('Occlusion Level','FontSize',15);
% ylabel('Percentage (%)','FontSize',15);
% set(gca,'XTickLabel',graphLabel);
% legend('Seen as curved', 'Seen as straight');






% rawdata(n,1) = % Ratios 1=.1 2=.3 3=.5 4=.7
% rawdata(n,2) = amount occluded (1=0% of distance between tangent and edge
%    of circle 2=33% 3=66% 4=100%)
% rawdata(n,3) = responded it was curved(1) or straight(2)



