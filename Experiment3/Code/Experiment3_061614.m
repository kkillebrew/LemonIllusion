% rawdata(n,1) = circleSize (1=21, 2=36, 3=60)
% rawdata(n,2) = circleDistance (1=60, 2=36, 3=21)
% rawdata(n,3) = 1-curved 2-straight

close all
clear all

keyNum = 1;

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'lemonDistance';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');
if keyNum == 1
    datadir = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Data/';
elseif keyNum == 2
    datadir = '/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Data/';
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
[w,rect]=Screen('OpenWindow', 1,[backColor backColor backColor],rect,[],[],[],100);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

[nums, names] = GetKeyboardIndices;
dev_ID=nums(keyNum);
con_ID=nums(1);

buttonEscape = KbName('Escape');
buttonLeft = KbName('LeftShift');
buttonRight = KbName('RightShift');
buttonRightA = KbName('RightArrow');
buttonLeftA = KbName('LeftArrow');
buttonSpace = KbName('Space');

circleDistanceList = [1 2 3];
nCircleDistance = length(circleDistanceList);
circleSizeList = [1 2 3];
nCircleSize = length(circleSizeList);
nTrials = 20;

variableList = repmat(fullyfact([nCircleDistance nCircleSize]),[nTrials,1]);
trialOrder = randperm(length(variableList));
numTrials = nTrials*nCircleDistance*nCircleSize;

% Drawing the arrays for the arc and line
% Making sure only values of 128 and 0 are in the array
if keyNum == 1
    imageArc = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Code/Arc','jpeg');
elseif keyNum == 2
    imageArc = imread('/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Code/Arc','jpeg');
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
    imageLine = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Code/Straight','jpeg');
elseif keyNum == 2
    imageLine = imread('/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment3/Code/Straight','jpeg');
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

ratioSize = .6;
circleSize = x0/2;
distanceOffset = circleSize;
distanceOffsetBig = 0;
distance2Object = 55;

size60 = circleSize*ratioSize;
size36 = size60*ratioSize;
size21 = size36*ratioSize;

circleDistancePrac = [1 1 1 2 2 2 3 3 3];
circleSizePrac = [1 2 3 1 2 3 1 2 3];

% Instructions
Screen('TextSize',w,20);
text='Press any key to begin.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
text='Pay close attention to what the lines look like and how they relate to the sides of both objects.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-100,textColor);
text='You will first see a series of diamond shaped objects of various sizes.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-250,textColor);
text='Also, four pair of lines will appear, corresponding to the sides fo the object.'; 
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-200,textColor);
text='One pair will be straight and one slightly curved.';
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-150,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

