% rawdata(n,1) = lemon(1) or diamond(2)
% rawdata(n,2) = line order (1=curve away 2=cuve close)
% rawdata(n,3) = responded it was curved(1) or straight(2)
% rawdata(n,4) = does it match the stim (1) or not (2)

close all
clear all

c = clock;
time_stamp = sprintf('%02d/%02d/%04d %02d:%02d:%02.0f',c(2),c(3),c(1),c(4),c(5),c(6)); % month/day/year hour:min:sec
datecode = datestr(now,'mmddyy');
experiment = 'lemon';

% get input
subjid = input('Enter Subject Code:','s');
runid  = input('Enter Run:');
% datadir = '/Users/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/';
datadir = '/Volumes/C-Lab/Google Drive/Lab Projects/Lemon Illusion/Data/';

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
dev_ID=nums(2);
con_ID=nums(1);

buttonEscape = KbName('Escape');
buttonLeft = KbName('LeftShift');
buttonRight = KbName('RightShift');

stimTypeList = [1 2]; %1=lemon 2=diamond in future 3=rounded square
nStimType = length(stimTypeList);
nTrials = 15;

variableList = repmat(fullyfact([nStimType]),[nTrials,1]);
trialOrder = randperm(length(variableList));
numTrials = nTrials*nStimType;

circleSize = x0/2;
ratioSize = .1;
smallCircleSize = circleSize*ratioSize;
distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
distanceOffsetBig = 0;
distance2Object = 45;

% Calculates the tangent lines
% Start values for the left lines
p1=x0;
q1U=y0-distanceOffsetBig;
q1D=y0+distanceOffsetBig;
p2=x0-distanceOffset;
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
p2=x0+distanceOffset;
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

slpUL = ((y0-(circleSize/2)+distanceOffsetBig)-y0)/((x0)-(x0-distanceOffset-(smallCircleSize/2)));
slpLL = ((y0+(circleSize/2)+distanceOffsetBig)-y0)/((x0)-(x0-distanceOffset-(smallCircleSize/2)));

x1D=x0-distanceOffset-(smallCircleSize/2);
x2D=x1D;
y1D=y0;
y2D=y1D;

% Drawing the arrays for the arc and line
% Making sure only values of 128 and 0 are in the array
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
for n=1:4
    
    stimTypePrac = [1 2 1 2];
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    if stimTypePrac(n) == 1
        % Draw the three circles
        Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)-distanceOffsetBig, x0+(circleSize/2),...
            y0+(circleSize/2)-distanceOffsetBig]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)+distanceOffsetBig, x0+(circleSize/2),...
            y0+(circleSize/2)+distanceOffsetBig]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))-distanceOffset,...
            (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))-distanceOffset,...
            (y0+(smallCircleSize/2))]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))+distanceOffset,...
            (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))+distanceOffset,...
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
        
    elseif stimTypePrac(n) == 2
        
        x1D=x0-distanceOffset-(smallCircleSize/2);
        x2D=x1D;
        y1D=y0;
        y2D=y1D;
        for j=1:2
            for i=1:round((x0)-(x0-distanceOffset-(smallCircleSize/2)))
                Screen('DrawLine',w,[dotColor dotColor dotColor],x1D,y1D,x2D,y2D,1);
                if j==1
                    x1D=x1D+1;
                    x2D=x1D;
                    
                    y1D = y1D+slpUL;
                    y2D = y2D+slpLL;
                elseif j==2
                    x1D=x1D+1;
                    x2D=x1D;
                    
                    y1D = y1D+slpLL;
                    y2D = y2D+slpUL;
                end
            end
        end
    end
    
    Screen('Flip',w);
    WaitSecs(.5);
    
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
    
    % Will it be a diamond or lemon (1=lemon 2=diamond)
    stimTypeIdx=variableList(trialOrder(n),1);
    stimTypeVal=stimTypeList(stimTypeIdx);
    rawdata(n,1)=stimTypeVal;
    
    Screen('FillOval',w, [256 0 0], [x0-4, y0-4, x0+4, y0+4]);      % fixation
    Screen('FillOval',w, [0 0 0], [x0-2, y0-2, x0+2, y0+2]);
    Screen('Flip',w);
    WaitSecs(.5);
    
    if stimTypeVal == 1
        % Draw the three circles
        Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)-distanceOffsetBig, x0+(circleSize/2),...
            y0+(circleSize/2)-distanceOffsetBig]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x0-(circleSize/2), y0-(circleSize/2)+distanceOffsetBig, x0+(circleSize/2),...
            y0+(circleSize/2)+distanceOffsetBig]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))-distanceOffset,...
            (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))-distanceOffset,...
            (y0+(smallCircleSize/2))]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[(x0-(smallCircleSize/2))+distanceOffset,...
            (y0-(smallCircleSize/2)), (x0+(smallCircleSize/2))+distanceOffset,...
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
        
    elseif stimTypeVal == 2
        
        x1D=x0-distanceOffset-(smallCircleSize/2);
        x2D=x1D;
        y1D=y0;
        y2D=y1D;
        for j=1:2
            for i=1:round((x0)-(x0-distanceOffset-(smallCircleSize/2)))
                Screen('DrawLine',w,[dotColor dotColor dotColor],x1D,y1D,x2D,y2D,1);
                if j==1
                    x1D=x1D+1;
                    x2D=x1D;
                    
                    y1D = y1D+slpUL;
                    y2D = y2D+slpLL;
                elseif j==2
                    x1D=x1D+1;
                    x2D=x1D;
                    
                    y1D = y1D+slpLL;
                    y2D = y2D+slpUL;
                end
            end
        end
    end
    
    Screen('Flip',w);
    WaitSecs(.5);
    
    
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
            rawdata(n,2) = 1;   
            break
        elseif keycode(buttonRight) % responded it was straight
            rawdata(n,2) = 2;   
            break
        end
    end
    KbWait(dev_ID);
    KbReleaseWait(dev_ID);
    
    % rawdata(n,1) = 1(curved) 2(straight)
    if rawdata(n,2) == 1  % they said it was curved
        if rawdata(n,1) == 1  % it was a lemon
            rawdata(n,3) = 1;  % correct
        else                    % it was a diamond
            rawdata(n,3) = 0; % incorrect
        end
    else    % they said it was straight
        if rawdata(n,1) == 1   % it was a lemon
            rawdata(n,3) = 0;  % correct
        else                    % it was a diamond
            rawdata(n,3) = 1; % incorrect
        end
    end
    
end

% rawdata(n,1) = lemon(1) or diamond(2)
% rawdata(n,2) = responded it was curved(1) or straight(2)
% rawdata(n,3) = does it match the stim (1) or not (2)

save(sprintf('%s%s',datadir,datafile),'rawdata');
save(datafile_full);

ListenChar(0);
Screen('CloseAll');
ShowCursor;








