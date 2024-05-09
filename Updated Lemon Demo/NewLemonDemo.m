close all
clear all

ListenChar(2);
HideCursor;

Screen('Preference', 'SkipSyncTests', 1);

backColor = [255 255 255];
dotColor = [0 0 0];
textColor = [256, 256, 256];
sideCircleColor = [0 0 0];

KbName('UnifyKeyNames');

% rect=[0 100 1024 868];     % test comps
[w,rect]=Screen('OpenWindow', 0,backColor,[],[],[],[],100);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

% Toggle and starting values
circleSize = x0/2;  % Center circle starts as a quarter of the width of the screen
ratioSize = .2; % Side circles start as a precentage of the center circle
smallCircleSize = circleSize*ratioSize;
% distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
distanceOffset = circleSize; % The length of the distance between the centers of the side circles
distanceOffsetBig = 0; % The length of the distance between the centers of the center circles

innerSize = 10; % How this do you want the outline to be
counter = 0; % Counter for the saved screen shot array
outlineToggle = 1; % Toggles on or off the outline 1=on
sideCircleToggle = 0;
sizeValueToggle = 1;
noFillToggle = 0;

buttonEscape = KbName('Escape');
buttonOne = KbName('1!');
buttonLeftArrow = KbName('LeftArrow');
buttonRightArrow = KbName('RightArrow');
buttonUpArrow = KbName('UpArrow');
buttonDownArrow = KbName('DownArrow');
buttonLeftCarrot = KbName(',<');
buttonRightCarrot = KbName('.>');
buttonU = KbName('U');
buttonI = KbName('I');
buttonQ = KbName('Q');
buttonW = KbName('W');
buttonD = KbName('D');
buttonF = KbName('F');

[keyIsDown, secs, keycode] = KbCheck;

while ~keycode(buttonEscape)
    
    [keyIsDown, secs, keycode] = KbCheck;
    
    % 1 takes a screen shot
    if keycode(buttonOne);
        ListenChar(0)
        screenCapture(w,[]);
        ListenChar(2)
    end
    %% Move the lemons parts
    % left/right arrow will move the side circles towards and away from the
    % inner circle. The max the circles can move inward is until their outer
    % edge touches the edge of the center circle. The max they can move
    % outward is until their outer edge touches the edges of the screen.
    if keycode(buttonLeftArrow)
        [keyIsDown, secs, keycode] = KbCheck;
        % Check to make sure that the value of the outer edge of the side circles does not
        % exceed the value of center circle.
        if x1L <= x1T
            % Increase the value of distance offset
            distanceOffset = distanceOffset - 2;
        end
    end
    
    if keycode(buttonRightArrow)
        [keyIsDown, secs, keycode] = KbCheck;
        % Check to make sure that the value of the outer edge of the side
        % circles does not exceed the edges of the screen
        if x1L >= 0
            distanceOffset = distanceOffset + 2;
        end
    end
    
    %% Change the size of the lemon
    % up/down arrow will increase and decrease the size of the side
    % circles. The largest they can get is the same size as the center
    % circle (100% of the circle). The smallest they can get is 5% of the
    % center circle.
    if keycode(buttonUpArrow)
        [keyIsDown, secs, keycode] = KbCheck;
        % check size of sides to make sure they never exceed the center
        if y1L > y1T && x1L >0
            ratioSize = ratioSize+.01;
        end
    end
    
    if keycode(buttonDownArrow)
        [keyIsDown, secs, keycode] = KbCheck;
        % check size of sides to make sure they never exceed the center
        if ratioSize > .04
            ratioSize = ratioSize-.01;
        end
    end
    
    % Toggle on/off the display for the ratio size of the side circles
    if keycode(buttonD)
        if sizeValueToggle == 1
            sizeValueToggle = 0;
        elseif sizeValueToggle == 0
            sizeValueToggle = 1;
        end
        KbReleaseWait;
    end
    if sizeValueToggle == 1
        Screen('TextSize',w,17);
        text=num2str(ratioSize*100);
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10),[0 255 0]);
    end
    
    % Increase the size of the overall lemon by increasing the size of the
    % center circle.
    if keycode(buttonLeftCarrot)
        [keyIsDown, secs, keycode] = KbCheck;
        
        % Calculates the added difference between the circles due to user
        % input (if any)
        distanceDifference = distanceOffset-circleSize;
        if y1T > 0 && x1L > 0
            circleSize = circleSize + 5;
        end
        
        % Calculates the new distance offset based on the new circle size
        % and the difference of offset from user input
        distanceOffset = distanceDifference+circleSize;
    end
    if keycode(buttonRightCarrot)
        [keyIsDown, secs, keycode] = KbCheck;
        
        % Calculates the added difference between the circles due to user
        % input (if any)
        distanceDifference = distanceOffset-circleSize;
        if circleSize > x0/6
            circleSize = circleSize - 5;
        end
        
        % Calculates the new distance offset based on the new circle size
        % and the difference of offset from user input
        distanceOffset = distanceDifference+circleSize;
    end
    
%% Toggle on the second side circle
    if keycode(buttonI)
        if sideCircleToggle == 1
            sideCircleToggle = 0;
        elseif sideCircleToggle == 0
            sideCircleToggle = 1;
        end
        KbReleaseWait;
    end
    
