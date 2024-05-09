% rawdata(n,1) = % Ratios 1=.1 2=.3 3=.5 4=.7
% rawdata(n,2) = amount occluded (1=0% of distance between tangent and edge
%    of circle 2=33% 3=66% 4=100%)
% rawdata(n,3) = responded it was curved(1) or straight(2)

close all
clear all

keyNum = 2;

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'lemonOccluded3';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');

if keyNum == 1
    datadir = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/Occluded Lemon3/';
elseif keyNum == 2
    datadir = '/Volumes/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/Occluded Lemon3/';
end

datafile=sprintf('%s_%s_%s_%03d',subjid,experiment,datecode,runid);
datafile_full=sprintf('%s_full',datafile);

% check to see if this file exists
if exist(fullfile(datadir,[datafile '.mat']),'file')
    tmpfile = input('File exists.  Overwrite? y/n:','s');
    while ~ismember(tmpfile,{'n' 'y'})
        tmpfile = input('Invalid choice. File exists.  Overwrite? y/n:','s');
    end
    if strcmp(tmpfile,'n')
        display('Bye-bye...');
        return; % will need to start over for new input
    end
end

ListenChar(2);
HideCursor;

backColor = 128;
dotColor = 0;
textColor = [256, 256, 256];

mon_width_cm = 40;
mon_dist_cm = 73;
mon_width_deg = 2 * (180/pi) * atan((mon_width_cm/2)/mon_dist_cm);
PPD = (1024/mon_width_deg);

rect=[0 0 1024 768];     % test comps
[w,rect]=Screen('OpenWindow', 1,[backColor backColor backColor],rect);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

[nums, names] = GetKeyboardIndices;
dev_ID=nums(keyNum);
con_ID=nums(1);

buttonEscape = KbName('Escape');
buttonLeft = KbName('LeftShift');
buttonRight = KbName('RightShift');

occludedTypeList = [1 2 3 4]; % Ratios 1=.1 2=.3 3=.5 4=.7
nStimType = length(occludedTypeList);
amountOccludedList = [1 2 3 4];    % 1=maximally occluded 2=33% 3=66% 4=not occluded
 nAmount = length(amountOccludedList);
nTrials = 20;

variableList = repmat(fullyfact([nStimType nAmount]),[nTrials,1]);
trialOrder = randperm(length(variableList));
numTrials = nTrials*nStimType*nAmount;

circleSize = x0/2;
ratioSize = .7;
smallCircleSize = circleSize*ratioSize;
distanceOffset = circleSize;
distanceOffsetBig = 0;
distance2Object = 45;
amountOccludedPrac = [];
occludedRectTop = [];

% Calculates the tangent lines
% Start values for the left lines
p1=x0;
q1U=y0-distanceOffsetBig;
q1D=y0+distanceOffsetBig;
p2=x0-distanceOffset/2;
q2=y0;
q2D=y0+distanceOffsetBig;
r1=circleSize/2;
r2=smallCircleSize/2;
% Upper left
d2 = (p2-p1)^2+(q2-q1U)^2;
r = sqrt(d2-(r2-r1)^2);
s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
x1UL = p1-r1*s;
y1UL = q1U+r1*c;
x2UL = p2-r2*s;
y2UL = q2+r2*c;
% Lower left
d2 = (p2-p1)^2+(q2-q1D)^2;
r = sqrt(d2-(-r2+r1)^2);
s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
x1LL = p1+r1*s;
y1LL = q1D-r1*c;
x2LL = p2+r2*s;
y2LL = q2-r2*c;

% Start values for the right lines
p1=x0;
q1U=y0+distanceOffsetBig;
q1D=y0-distanceOffsetBig;
p2=x0+distanceOffset/2;
q2=y0;
r1=circleSize/2;
r2=smallCircleSize/2;
% Upper right
d2 = (p2-p1)^2+(q2-q1U)^2;
r = sqrt(d2-(r2-r1)^2);
s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
x1UR = p1-r1*s;
y1UR = q1U+r1*c;
x2UR = p2-r2*s;
y2UR = q2+r2*c;
% Lower right
d2 = (p2-p1)^2+(q2-q1D)^2;
r = sqrt(d2-(-r2+r1)^2);
s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
x1LR = p1+r1*s;
y1LR = q1D-r1*c;
x2LR = p2+r2*s;
y2LR = q2-r2*c;

