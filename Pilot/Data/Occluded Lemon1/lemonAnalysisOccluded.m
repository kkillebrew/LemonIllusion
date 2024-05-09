% rawdata(n,1) = top/bot(0) left/right(1)
% rawdata(n,2) = amount occluded (1=0% of distance between tangent and edge
%    of circle 2=33% 3=66% 4=100%)
% rawdata(n,3) = responded it was curved(0) or straight(1)

clear all
close all

lineColor{1}='r';
lineColor{2}='b';

% fileList = {'riley_test_orientation_040314_001.mat'};
fileList = {'001_lemonOccluded_042114_001','testcody_lemonOccluded_042114_001','002_lemonOccluded_042214_001','003_lemonOccluded_042314_001_full'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/Occluded Lemon1/';

graphLabel = {'No Occlucion', '33% Occluded', '66% Occluded', 'Fully Occluded'};

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    for i=1:length(rawdata)
        if rawdata(i,1) == 2
            rawdata(i,1) = 1;
        elseif rawdata(i,1) == 1
            rawdata(i,1) = 0;
        end
        if rawdata(i,3) == 2
            rawdata(i,3) = 1;
        elseif rawdata(i,3) == 1
            rawdata(i,3) = 0;
        end
    end
    
    % In general did they see it as being curved or straight
    curved(p) = mean(rawdata(:,3))==0;
    straight(p) = mean(rawdata(:,3))==1;
    
      % INCORRECT CODE
%     % Looking at it in terms of occlusion (1=none 4==full)
%     topbotCurve(p,4) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==0),2)==4);
%     topbotCurve(p,3) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==0),2)==3);
%     topbotCurve(p,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==0),2)==2);
%     topbotCurve(p,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==0),2)==1);
%     
%     topbotStraight(p,4) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==1),2)==4);
%     topbotStraight(p,3) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==1),2)==3);
%     topbotStraight(p,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==1),2)==2);
%     topbotStraight(p,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,3)==1),2)==1);
%     
%     
%     leftrightCurve(p,4) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==0),2)==4);
%     leftrightCurve(p,3) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==0),2)==3);
%     leftrightCurve(p,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==0),2)==2);
%     leftrightCurve(p,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==0),2)==1);
%     
%     leftrightStraight(p,4) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==1),2)==4);
%     leftrightStraight(p,3) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==1),2)==3);
%     leftrightStraight(p,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==1),2)==2);
%     leftrightStraight(p,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,3)==1),2)==1);

    % Top Bottom Occluded
    % tb(p,4,1)=occluded and said it was curved 
    tb(p,4,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==4),3)==0);
    tb(p,4,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==4),3)==1);
    
    % tb(p,3,1) = not occluded and said it was curved
    tb(p,3,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==3),3)==0);
    tb(p,3,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==3),3)==1);
    
    % tb(p,2,1)=occluded and said it was curved 
    tb(p,2,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==2),3)==0);
    tb(p,2,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==2),3)==1);
    
    % tb(p,1,1) = not occluded and said it was curved
    tb(p,1,1) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==1),3)==0);
    tb(p,1,2) = mean(rawdata(and(rawdata(:,1)==0,rawdata(:,2)==1),3)==1);
    
    % Left Right Occluded
    % tb(p,4,1)=occluded and said it was curved 
    lr(p,4,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==4),3)==0);
    lr(p,4,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==4),3)==1);
    
    % tb(p,3,1) = not occluded and said it was curved
    lr(p,3,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==3),3)==0);
    lr(p,3,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==3),3)==1);
    
    % tb(p,2,1)=occluded and said it was curved 
    lr(p,2,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==2),3)==0);
    lr(p,2,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==2),3)==1);
    
    % tb(p,1,1) = not occluded and said it was curved
    lr(p,1,1) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==1),3)==0);
    lr(p,1,2) = mean(rawdata(and(rawdata(:,1)==1,rawdata(:,2)==1),3)==1);
    
    
    figure()
    subplot(1,2,1)
    bar([tb(p,1,1), tb(p,1,2); tb(p,2,1), tb(p,2,2); tb(p,3,1), tb(p,3,2); tb(p,4,1), tb(p,4,2)])
    %     hold on
    %     set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved and straight for top/bot occlusion for particpant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Occlusion Level','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',graphLabel);
    legend('Seen as curved', 'Seen as straight');
    
    subplot(1,2,2)
    bar([lr(p,1,1), lr(p,1,2); lr(p,2,1), lr(p,2,2); lr(p,3,1), lr(p,3,2); lr(p,4,1), lr(p,4,2)])
    %     hold on
    %     set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved and straight for left/right occlusion for particpant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Occlusion Level','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',graphLabel);
    legend('Seen as curved', 'Seen as straight');
    
end

figure()
subplot(1,2,1)
% Plotting the number accuracy
c=[mean(tb(:,1,1)), mean(tb(:,1,2)); mean(tb(:,2,1)), mean(tb(:,2,2)); mean(tb(:,3,1)), mean(tb(:,3,2)); mean(tb(:,4,1)), mean(tb(:,4,2))];
b=[std(tb(:,1,1))/sqrt(length(fileList)), std(tb(:,1,2))/sqrt(length(fileList)); std(tb(:,2,1))/sqrt(length(fileList)),...
    std(tb(:,2,2))/sqrt(length(fileList)); std(tb(:,3,1))/sqrt(length(fileList)), std(tb(:,3,2))/sqrt(length(fileList));...
    std(tb(:,4,1))/sqrt(length(fileList)), std(tb(:,4,2))/sqrt(length(fileList))];
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
%%%%%%%%
%     hold on
%     set(gca,'ylim',[0,100]);
%     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
str = {'','Average percentage seen curved and straight for top/bot accross occlusion levels',''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Occlusion Level','FontSize',15);
ylabel('Percentage (%)','FontSize',15);
set(gca,'XTickLabel',graphLabel);
legend('Seen as curved', 'Seen as straight');

subplot(1,2,2)
% Plotting the number accuracy
c=[mean(lr(:,1,1)), mean(lr(:,1,2)); mean(lr(:,2,1)), mean(lr(:,2,2)); mean(lr(:,3,1)), mean(lr(:,3,2)); mean(lr(:,4,1)), mean(lr(:,4,2))];
b=[std(lr(:,1,1))/sqrt(length(fileList)), std(lr(:,1,2))/sqrt(length(fileList)); std(lr(:,2,1))/sqrt(length(fileList)),...
    std(lr(:,2,2))/sqrt(length(fileList)); std(lr(:,3,1))/sqrt(length(fileList)), std(lr(:,3,2))/sqrt(length(fileList));...
    std(lr(:,4,1))/sqrt(length(fileList)), std(lr(:,4,2))/sqrt(length(fileList))];
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
%%%%%%%%
%     hold on
%     set(gca,'ylim',[0,100]);
%     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
str = {'','Average percentage seen curved and straight for left/right accross occlusion levels',''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Occlusion Level','FontSize',15);
ylabel('Percentage (%)','FontSize',15);
set(gca,'XTickLabel',graphLabel);
legend('Seen as curved', 'Seen as straight');