%% Toggle on circle outlines
    if keycode(buttonF)
        if noFillToggle == 1
            noFillToggle = 0;
        elseif noFillToggle == 0
            noFillToggle = 1;
        end
        KbReleaseWait;
    end
    
%% Draw the lemons
    % The function for drawing the lemon
    % Inputs: the size of the large circle and the
    % small circle, and the distance between the side circles and center circles
    % Outputs: x & y coordinates for the upper left and bottom right of all
    % 4 circles, coordinates of the 4 tangent lines
    % [x1T, y1T, x2T, y2T, x1B, y1B, x2B, y2B, x1L, y1L, x2L, y2L, x1R,
    % y1R, x2R, y2R] = drawLemon(circleSize, ratio, distanceCenter,
    % distanceSide)
    smallCircleSize = ratioSize*circleSize;
    
    [x1T, y1T, x2T, y2T,...
        x1B, y1B, x2B, y2B,...
        x1L, y1L, x2L, y2L,...
        x1R, y1R, x2R, y2R,...
        x1UL,y1UL,x2UL,y2UL,...
        x1LL,y1LL,x2LL,y2LL,...
        x1UR,y1UR,x2UR,y2UR,...
        x1LR,y1LR,x2LR,y2LR] = ...
        drawLemon(circleSize, smallCircleSize, distanceOffsetBig, distanceOffset, x0, y0);
    
    Screen('FillPoly',w,dotColor, [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
    if sideCircleToggle == 1
        Screen('FillPoly',w,dotColor, [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
    end
    
    Screen('FillOval',w,dotColor,[x1L, y1L, x2L, y2L]);
    if sideCircleToggle == 1
        Screen('FillOval',w,dotColor,[x1R, y1R, x2R, y2R]);
    end
    
    Screen('FillOval',w,dotColor,[x1T, y1T, x2T, y2T]);
    Screen('FillOval',w,dotColor,[x1B, y1B, x2B, y2B]);
    
    
    %% Draw and manipulate the Outline
    % Toggle on or off the outline
    if keycode(buttonU)
        if outlineToggle == 1
            outlineToggle = 0;
        elseif outlineToggle == 0
            outlineToggle = 1;
        end
        KbReleaseWait;
    end
    
    % Increase/decrease the width of the outline. Minimum 5 pixels with a
    % maximum of 50.
    if keycode(buttonW)
        if innerSize <= 50
            innerSize = innerSize + 1;
        end
    end
    
    if keycode(buttonQ)
        if innerSize >= 1
            innerSize = innerSize-1;
        end
    end
    
    
    % Draws another lemon on top of the original in the same color as the
    % background
    % Determine the coordinates of the new lemon (shrink the lemon by some
    % amount)
    if outlineToggle == 1
        circleSizeOutline = circleSize-innerSize;
        smallCircleSize = smallCircleSize-innerSize;
        distanceOffsetOutline = distanceOffset+innerSize;
        distanceOffsetBigOutline = 0;
        
        [x1TO, y1TO, x2TO, y2TO,...
            x1BO, y1BO, x2BO, y2BO,...
            x1LO, y1LO, x2LO, y2LO,...
            x1RO, y1RO, x2RO, y2RO,...
            x1ULO,y1ULO,x2ULO,y2ULO,...
            x1LLO,y1LLO,x2LLO,y2LLO,...
            x1URO,y1URO,x2URO,y2URO,...
            x1LRO,y1LRO,x2LRO,y2LRO] = ...
            drawLemon(circleSizeOutline, smallCircleSize, distanceOffsetBigOutline, distanceOffsetOutline, x0, y0);
        
        % Draws the inner areas between the circles
        % if you want just the circles and tangents take out the fill and draw
        % just lines at the same thickness as the in width of the outline
        
        
        Screen('FillPoly',w,backColor, [x0,y1ULO;x1ULO,y1ULO;x2ULO,y2ULO;x2LLO,y2LLO;x1LLO,y1LLO;x0,y1LLO]);
        if sideCircleToggle == 1
            Screen('FillPoly',w,backColor, [x0,y1LRO;x1LRO,y1LRO;x2LRO,y2LRO;x2URO,y2URO;x1URO,y1URO;x0,y1URO]);
        end
        
        
        % Must redraw the black circle ontop of the filled poly to just
        % draw the circles and tangents
        if noFillToggle == 0
            Screen('FillOval',w,dotColor,[x1T, y1T, x2T, y2T]);
            Screen('FillOval',w,dotColor,[x1B, y1B, x2B, y2B]);
            Screen('FillOval',w,dotColor,[x1L, y1L, x2L, y2L]);
            if sideCircleToggle == 1
                Screen('FillOval',w,dotColor,[x1R, y1R, x2R, y2R]);
            end
        end
        
        Screen('FillOval',w,backColor,[x1TO, y1TO, x2TO, y2TO]);
        Screen('FillOval',w,backColor,[x1BO, y1BO, x2BO, y2BO]);
        
        Screen('FillOval',w,backColor,[x1LO, y1LO, x2LO, y2LO]);
        if sideCircleToggle == 1
            Screen('FillOval',w,backColor,[x1RO, y1RO, x2RO, y2RO]);
        end
        
    end
    
    
    Screen('Flip',w);
    
    
end

sca
ListenChar(0);
ShowCursor;