% Drawing the arrays for the arc and line
% Making sure only values of 128 and 0 are in the array
if keyNum == 1
    imageArc = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Code/Arc','jpeg');
elseif keyNum == 2
    imageArc = imread('/Volumes/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Code/Arc','jpeg');
end
imageArc = imageArc(:,:,1);
[arcHeight, arcWidth] = size(imageArc);
for i=1:arcWidth
    for j=1:arcHeight
        if imageArc(j,i)>=100
            imageArc(j,i) = 128;
        end
        if imageArc(j,i)<100
            imageArc(j,i) = 0;
        end
    end
end
if keyNum == 1
    imageLine = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Code/Straight','jpeg');
elseif keyNum == 2
    imageLine = imread('/Volumes/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Code/Straight','jpeg');
end
imageLine = imageLine(:,:,1);
[lineHeight, lineWidth] = size(imageLine);
for i=1:lineWidth
    for j=1:lineHeight
        if imageLine(j,i)>=50
            imageLine(j,i) = 128;
        end
        if imageLine(j,i)<50
            imageLine(j,i) = 0;
        end
    end
end


% Instructions
Screen('TextSize',w,20);
text='Press any key to begin.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
text='Pay close attention to what the lines look like and how they relate to the sides of both objects.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-100,textColor);
text='For the first four trials, you will see either a lemon shaped object or a diamond.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-200,textColor);
text='Afterwards, four pair of lines will appear. One pair will be straight and one curved.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-150,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

