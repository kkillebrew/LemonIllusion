% rawdata(n,1) = lemon(1) or diamond(2)
% rawdata(n,2) = responded it was curved(1) or straight(2)
% rawdata(n,3) = does it match the stim (1) or not (2)

clear all
close all

lineColor{1}='r';
lineColor{2}='b';

% fileList = {'riley_test_orientation_040314_001.mat'};
fileList = {'GGD_lemon_041514_001','SCD_lemon_041614_001','002_lemon_041614_001','001_lemon_041614_001'};

inputFile = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/';

graphLabel = {'Curved Lemon', 'Straight Lemon', 'Curved Diamond', 'Straight Diamond'};

curvedLemon = [];
curvedDiamond = [];
straightLemon = [];
straightDiamond = [];

for p=1:length(fileList)
    load(sprintf('%s%s',inputFile,fileList{p}));
    
    curvedLemon(p) = (mean(rawdata(rawdata(:,1)==1,3)));
    straightLemon(p) = (1-curvedLemon(p));
    straightDiamond(p) = (mean(rawdata(rawdata(:,1)==2,3)));
    curvedDiamond(p) = (1-straightDiamond(p));
    
    figure()
    % Plotting the number accuracy
    bar([curvedLemon(p)*100,straightLemon(p)*100, curvedDiamond(p)*100, straightDiamond(p)*100])
    %     hold on
    set(gca,'ylim',[0,100]);
    %     errorbar(j,mean_PSE_mean(j),stderr_PSE_mean(j),'k.','LineWidth',2)
    str = {'',sprintf('Percentage seen curved and straight for diamond and lemon for particpant %d',p),''}; % cell-array method
    title(str,'FontSize',15,'FontWeight','bold')
    xlabel('Condition','FontSize',15);
    ylabel('Percentage (%)','FontSize',15);
    set(gca,'XTickLabel',graphLabel);
    
end

figure()
% Plotting the number accuracy
h=[mean(curvedLemon)*100,mean(straightLemon)*100, mean(curvedDiamond)*100, mean(straightDiamond)*100];
k=[((std(curvedLemon))/sqrt(length(fileList)))*100,((std(straightLemon))/sqrt(length(fileList)))*100,...
    ((std(curvedDiamond))/sqrt(length(fileList)))*100, ((std(straightDiamond))/sqrt(length(fileList)))*100];
bar(h)
hold on
set(gca,'ylim',[0,100]);
errorbar(h,k,'k.','LineWidth',2)
str = {'','Mean percentage seen curved and straight for diamond and lemon',''}; % cell-array method
title(str,'FontSize',15,'FontWeight','bold')
xlabel('Condition','FontSize',15);
ylabel('Percentage (%)','FontSize',15);
set(gca,'XTickLabel',graphLabel);



    