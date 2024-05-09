% rawdata(n,1) = 1=lemon 2=diamond 3=rounded square 4=square
% rawdata(n,2) = responded it was curved(1) or straight(2)

close all
clear all

keyNum = 2;

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'lemonVsDiamond';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');
if keyNum == 1
    datadir = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment 1/Data/';
elseif keyNum == 2
    datadir = '/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment 2/Data/';
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
dev_ID=nums(2);
con_ID=nums(1);

buttonEscape = KbName('Escape');
buttonLeft = KbName('LeftShift');
buttonRight = KbName('RightShift');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test

stimTypeList = [1 2 3 4]; %1=lemon 2=diamond 3=rounded square 4=square
nStimType = length(stimTypeList);
nTrials = 20;

variableList = repmat(fullyfact([nStimType]),[nTrials,1]);
trialOrder = randperm(length(variableList));
numTrials = nTrials*nStimType;

circleSize = x0/2;
ratioSize = .3;
smallCircleSize = circleSize*ratioSize;
distanceOffset = circleSize;
distanceOffsetBig = 0;
distance2Object = 45;

distance90 = circleSize*.9;
% extraDistance = (distance90/2)-(smallCircleSize/2);
extraDistance = 0;

% Calculates the tangent lines
% Start values for the left lines
p1=x0;
q1U=y0-distanceOffsetBig;
q1D=y0+distanceOffsetBig;
p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
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
p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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

% Drawing the arrays for the arc and line
% Making sure only values of 128 and 0 are in the array
if keyNum == 1
    imageArc = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment2/Code/Arc','jpeg');
elseif keyNum == 2
    imageArc = imread('/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment2/Code/Arc','jpeg');
end
imageArc = imread('Arc','jpeg');
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
    imageLine = imread('/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Experiment2/Code/Straight','jpeg');
elseif keyNum == 2
    imageLine = imread('/Volumes/C-Lab_HomeDir/Google Drive/Lab Projects/Lemon Illusion/Experiment2/Code/Straight','jpeg');
end
imageLine = imread('Straight','jpeg');
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
Screen('DrawText',w,text,x0-tWidth/2,y0-250,textColor);
text='Also, four pair of lines will appear, corresponding to the sides fo the object.'; 
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-200,textColor);
text='One pair will be straight and one slightly curved.';; 
tWidth=RectWidth(Screen('TextBounds',w,text));
Screen('DrawText',w,text,x0-tWidth/2,y0-150,textColor);
Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
Screen('Flip',w);
KbWait(dev_ID);
KbReleaseWait(dev_ID);

