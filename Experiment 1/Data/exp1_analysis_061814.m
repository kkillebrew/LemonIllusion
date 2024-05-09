% rawdata(n,1) = 1=lemon 2=diamond 3=rounded square 4=square
% rawdata(n,2) = responded it was curved(1) or straight(2)


close all;
clear all;

fileList = {'BID_lemonVsDiamond_061814_001','TC_lemonVsDiamond_061914_001','001_lemonVsDiamond_061914_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment 1/Data/';

graphLabel = {'Lemon', 'Diamond', 'Round Square', 'Square'};

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    roundedLemon(p) = length(rawdata(rawdata(:,1)==1 & rawdata(:,2)==1,:))/length(rawdata(rawdata(:,1)==1,:));
    straightLemon(p) = length(rawdata(rawdata(:,1)==2 & rawdata(:,2)==1,:))/length(rawdata(rawdata(:,1)==2,:));
    roundedSquare(p) = length(rawdata(rawdata(:,1)==3 & rawdata(:,2)==1,:))/length(rawdata(rawdata(:,1)==3,:));
    straightSquare(p) = length(rawdata(rawdata(:,1)==4 & rawdata(:,2)==1,:))/length(rawdata(rawdata(:,1)==4,:));

    figure()
    % Plotting the number accuracy
    bar([roundedLemon(p)*100, straightLemon(p)*100, roundedSquare(p)*100, straightSquare(p)*100])
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

