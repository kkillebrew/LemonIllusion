% rawdata(n,1) = at 1=90% or 2=touching
% rawdata(n,2) = ratio size of circles (1=10% of distance between tangent
%   and edge of circle 2=30% 3=60% 4=90%)
% rawdata(n,3) = responded it was curved(1) or straight(2)


close all;
clear all;

fileList = {'BID_lemonOccluded_061814_001','TC_lemonOccluded_061914_001','001_lemonOccluded_061914_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment2/Data/';

graphLabel = {'Distance 1', 'Distance 2'};

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    ninety10(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==1 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==1,:));
    ninety30(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==2 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==2,:));
    ninety60(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==3 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==3,:));
    ninety90(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==4 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==4,:));
    
    touching10(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==1 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==1,:));
    touching30(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==2 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==2,:));
    touching60(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==3 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==3,:));
    touching90(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==4 & rawdata(:,3)==1,:))/length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==4,:));
    
    figure()
    % Plotting the number accuracy
    bar([ninety10(p)*100, ninety30(p)*100, ninety60(p)*100, ninety90(p)*100;...
        touching10(p)*100, touching30(p)*100, touching60(p)*100, touching90(p)*100;])
    %     hold on
    set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved and straight for diamond and lemon for particpant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Condition','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',graphLabel);
    legend('21%', '36%', '60%');
    
end