[keyIsDown, secs, keycode] = KbCheck(dev_ID);
for n=1:4
    
    stimTypePrac = [1 2 3 4];
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    circleSize = x0/2;
    smallCircleSize = circleSize*ratioSize;
    distanceOffset = circleSize;
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
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
    q1U=y0-distanceOffsetBig;
    q1D=y0+distanceOffsetBig;
    p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
    
    x1T = x0-(circleSize/2);
    x2T = x0+(circleSize/2);
    y1T = y0-(circleSize/2)-distanceOffsetBig;
    y2T = y0+(circleSize/2)-distanceOffsetBig;
    x1B = x0-(circleSize/2);
    x2B = x0+(circleSize/2);
    y1B = y0-(circleSize/2)+distanceOffsetBig;
    y2B = y0+(circleSize/2)+distanceOffsetBig;
    
    x1R = x0+distanceOffset/2;
    y1R = (y0-(smallCircleSize/2));
    x2R = x1R+smallCircleSize;
    y2R = (y0+(smallCircleSize/2));
    x1L = (x0-(smallCircleSize))-distanceOffset/2;
    y1L = (y0-(smallCircleSize/2));
    x2L = x1L+smallCircleSize;
    y2L = (y0+(smallCircleSize/2));
    
    if stimTypePrac(n) == 1
        % Draw the three circles
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T, x2T,y2T]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B, x2B,y2B]);
        
        Screen('FillOval',w,[0 0 0],[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
        Screen('FillOval',w,[0 0 0],[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
        
        % Draw tangent lines between the circles
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
    elseif stimTypePrac(n) == 2
        
        x1D=x0-distanceOffset-(smallCircleSize/2);
        x2D=x1D;
        y1D=y0;
        y2D=y1D;
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x1L-extraDistance, y1L+smallCircleSize/2;...
            x1T+circleSize/2, y1T-extraDistance-smallCircleSize/2; x2R+extraDistance, y2R-smallCircleSize/2;...
            x2B-circleSize/2,y2B+extraDistance+smallCircleSize/2]);
    elseif stimTypePrac(n) == 3
        circleSize=smallCircleSize;
        distanceOffsetBig = distanceOffset/2;
        
        %         extraDistance = (distance90/2)-(smallCircleSize/2);
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        q1D=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
        q2=y0;
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
        q1U=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        q1D=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));
        
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T-extraDistance-smallCircleSize/2, x2T,y2T-extraDistance-smallCircleSize/2]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B+extraDistance+smallCircleSize/2, x2B,y2B+extraDistance+smallCircleSize/2]);
        
        Screen('FillOval',w,[0 0 0],[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
        Screen('FillOval',w,[0 0 0],[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
        
        % Draw tangent lines between the circles
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
        
    elseif stimTypePrac(n) == 4
        circleSize=smallCircleSize;
        distanceOffsetBig = distanceOffset/2;
        
        %         extraDistance = (distance90/2)-(smallCircleSize/2);
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        q1D=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
        q2=y0;
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
        q1U=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        q1D=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x1L-extraDistance, y1L+smallCircleSize/2;...
            x1T+circleSize/2, y1T-extraDistance-smallCircleSize/2; x2R+extraDistance, y2R-smallCircleSize/2;...
            x2B-circleSize/2,y2B+extraDistance+smallCircleSize/2]);
        
        
    end
    
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
[keyIsDown, secs, keycode] = KbCheck(dev_ID);
for n=1:numTrials
    
    % Will it be a diamond or lemon (1=lemon 2=diamond 3=rounded square 4=square)
    stimTypeIdx=variableList(trialOrder(n),1);
    stimTypeVal=stimTypeList(stimTypeIdx);
    rawdata(n,1)=stimTypeVal;
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    if stimTypeVal == 1
        
        circleSize = x0/2;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig;
        q1D=y0+distanceOffsetBig;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
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
        q1U=y0-distanceOffsetBig;
        q1D=y0+distanceOffsetBig;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));
        
        % Draw the three circles
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T, x2T,y2T]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B, x2B,y2B]);
        
        Screen('FillOval',w,[0 0 0],[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
        Screen('FillOval',w,[0 0 0],[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
        
        % Draw tangent lines between the circles
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
        
    elseif stimTypeVal == 2
        
        circleSize = x0/2;
        smallCircleSize = circleSize*ratioSize;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig;
        q1D=y0+distanceOffsetBig;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
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
        q1U=y0-distanceOffsetBig;
        q1D=y0+distanceOffsetBig;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));

        Screen('FillPoly',w,[dotColor dotColor dotColor], [x1L-extraDistance, y1L+smallCircleSize/2;...
            x1T+circleSize/2, y1T-extraDistance-smallCircleSize/2; x2R+extraDistance, y2R-smallCircleSize/2;...
            x2B-circleSize/2,y2B+extraDistance+smallCircleSize/2]);
        
    elseif stimTypeVal == 3
        
        circleSize=smallCircleSize;
        distanceOffsetBig = distanceOffset/2;
        
        %         extraDistance = (distance90/2)-(smallCircleSize/2);
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        q1D=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
        q2=y0;
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
        q1U=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        q1D=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));
        
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T-extraDistance-smallCircleSize/2, x2T,y2T-extraDistance-smallCircleSize/2]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B+extraDistance+smallCircleSize/2, x2B,y2B+extraDistance+smallCircleSize/2]);
        
        Screen('FillOval',w,[0 0 0],[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
        Screen('FillOval',w,[0 0 0],[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
        
        % Draw tangent lines between the circles
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
        Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
        
    elseif stimTypeVal == 4
        
        circleSize=smallCircleSize;
        distanceOffsetBig = distanceOffset/2;
        
        %         extraDistance = (distance90/2)-(smallCircleSize/2);
        
        % Calculates the tangent lines
        % Start values for the left lines
        p1=x0;
        q1U=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        q1D=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance;
        q2=y0;
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
        q1U=y0+distanceOffsetBig+extraDistance+smallCircleSize/2;
        q1D=y0-distanceOffsetBig-extraDistance-smallCircleSize/2;
        p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance;
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
        
        x1T = x0-(circleSize/2);
        x2T = x0+(circleSize/2);
        y1T = y0-(circleSize/2)-distanceOffsetBig;
        y2T = y0+(circleSize/2)-distanceOffsetBig;
        x1B = x0-(circleSize/2);
        x2B = x0+(circleSize/2);
        y1B = y0-(circleSize/2)+distanceOffsetBig;
        y2B = y0+(circleSize/2)+distanceOffsetBig;
        
        x1R = x0+distanceOffset/2;
        y1R = (y0-(smallCircleSize/2));
        x2R = x1R+smallCircleSize;
        y2R = (y0+(smallCircleSize/2));
        x1L = (x0-(smallCircleSize))-distanceOffset/2;
        y1L = (y0-(smallCircleSize/2));
        x2L = x1L+smallCircleSize;
        y2L = (y0+(smallCircleSize/2));
        
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x1L-extraDistance, y1L+smallCircleSize/2;...
            x1T+circleSize/2, y1T-extraDistance-smallCircleSize/2; x2R+extraDistance, y2R-smallCircleSize/2;...
            x2B-circleSize/2,y2B+extraDistance+smallCircleSize/2]);
        
        
    end
    
    
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
    
    % Rawdata(n,2) = 1(curve away) 2(curve close)
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    while 1
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        if keycode(buttonLeft) % responded it was curved
            rawdata(n,2) = 1;
            break
        elseif keycode(buttonRight) % responded it was straight
            rawdata(n,2) = 2;
            break
        end
    end
    KbWait(dev_ID);
    KbReleaseWait(dev_ID);
    
end

save(sprintf('%s%s',datadir,datafile),'rawdata');
save(datafile_full);

ListenChar(0);
Screen('CloseAll');
ShowCursor;



% rawdata(n,1) = 1=lemon 2=diamond 3=rounded square 4=square
% rawdata(n,3) = responded it was curved(1) or straight(2)