for n=1:9
    
    if circleSizePrac(n) == 1
        smallCircleSize = size60;
    elseif circleSizePrac(n) == 2
        smallCircleSize = size36;
    elseif circleSizePrac(n) == 3
        smallCircleSize = size21;
    end
    
    if circleDistancePrac(n) == 1
        x1R = (x0+(size60/2+distanceOffset/2))-smallCircleSize/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = (x0+(size60/2+distanceOffset/2))+smallCircleSize/2;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(size60/2+distanceOffset/2))-smallCircleSize/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = (x0-(size60/2+distanceOffset/2))+smallCircleSize/2;
        y2L = (y0+(smallCircleSize/2));
        variableLength = (size60/2)-(smallCircleSize/2);
    elseif circleDistancePrac(n) == 2
        x1R = (x0+(distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
        y1R = y0-smallCircleSize/2;
        x2R = (x0+(distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
        y2R = y0+smallCircleSize/2;
        x1L = x0-((distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
        y1L = y0-smallCircleSize/2;
        x2L = x0-((distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
        y2L = y0+smallCircleSize/2;
        variableLength = (size60+size36/2)-(smallCircleSize/2);
    elseif circleDistancePrac(n) == 3
        x1R = x0+((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
        y1R = y0-smallCircleSize/2;
        x2R = x0+((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
        y2R = y0+smallCircleSize/2;
        x1L = x0-((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
        y1L = y0-smallCircleSize/2;
        x2L = x0-((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
        y2L = y0+smallCircleSize/2;
        variableLength = (size60+size36+size21/2)-(smallCircleSize/2);
    end
    
    x1T = x0-(circleSize/2);
    x2T = x0+(circleSize/2);
    y1T = y0-(circleSize/2)-distanceOffsetBig;
    y2T = y0+(circleSize/2)-distanceOffsetBig;
    x1B = x0-(circleSize/2);
    x2B = x0+(circleSize/2);
    y1B = y0-(circleSize/2)+distanceOffsetBig;
    y2B = y0+(circleSize/2)+distanceOffsetBig;
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=(x0-((distanceOffset/2)+smallCircleSize/2))-variableLength;
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
    p2=(x0+((distanceOffset/2)+smallCircleSize/2))+variableLength;
    q2=y0;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper right
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1LR = p1-r1*s;
    y1LR = q1U+r1*c;
    x2LR = p2-r2*s;
    y2LR = q2+r2*c;
    % Lower right
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1UR = p1+r1*s;
    y1UR = q1D-r1*c;
    x2UR = p2+r2*s;
    y2UR = q2-r2*c;
    
    % Draw the four circles
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T, x2T,y2T]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B, x2B,y2B]);
    
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1L, y1L, x2L, y2L]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1R, y1R, x2R, y2R]);
    
    % Draw tangent lines between the circles
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
    
    Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
    Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
    
    imageLines = [imageArc; imageLine];
    
    % Combine the two lines into one texture
    [linesHeight, linesWidth] = size(imageLines);
    linesHeight=linesHeight*.5;
    linesWidth=linesWidth*.5;
    linesTexture = Screen('MakeTexture',w,imageLines);
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    
    slpLL = (y1UL-y2UL)/(x1UL-x2UL);
    
    linesULRect = [x2UL+((x1UL-x2UL)/2)-distance2Object-linesWidth/2, y2UL-((y2UL-y1UL)/2)-distance2Object-linesHeight/2, ...
        x2UL+((x1UL-x2UL)/2)-distance2Object+linesWidth/2, y2UL-((y2UL-y1UL)/2)-distance2Object+linesHeight/2];
    Screen('DrawTexture',w,linesTexture,[],linesULRect, atand(slpLL));
    
    linesURRect = [x2UR+((x1UR-x2UR)/2)+distance2Object-linesWidth/2, y2UR-((y2UR-y1UR)/2)-distance2Object-linesHeight/2, ...
        x2UR+((x1UR-x2UR)/2)+distance2Object+linesWidth/2, y2UR-((y2UR-y1UR)/2)-distance2Object+linesHeight/2];
    Screen('DrawTexture',w,linesTexture,[],linesURRect,-atand(slpLL));
    
    linesLLRect = [x2LL+((x1LL-x2LL)/2)-distance2Object-linesWidth/2, y2LL-((y2LL-y1LL)/2)+distance2Object-linesHeight/2, ...
        x2LL+((x1LL-x2LL)/2)-distance2Object+linesWidth/2, y2LL-((y2LL-y1LL)/2)+distance2Object+linesHeight/2];
    Screen('DrawTexture',w,linesTexture,[],linesLLRect,-atand(slpLL)-180);
    
    linesLRRect = [x2LR+((x1LR-x2LR)/2)+distance2Object-linesWidth/2, y2LR-((y2LR-y1LR)/2)+distance2Object-linesHeight/2, ...
        x2LR+((x1LR-x2LR)/2)+distance2Object+linesWidth/2, y2LR-((y2LR-y1LR)/2)+distance2Object+linesHeight/2];
    Screen('DrawTexture',w,linesTexture,[],linesLRRect,atand(slpLL)-180);
    
    
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

for n=1:numTrials
    
    circleDistanceIdx = variableList(trialOrder(n),1);
    distanceVal = circleDistanceList(circleDistanceIdx);
    rawdata(n,1) = distanceVal;
    
    circleSizeIdx = variableList(trialOrder(n),2);
    sizeVal = circleSizeList(circleSizeIdx);
    rawdata(n,2) = sizeVal;
    
    if sizeVal == 1
        smallCircleSize = size60;
    elseif sizeVal == 2
        smallCircleSize = size36;
    elseif sizeVal == 3
        smallCircleSize = size21;
    end
    
    if distanceVal == 1
        x1R = (x0+(size60/2+distanceOffset/2))-smallCircleSize/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = (x0+(size60/2+distanceOffset/2))+smallCircleSize/2;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(size60/2+distanceOffset/2))-smallCircleSize/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = (x0-(size60/2+distanceOffset/2))+smallCircleSize/2;
        y2L = (y0+(smallCircleSize/2));
        variableLength = (size60/2)-(smallCircleSize/2);
    elseif distanceVal == 2
        x1R = (x0+(distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
        y1R = y0-smallCircleSize/2;
        x2R = (x0+(distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
        y2R = y0+smallCircleSize/2;
        x1L = x0-((distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
        y1L = y0-smallCircleSize/2;
        x2L = x0-((distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
        y2L = y0+smallCircleSize/2;
        variableLength = (size60+size36/2)-(smallCircleSize/2);
    elseif distanceVal == 3
        x1R = x0+((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
        y1R = y0-smallCircleSize/2;
        x2R = x0+((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
        y2R = y0+smallCircleSize/2;
        x1L = x0-((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
        y1L = y0-smallCircleSize/2;
        x2L = x0-((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
        y2L = y0+smallCircleSize/2;
        variableLength = (size60+size36+size21/2)-(smallCircleSize/2);
    end
    
    x1T = x0-(circleSize/2);
    x2T = x0+(circleSize/2);
    y1T = y0-(circleSize/2)-distanceOffsetBig;
    y2T = y0+(circleSize/2)-distanceOffsetBig;
    x1B = x0-(circleSize/2);
    x2B = x0+(circleSize/2);
    y1B = y0-(circleSize/2)+distanceOffsetBig;
    y2B = y0+(circleSize/2)+distanceOffsetBig;
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=(x0-((distanceOffset/2)+smallCircleSize/2))-variableLength;
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
    p2=(x0+((distanceOffset/2)+smallCircleSize/2))+variableLength;
    q2=y0;
    r1=circleSize/2;
    r2=smallCircleSize/2;
    % Upper right
    d2 = (p2-p1)^2+(q2-q1U)^2;
    r = sqrt(d2-(r2-r1)^2);
    s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
    c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
    x1LR = p1-r1*s;
    y1LR = q1U+r1*c;
    x2LR = p2-r2*s;
    y2LR = q2+r2*c;
    % Lower right
    d2 = (p2-p1)^2+(q2-q1D)^2;
    r = sqrt(d2-(-r2+r1)^2);
    s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
    c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
    x1UR = p1+r1*s;
    y1UR = q1D-r1*c;
    x2UR = p2+r2*s;
    y2UR = q2-r2*c;
    
    % Draw the four circles
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T, x2T,y2T]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B, x2B,y2B]);
    
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1L, y1L, x2L, y2L]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1R, y1R, x2R, y2R]);
    
    % Draw tangent lines between the circles
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
    
    Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
    Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
    
    Screen('Flip',w);
    WaitSecs(.5);
    
    Screen('Flip',w);
    WaitSecs(.5);
    
    Screen('TextSize',w,20);
    text='Did the lines appear curved(left) or straight(right)?';
    tWidth=RectWidth(Screen('TextBounds',w,text));
    Screen('DrawText',w,text,x0-tWidth/2,y0-50,textColor);
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    
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
    KbReleaseWait(dev_ID);
%     
%     slpCount = 0;
%     x1ULCount = 0;
%     x2ULCount = 0;
%     y1ULCount = 0;
%     y2ULCount = 0;
%     
%     if rawdata(n,3) == 1
%         
%         [keyIsDown, secs, keycode] = KbCheck(dev_ID);
%         while ~keycode(buttonSpace)
%             
%             [keyIsDown, secs, keycode] = KbCheck(dev_ID);
%             if sizeVal == 1
%                 smallCircleSize = size60;
%             elseif sizeVal == 2
%                 smallCircleSize = size36;
%             elseif sizeVal == 3
%                 smallCircleSize = size21;
%             end
%             
%             if distanceVal == 1
%                 x1R = (x0+(size60/2+distanceOffset/2))-smallCircleSize/2;
%                 y1R = (y0-(smallCircleSize/2));
%                 x2R = (x0+(size60/2+distanceOffset/2))+smallCircleSize/2;
%                 y2R = (y0+(smallCircleSize/2));
%                 x1L = (x0-(size60/2+distanceOffset/2))-smallCircleSize/2;
%                 y1L = (y0-(smallCircleSize/2));
%                 x2L = (x0-(size60/2+distanceOffset/2))+smallCircleSize/2;
%                 y2L = (y0+(smallCircleSize/2));
%                 variableLength = (size60/2)-(smallCircleSize/2);
%             elseif distanceVal == 2
%                 x1R = (x0+(distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
%                 y1R = y0-smallCircleSize/2;
%                 x2R = (x0+(distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
%                 y2R = y0+smallCircleSize/2;
%                 x1L = x0-((distanceOffset/2)+size60+(size36/2))-smallCircleSize/2;
%                 y1L = y0-smallCircleSize/2;
%                 x2L = x0-((distanceOffset/2)+size60+(size36/2))+smallCircleSize/2;
%                 y2L = y0+smallCircleSize/2;
%                 variableLength = (size60+size36/2)-(smallCircleSize/2);
%             elseif distanceVal == 3
%                 x1R = x0+((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
%                 y1R = y0-smallCircleSize/2;
%                 x2R = x0+((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
%                 y2R = y0+smallCircleSize/2;
%                 x1L = x0-((distanceOffset/2)+size60+size36+(size21/2))-smallCircleSize/2;
%                 y1L = y0-smallCircleSize/2;
%                 x2L = x0-((distanceOffset/2)+size60+size36+(size21/2))+smallCircleSize/2;
%                 y2L = y0+smallCircleSize/2;
%                 variableLength = (size60+size36+size21/2)-(smallCircleSize/2);
%             end
%             
%             x1T = x0-(circleSize/2);
%             x2T = x0+(circleSize/2);
%             y1T = y0-(circleSize/2)-distanceOffsetBig;
%             y2T = y0+(circleSize/2)-distanceOffsetBig;
%             x1B = x0-(circleSize/2);
%             x2B = x0+(circleSize/2);
%             y1B = y0-(circleSize/2)+distanceOffsetBig;
%             y2B = y0+(circleSize/2)+distanceOffsetBig;
%             
%             % Calculates the tangent lines
%             % Start values for the left lines
%             p1=x0;
%             q1U=y0-distanceOffsetBig;
%             q1D=y0+distanceOffsetBig;
%             p2=(x0-((distanceOffset/2)+smallCircleSize/2))-variableLength;
%             q2=y0;
%             q2D=y0+distanceOffsetBig;
%             r1=circleSize/2;
%             r2=smallCircleSize/2;
%             % Upper left
%             d2 = (p2-p1)^2+(q2-q1U)^2;
%             r = sqrt(d2-(r2-r1)^2);
%             s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
%             c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
%             x1UL = p1-r1*s;
%             y1UL = q1U+r1*c;
%             x2UL = p2-r2*s;
%             y2UL = q2+r2*c;
%             % Lower left
%             d2 = (p2-p1)^2+(q2-q1D)^2;
%             r = sqrt(d2-(-r2+r1)^2);
%             s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
%             c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
%             x1LL = p1+r1*s;
%             y1LL = q1D-r1*c;
%             x2LL = p2+r2*s;
%             y2LL = q2-r2*c;
%             
%             % Start values for the right lines
%             p1=x0;
%             q1U=y0+distanceOffsetBig;
%             q1D=y0-distanceOffsetBig;
%             p2=(x0+((distanceOffset/2)+smallCircleSize/2))+variableLength;
%             q2=y0;
%             r1=circleSize/2;
%             r2=smallCircleSize/2;
%             % Upper right
%             d2 = (p2-p1)^2+(q2-q1U)^2;
%             r = sqrt(d2-(r2-r1)^2);
%             s = ((q2-q1U)*r+(p2-p1)*(r2-r1))/d2;
%             c = ((p2-p1)*r-(q2-q1U)*(r2-r1))/d2;
%             x1LR = p1-r1*s;
%             y1LR = q1U+r1*c;
%             x2LR = p2-r2*s;
%             y2LR = q2+r2*c;
%             % Lower right
%             d2 = (p2-p1)^2+(q2-q1D)^2;
%             r = sqrt(d2-(-r2+r1)^2);
%             s = ((q2-q1D)*r+(p2-p1)*(-r2+r1))/d2;
%             c = ((p2-p1)*r-(q2-q1D)*(-r2+r1))/d2;
%             x1UR = p1+r1*s;
%             y1UR = q1D-r1*c;
%             x2UR = p2+r2*s;
%             y2UR = q2-r2*c;
%             
%             % Draw the four circles
%             Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T, x2T,y2T]);
%             Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B, x2B,y2B]);
%             
%             Screen('FillOval',w,[dotColor dotColor dotColor],[x1L, y1L, x2L, y2L]);
%             Screen('FillOval',w,[dotColor dotColor dotColor],[x1R, y1R, x2R, y2R]);
%             
%             % Draw tangent lines between the circles
%             Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
%             Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
%             Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
%             Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
%             
%             Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
%             Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
%             
%             % Draw the occluding rects
%             Screen('FillRect',w,[backColor backColor backColor],[x1L, y1l, x2R, y2B]);
%             Screen('FillRect',w,[backColor backColor backColor],[x2T, y1T, x2R, y2B]);
%             
%             % Draw the dots on the tangent lines
%             % Calculate the slopes of the tangent lines
%             slpUL = abs(((y1UL-y2UL)/(x1UL-x2UL)));
%             slpUR = abs(((y1UR-y2UR)/(x1UR-x2UR)));
%             slpLL = abs(((y1LL-y2LL)/(x1LL-x2LL)));
%             slpLR = abs(((y1LR-y2LR)/(x1LR-x2LR)));
%             
%             if keycode(buttonRightA)
%                 if x1ULRef <= x1UL
%                     x1ULCount = x1ULCount + 5;
%                     x2ULCount = x2ULCount + 5;
%                     y1ULCount = y1ULCount - slpUL*5;
%                     y2ULCount = y2ULCount - slpUL*5;
%                     
%                     slpCount = slpCount + 1;
%                 end
%             elseif keycode(buttonLeftA)
%                 if x1ULRef >= x2UL
%                     x1ULCount = x1ULCount - 5;
%                     x2ULCount = x2ULCount - 5;
%                     y1ULCount = y1ULCount + slpUL*5;
%                     y2ULCount = y2ULCount + slpUL*5;
%                     
%                     slpCount = slpCount - 1;
%                 end
%             end
%             
%             [keyIsDown, secs, keycode] = KbCheck(dev_ID);
%             
%             x1ULRef = ((x1UL+x2UL)/2)-5 + x1ULCount;
%             x2ULRef = ((x1UL+x2UL)/2)+5 + x2ULCount;
%             y1ULRef = ((y1UL+y2UL)/2)-5 + y1ULCount;
%             y2ULRef = ((y1UL+y2UL)/2)+5 + y2ULCount;
%             destRectRefCirc(1,:) = [x1ULRef, y1ULRef, x2ULRef, y2ULRef];
%             
%             Screen('FillOval',w,[0 255 0], destRectRefCirc);
%             
%             Screen('Flip',w);
%             
%         end
%     end
%     
%     % Find the center of the ref circle
%     rawdata(n,4) = abs((x1ULRef+x2ULRef)/2);
%     rawdata(n,5) = abs((y1ULRef+y2ULRef)/2);
%     
%     % Find the length of the line
%     largeLine = abs(sqrt(((x1UL-x2UL)^2)+((y1UL-y2UL)^2)));
%     
%     % Find the length between the ref and the start of the line
%     smallLine = abs(sqrt(((x1UL-rawdata(n,4))^2)+((y1UL-rawdata(n,5))^2)));
%     
%     % Find the precent of the total one the small line falls on
%     rawdata(n,6) = (smallLine/largeLine)*100;
    
end

save(sprintf('%s%s',datadir,datafile),'rawdata');
save(datafile_full);

ListenChar(0);
Screen('CloseAll');
ShowCursor;


% rawdata(n,1) = circleSize (1=21, 2=36, 3=60)
% rawdata(n,2) = circleDistance (1=60, 2=36, 3=21)
% rawdata(n,3) = 1-curved 2-straight