[keyIsDown, secs, keycode] = KbCheck(dev_ID);
for n=1:8
    
    stimTypePrac = [1 1 2 2 3 3 4 4];
    amountOccludedPrac = [1 4 1 4 1 4 1 4];
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    if stimTypePrac(n) == 1
        circleSize = x0/2;
        ratioSize = .1;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
    elseif stimTypePrac(n) == 2
        circleSize = x0/2;
        ratioSize = .3;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
    elseif stimTypePrac(n) == 3
        circleSize = x0/2;
        ratioSize = .5;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
    elseif stimTypePrac(n) == 4
        circleSize = x0/2;
        ratioSize = .7;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
    end
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=x0-distanceOffset/2;
    q2=y0;
    q2D=y0+distanceOffsetBig;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper left
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1UL = p1-r1*s;
    y1UL = q1U+r1*c;
    x2UL = p2-r2*s;
    y2UL = q2+r2*c;
    % Lower left
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1LL = p1+r1*s;
    y1LL = q1D-r1*c;
    x2LL = p2+r2*s;
    y2LL = q2-r2*c;
    
    % Start values for the right lines
    p1=x0;
    q1U=y0+distanceOffsetBig;
    q1D=y0-distanceOffsetBig;
    p2=x0+distanceOffset/2;
    q2=y0;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper right
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1UR = p1-r1*s;
    y1UR = q1U+r1*c;
    x2UR = p2-r2*s;
    y2UR = q2+r2*c;
    % Lower right
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1LR = p1+r1*s;
    y1LR = q1D-r1*c;
    x2LR = p2+r2*s;
    y2LR = q2-r2*c;
    
    
    % Draw the four circles
    Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)-distanceOffsetBig, x0+(circleSize/2),...
        y0+(circleSize/2)-distanceOffsetBig]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)+distanceOffsetBig, x0+(circleSize/2),...
        y0+(circleSize/2)+distanceOffsetBig]);
    
    Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))-distanceOffset/2,...
        (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))-distanceOffset/2,...
        (y0+(smallCircleSize/2))]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))+distanceOffset/2,...
        (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))+distanceOffset/2,...
        (y0+(smallCircleSize/2))]);
    
    % Draw thick tangent lines between the circles
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
    
    for j=1:4
        if j == 1
            slp = abs(((y1UL-y2UL)/(x1UL-x2UL)));
            x1 = x2UL;
            x2 = x1;
            y1 = y2UL;
            y2 = y0;
        elseif j == 2
            slp = abs(((y1UR-y2UR)/(x1UR-x2UR)));
            x1 = x2UR;
            x2 = x1;
            y1 = y2UR;
            y2 = y0;
        elseif j == 3
            slp = abs(((y1LL-y2LL)/(x1LL-x2LL)));
            x1 = x2LL;
            x2 = x1;
            y1 = y2LL;
            y2 = y0;
        elseif j == 4
            slp = abs(((y1LR-y2LR)/(x1LR-x2LR)));
            x1 = x2LR;
            x2 = x1;
            y1 = y2LR;
            y2 = y0;
        end
        for i=1:round(x1UL-x2UL)
            Screen('DrawLine',w,[dotColor dotColor dotColor],x1,y1,x2,y2,1);
            if j == 1
                x1 = x1+1;
                y1 = y1-slp;
                x2 = x1;
            elseif j == 2
                x1 = x1-1;
                y1 = y1+slp;
                x2 = x1;
            elseif j == 3
                x1 = x1+1;
                y1 = y1+slp;
                x2 = x1;
            elseif j == 4
                x1 = x1-1;
                y1 = y1-slp;
                x2 = x1;
            end
        end
    end
    
    
    if amountOccludedPrac(n) == 1
        occludedRectLeft(1,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, (x0-(smallCircleSize/2))-distanceOffset/2-5, (y0+(smallCircleSize/2))+10];
        occludedRectRight(1,:) = [(x0+(smallCircleSize/2))+distanceOffset/2+5, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(1,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(1,:));
    elseif amountOccludedPrac(n) == 2
        occludedRectLeft(2,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL - (x2UL - ((x0-(smallCircleSize/2))-distanceOffset/2))*.66, (y0+(smallCircleSize/2))+10];
        occludedRectRight(2,:) = [x2UR + (((x0+(smallCircleSize/2))+distanceOffset/2) - x2UR)*.66, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(2,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(2,:));
    elseif amountOccludedPrac(n) == 3
        occludedRectLeft(3,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL - (x2UL - ((x0-(smallCircleSize/2))-distanceOffset/2))*.33, (y0+(smallCircleSize/2))+10];
        occludedRectRight(3,:) = [x2UR + (((x0+(smallCircleSize/2))+distanceOffset/2) - x2UR)*.33, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(3,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(3,:));
    elseif amountOccludedPrac(n) == 4
        occludedRectLeft(4,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL, (y0+(smallCircleSize/2))+10];
        occludedRectRight(4,:) = [x2UR, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(4,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(4,:));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('Flip',w);
    WaitSecs(5);
    
    Screen('Flip',w);
    WaitSecs(.2);
    
    %     if lineOrderVal == 1
    imageLines = [imageArc; imageLine];
    
    % Combine the two lines into one texture
    [linesHeight, linesWidth] = size(imageLines);
    linesHeight=linesHeight*.5;
    linesWidth=linesWidth*.5;
    linesTexture = Screen('MakeTexture',w,imageLines);
    %     elseif lineOrderVal == 2
    %         imageLines = [imageLine; imageArc];
    %
    %         % Combine the two lines into one texture
    %         [linesHeight, linesWidth] = size(imageLines);
    %         linesHeight=linesHeight*.5;
    %         linesWidth=linesWidth*.5;
    %         linesTexture = Screen('MakeTexture',w,imageLines);
    %     end
    
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    
    linesULRect = [((x0-distanceOffset-smallCircleSize/2)-linesWidth/2)+distance2Object ((y0-circleSize/2)-(linesHeight/2))+distance2Object...
        ((x0-distanceOffset-smallCircleSize/2)+linesWidth/2)+distance2Object ((y0-circleSize/2)+(linesHeight/2))+distance2Object];
    Screen('DrawTexture',w,linesTexture,[],linesULRect,325);
    
    linesURRect = [((x0+distanceOffset+smallCircleSize/2)-linesWidth/2)-distance2Object ((y0-circleSize/2)-(linesHeight/2))+distance2Object...
        ((x0+distanceOffset+smallCircleSize/2)+linesWidth/2)-distance2Object ((y0-circleSize/2)+(linesHeight/2))+distance2Object];
    Screen('DrawTexture',w,linesTexture,[],linesURRect,35);
    
    linesLLRect = [((x0-distanceOffset-smallCircleSize/2)-linesWidth/2)+distance2Object ((y0+circleSize/2)-(linesHeight/2))-distance2Object...
        ((x0-distanceOffset-smallCircleSize/2)+linesWidth/2)+distance2Object ((y0+circleSize/2)+(linesHeight/2))-distance2Object];
    Screen('DrawTexture',w,linesTexture,[],linesLLRect,215);
    
    linesLRRect = [((x0+distanceOffset+smallCircleSize/2)-linesWidth/2)-distance2Object ((y0+circleSize/2)-(linesHeight/2))-distance2Object...
        ((x0+distanceOffset+smallCircleSize/2)+linesWidth/2)-distance2Object ((y0+circleSize/2)+(linesHeight/2))-distance2Object];
    Screen('DrawTexture',w,linesTexture,[],linesLRRect,145);
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    
    Screen('Flip',w);
    
    KbWait(dev_ID);
    KbReleaseWait(dev_ID);
end


% Instructions
Screen('TextSize',w,20);
text='Press any key to begin.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
text='Press left shift if the lines of the object look curved.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-150,textColor);
text='Press right shift if the lines of the object look straight.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-100,textColor);
text='Please maintain central fixation throughout the experiment.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-200,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);
[keyIsDown, secs, keycode] = KbCheck(dev_ID);
for n=1:numTrials
    
    % Determines the ratio of the small to big circles
    stimTypeIdx=variableList(trialOrder(n),1);
    stimTypeVal=occludedTypeList(stimTypeIdx);
    rawdata(n,1)=stimTypeVal;
    
    amountOccludedIdx = variableList(trialOrder(n),2);
    amountOccludedVal = amountOccludedList(amountOccludedIdx);
    rawdata(n,2) = amountOccludedVal;
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    if stimTypeVal == 1
        ratioSize = .1;
        smallCircleSize = circleSize*ratioSize;
    elseif stimTypeVal == 2
        ratioSize = .3;
        smallCircleSize = circleSize*ratioSize;
    elseif stimTypeVal == 3
        ratioSize = .5;
        smallCircleSize = circleSize*ratioSize;
    elseif stimTypeVal == 4
        ratioSize = .7;
        smallCircleSize = circleSize*ratioSize;
    end
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=x0-distanceOffset/2;
    q2=y0;
    q2D=y0+distanceOffsetBig;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper left
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1UL = p1-r1*s;
    y1UL = q1U+r1*c;
    x2UL = p2-r2*s;
    y2UL = q2+r2*c;
    % Lower left
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1LL = p1+r1*s;
    y1LL = q1D-r1*c;
    x2LL = p2+r2*s;
    y2LL = q2-r2*c;
    
    % Start values for the right lines
    p1=x0;
    q1U=y0+distanceOffsetBig;
    q1D=y0-distanceOffsetBig;
    p2=x0+distanceOffset/2;
    q2=y0;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper right
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1UR = p1-r1*s;
    y1UR = q1U+r1*c;
    x2UR = p2-r2*s;
    y2UR = q2+r2*c;
    % Lower right
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1LR = p1+r1*s;
    y1LR = q1D-r1*c;
    x2LR = p2+r2*s;
    y2LR = q2-r2*c;
    
    
    % Draw the three circles
    Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)-distanceOffsetBig, x0+(circleSize/2),...
        y0+(circleSize/2)-distanceOffsetBig]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)+distanceOffsetBig, x0+(circleSize/2),...
        y0+(circleSize/2)+distanceOffsetBig]);
    
    Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))-distanceOffset/2,...
        (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))-distanceOffset/2,...
        (y0+(smallCircleSize/2))]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))+distanceOffset/2,...
        (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))+distanceOffset/2,...
        (y0+(smallCircleSize/2))]);
    
    % Draw thick tangent lines between the circles
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
    
    for j=1:4
        if j == 1
            slp = abs(((y1UL-y2UL)/(x1UL-x2UL)));
            x1 = x2UL;
            x2 = x1;
            y1 = y2UL;
            y2 = y0;
        elseif j == 2
            slp = abs(((y1UR-y2UR)/(x1UR-x2UR)));
            x1 = x2UR;
            x2 = x1;
            y1 = y2UR;
            y2 = y0;
        elseif j == 3
            slp = abs(((y1LL-y2LL)/(x1LL-x2LL)));
            x1 = x2LL;
            x2 = x1;
            y1 = y2LL;
            y2 = y0;
        elseif j == 4
            slp = abs(((y1LR-y2LR)/(x1LR-x2LR)));
            x1 = x2LR;
            x2 = x1;
            y1 = y2LR;
            y2 = y0;
        end
        for i=1:round(x1UL-x2UL)
            Screen('DrawLine',w,[dotColor dotColor dotColor],x1,y1,x2,y2,1);
            if j == 1
                x1 = x1+1;
                y1 = y1-slp;
                x2 = x1;
            elseif j == 2
                x1 = x1-1;
                y1 = y1+slp;
                x2 = x1;
            elseif j == 3
                x1 = x1+1;
                y1 = y1+slp;
                x2 = x1;
            elseif j == 4
                x1 = x1-1;
                y1 = y1-slp;
                x2 = x1;
            end
        end
    end
    
    Screen('FillRect',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-distanceOffsetBig,x0+(circleSize/2),y0+distanceOffsetBig]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if amountOccludedVal == 1
        occludedRectLeft(1,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, (x0-(smallCircleSize/2))-distanceOffset/2-5, (y0+(smallCircleSize/2))+10];
        occludedRectRight(1,:) = [(x0+(smallCircleSize/2))+distanceOffset/2+5, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(1,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(1,:));
    elseif amountOccludedVal == 2
        occludedRectLeft(2,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL - (x2UL - ((x0-(smallCircleSize/2))-distanceOffset/2))*.66, (y0+(smallCircleSize/2))+10];
        occludedRectRight(2,:) = [x2UR + (((x0+(smallCircleSize/2))+distanceOffset/2) - x2UR)*.66, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(2,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(2,:));
    elseif amountOccludedVal == 3
        occludedRectLeft(3,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL - (x2UL - ((x0-(smallCircleSize/2))-distanceOffset/2))*.33, (y0+(smallCircleSize/2))+10];
        occludedRectRight(3,:) = [x2UR + (((x0+(smallCircleSize/2))+distanceOffset/2) - x2UR)*.33, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(3,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(3,:));
    elseif amountOccludedVal == 4
        occludedRectLeft(4,:) = [(x0-(smallCircleSize/2))-distanceOffset/2-10, (y0-(smallCircleSize/2))-10, x2UL, (y0+(smallCircleSize/2))+10];
        occludedRectRight(4,:) = [x2UR, (y0-(smallCircleSize/2))-10, (x0+(smallCircleSize/2))+distanceOffset/2+10, (y0+(smallCircleSize/2))+10];
        Screen('FillRect',w,[backColor backColor backColor],occludedRectLeft(4,:));
        Screen('FillRect',w,[backColor backColor backColor],occludedRectRight(4,:));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('Flip',w);
    WaitSecs(.5);
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.2);
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    
    
    Screen('TextSize',w,20);
    text='Did the lines appear curved(left) or straight(right)?';
    tWidth=RectWidth(Screen('TextBounds',w,text));
    Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    
    % Rawdata(n,2) = 1(curve away) 2(curve close)
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    while 1
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        if keycode(buttonLeft) % responded it was curved
            rawdata(n,3) = 1;
            break
        elseif keycode(buttonRight) % responded it was straight
            rawdata(n,3) = 2;
            break
        end
    end
    KbWait(dev_ID);
    KbReleaseWait(dev_ID);
    
end

% rawdata(n,1) = % Ratios 1=.1 2=.3 3=.5 4=.7
% rawdata(n,2) = amount occluded (1=0% of distance between tangent and edge
%    of circle 2=33% 3=66% 4=100%)
% rawdata(n,3) = responded it was curved(1) or straight(2)

save(sprintf('%s%s',datadir,datafile),'rawdata');
save(sprintf('%s%s',datadir,datafile_full));

ListenChar(0);
Screen('CloseAll');
ShowCursor;






