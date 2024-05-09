% rawdata(n,1) = circleSize (1=21, 2=36, 3=60)
% rawdata(n,2) = circleDistance (1=60, 2=36, 3=21)
% rawdata(n,3) = 1-curved 2-straight

close all;
clear all;

fileList = {'BID_lemonDistance_061814_001','TC_lemonDistance_061914_001','001_lemonDistance_061914_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Data/';

graphLabel = {'Distance 1', 'Distance 2', 'Distance 3'};

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    distance1Size60(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==1 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==1,:));
    distance1Size36(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==1 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==2,:));
    distance1Size21(p) = length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==1 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==3,:));
    
    distance2Size60(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==2 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==1,:));
    distance2Size36(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==2 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==2,:));
    distance2Size21(p) = length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==2 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==3,:));
    
    distance3Size60(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==3 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==1,:));
    distance3Size36(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==3 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==2,:));
    distance3Size21(p) = length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==3 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==3,:));
   
    figure()
    % Plotting the number accuracy
    bar([distance1Size21(p)*100, distance1Size36(p)*100, distance1Size60(p)*100;...
        distance2Size21(p)*100, distance2Size36(p)*100, distance2Size60(p)*100;...
        distance3Size21(p)*100, distance3Size36(p)*100, distance3Size60(p)*100])
    %     hold on
    set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved and straight for particpant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Condition','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',graphLabel);
    legend('21%', '36%', '60%');
    
end

mean_distance1Size21 = mean(distance1Size21);
mean_distance1Size36 = mean(distance1Size36);
mean_distance1Size60 = mean(distance1Size60);
std_distance1Size21 = std(distance1Size21)/length(fileList);
std_distance1Size36 = std(distance1Size36)/length(fileList);
std_distance1Size60 = std(distance1Size60)/length(fileList);


mean_distance2Size21 = mean(distance2Size21);
mean_distance2Size36 = mean(distance2Size36);
mean_distance2Size60 = mean(distance2Size60);
std_distance2Size21 = std(distance2Size21)/length(fileList);
std_distance2Size36 = std(distance2Size36)/length(fileList);
std_distance2Size60 = std(distance2Size60)/length(fileList);

mean_distance3Size21 = mean(distance3Size21);
mean_distance3Size36 = mean(distance3Size36);
mean_distance3Size60 = mean(distance3Size60);
std_distance3Size21 = std(distance3Size21)/length(fileList);
std_distance3Size36 = std(distance3Size36)/length(fileList);
std_distance3Size60 = std(distance3Size60)/length(fileList);


figure()
% Plotting the number accuracy
c = [mean_distance1Size21*100, mean_distance1Size36*100, mean_distance1Size60*100;...
    mean_distance2Size21*100, mean_distance2Size36*100, mean_distance2Size60*100;...
    mean_distance3Size21*100, mean_distance3Size36*100, mean_distance3Size60*100];
b = [std_distance1Size21*100, std_distance1Size36*100, std_distance1Size60*100;...
    std_distance2Size21*100, std_distance2Size36*100, std_distance2Size60*100;...
    std_distance3Size21*100, std_distance3Size36*100, std_distance3Size60*100];
h=bar(c);

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

set(gca,'ylim',[0,100]);
%     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
str = {'','Mean percentage seen curved and straight',''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Condition','FontSize',15);
ylabel('Percentage (%)','FontSize',15);
set(gca,'XTickLabel',graphLabel);
legend('21%', '36%', '60%');











