 close all
clear all

ListenChar(2);
HideCursor;

backColor = 255;
dotColor = 0;
textColor = [256, 256, 256];

KbName('UnifyKeyNames');

buttonUp = KbName('UpArrow');
buttonDown = KbName('DownArrow');
buttonLeft = KbName('LeftArrow');
buttonRight = KbName('RightArrow');
buttonEscape = KbName('Escape');
buttonOne = KbName('1!');
buttonTwo = KbName('2@');
buttonThree = KbName('3#');
buttonFour = KbName('4$');
buttonFive = KbName('5%');
buttonSix = KbName('6^');
buttonSeven = KbName('7&');
buttonEight = KbName('8*');
buttonNine = KbName('9(');
buttonR = KbName('R');
buttonT = KbName('T');
buttonLArrow = KbName(',<');
buttonRArrow = KbName('.>');
buttonColon = KbName(';:');
buttonL = KbName('L');
buttonQ = KbName('Q');
buttonE = KbName('E');
buttonD = KbName('D');
buttonZ = KbName('Z');
buttonC = KbName('C');
buttonX = KbName('X');
buttonY = KbName('Y');
buttonU = KbName('U');
buttonI = KbName('I');
buttonO = KbName('O');
buttonS = KbName('S');
buttonW = KbName('W');


% Sets the inputs to come in from the other computer
[nums, names] = GetKeyboardIndices;
dev_ID=nums(1);
con_ID=nums(1);

rect=[0 100 1024 868];     % test comps
[w,rect]=Screen('OpenWindow', 0,[backColor backColor backColor],rect,[],[],[],100);
x0 = rect(3)/2;% screen center
y0 = rect(4)/2;

% Toggle and starting values
circleSize = x0/2;
ratioSize = .6;
smallCircleSize = circleSize*ratioSize;
% distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
distanceOffset = circleSize;
distanceOffsetBig = 0;

instructions = 1;
toggleOn = 0;
refCircCount = 1;
slpCount = 0;
x1ULCount = 0;
x2ULCount = 0;
y1ULCount = 0;
y2ULCount = 0;
slpCheckUL = 1;
sideCircleCount = 0;
sideCircleColor = [0 0 0];
counter = 1;
distanceSmallCircle = 1;
distance90 = circleSize*.9;
distance90Toggle = 0;
drawToIntersect = 0;
fillInSpace = 0;
drawThree = 0;
whichDistance = 1;
variableLength = 0;
lengthExperiment = 0;
occluderToggle = 0;
roundedRectToggle = 0; 
extraRoundedRect = 0;
whiteCircles = 1;

[keyIsDown, secs, keycode] = KbCheck(dev_ID);

while ~keycode(buttonEscape)
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    
    % Toggle between circle starting at center of 90 or edge to edge with
    % big circle
    if drawThree == 0
        if keycode(buttonNine)
            if distance90Toggle == 0
                distance90Toggle = 1;
            elseif distance90Toggle == 1
                distance90Toggle = 0;
            end
            KbReleaseWait;
        end
    elseif drawThree == 1
        distance90Toggle = 0;
    end
    if distance90Toggle == 0
        extraDistance = 0;
    elseif distance90Toggle == 1
        % add the appropriate amount to the x values to shift the small circles
        extraDistance = (distance90/2)-(smallCircleSize/2);
    end
    
    
    % Calculates the tangent lines
    % Start values for the left lines
    p1=x0;
    q1U=y0-distanceOffsetBig-extraRoundedRect;
    q1D=y0+distanceOffsetBig+extraRoundedRect;
    p2=(x0-((distanceOffset/2)+smallCircleSize/2))-extraDistance-variableLength;
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
    q1U=y0+distanceOffsetBig+extraRoundedRect;
    q1D=y0-distanceOffsetBig-extraRoundedRect;
    p2=(x0+((distanceOffset/2)+smallCircleSize/2))+extraDistance+variableLength;
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
  

    %         % Fill in the rest of the space
    %         Screen('FillRect',w,[dotColor dotColor dotColor],[(x0-distanceOffset) (y0-fillRectH) (x0) (y0+fillRectH)]);
    %         Screen('FillRect',w,[dotColor dotColor dotColor],[(x0) (y0-fillRectH) (x0+distanceOffset) (y0+fillRectH)]);
    
    
    % Toggle on the drawing to intesect vs drawing to tangent
    if keycode(buttonY)
        if drawToIntersect == 0
            drawToIntersect = 1;
        elseif drawToIntersect == 1
            drawToIntersect = 0;
        end
        KbReleaseWait;
    end
    if drawToIntersect == 1
        % Calculate the intersect points of the tangent lines
        pRX1 = x1UR;
        pRX2 = x2UR;
        pRX3 = x1LR;
        pRX4 = x2LR;
        pRY1 = y1UR;
        pRY2 = y2UR;
        pRY3 = y1LR;
        pRY4 = y2LR;
        
        pLX1 = x1UL;
        pLX2 = x2UL;
        pLX3 = x1LL;
        pLX4 = x2LL;
        pLY1 = y1UL;
        pLY2 = y2UL;
        pLY3 = y1LL;
        pLY4 = y2LL;
        
        yLeftIntersect = ((((pLX1*pLY2-pLY1*pLX2)*(pLY3-pLY4))-((pLY1-pLY2)*(pLX3*pLY4-pLY3*pLX4)))...
            /(((pLX1-pLX2)*(pLY3-pLY4))-((pLY1-pLY2)*(pLX3-pLX4))));
        xLeftIntersect = ((((pLX1*pLY2-pLY1*pLX2)*(pLX3-pLX4))-((pLX1-pLX2)*(pLX3*pLY4-pLY3*pLX4)))...
            /(((pLX1-pLX2)*(pLY3-pLY4))-((pLY1-pLY2)*(pLX3-pLX4))));
        yRightIntersect = ((((pRX1*pRY2-pRY1*pRX2)*(pRY3-pRY4))-((pRY1-pRY2)*(pRX3*pRY4-pRY3*pRX4)))...
            /(((pRX1-pRX2)*(pRY3-pRY4))-((pRY1-pRY2)*(pRX3-pRX4))));
        xRightIntersect = ((((pRX1*pRY2-pRY1*pRX2)*(pRX3-pRX4))-((pRX1-pRX2)*(pRX3*pRY4-pRY3*pRX4)))...
            /(((pRX1-pRX2)*(pRY3-pRY4))-((pRY1-pRY2)*(pRX3-pRX4))));
        
        x2UR = xRightIntersect;
        x2LR = xRightIntersect;
        y2UR = yRightIntersect;
        y2LR = yRightIntersect;
        x2UL = xLeftIntersect;
        x2LL = xLeftIntersect;
        y2UL = yLeftIntersect;
        y2LL = yLeftIntersect;
    end
    
    size60 = circleSize*ratioSize;
    size36 = size60*ratioSize;
    size21 = size36*ratioSize;
    
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
    
    % If drawing the circles for the length experiment can't draw other
    % types of circles
    if keycode(buttonO)
        if lengthExperiment == 0
            lengthExperiment = 1;
        elseif lengthExperiment == 1
            lengthExperiment = 0;
        end
        KbReleaseWait;
    end
    
    % Draw either the second/third/fourth tangent circle
    % Press I to toggle drawing all three
    if keycode(buttonSix)
        whichDistance = 1;
        KbReleaseWait;
    elseif keycode(buttonSeven)
        whichDistance = 2;
        KbReleaseWait;
    elseif keycode(buttonEight)
        whichDistance = 3;
        KbReleaseWait;
    end
    if keycode(buttonI)
        if drawThree == 1
            drawThree = 0;
        elseif drawThree == 0
            drawThree = 1;
        end
        KbReleaseWait;
    end
    
    if drawThree == 1 
        x3R = x0+(distanceOffset/2)+smallCircleSize;
        y3R = y0-size36/2;
        x4R = x0+(distanceOffset/2)+smallCircleSize+(size36);
        y4R = y0+size36/2;
        x3L = x0-(distanceOffset/2)-smallCircleSize-(size36);
        y3L = y0-size36/2;
        x4L = x0-(distanceOffset/2)-smallCircleSize;
        y4L = y0+size36/2;
        
        x5R = x0+(distanceOffset/2)+smallCircleSize+size36;
        y5R = y0-size21/2;
        x6R = x0+(distanceOffset/2)+smallCircleSize+size36+size21;
        y6R = y0+size21/2;
        x5L = x0-(distanceOffset/2)-smallCircleSize-size36-size21;
        y5L = y0-size21/2;
        x6L = x0-(distanceOffset/2)-smallCircleSize-size36;
        y6L = y0+size21/2;
        variableLength = 0;
    elseif drawThree == 0
        if lengthExperiment == 1
            if whichDistance == 1
                x1R = x0+distanceOffset/2;
                y1R = (y0-(size60/2));
                x2R = x1R+size60;
                y2R = (y0+(size60/2));
                x1L = (x0-(size60))-distanceOffset/2;
                y1L = (y0-(size60/2));
                x2L = x1L+size60;
                y2L = (y0+(size60/2));
                smallCircleSize = size60;
                variableLength = 0;
            elseif whichDistance == 2
                x1R = x0+(distanceOffset/2)+size60;
                y1R = y0-size36/2;
                x2R = x0+(distanceOffset/2)+size60+(size36);
                y2R = y0+size36/2;
                x1L = x0-(distanceOffset/2)-size60-(size36);
                y1L = y0-size36/2;
                x2L = x0-(distanceOffset/2)-size60;
                y2L = y0+size36/2;
                smallCircleSize = size36;
                variableLength = size60;
            elseif whichDistance == 3
                x1R = x0+(distanceOffset/2)+size60+size36;
                y1R = y0-size21/2;
                x2R = x0+(distanceOffset/2)+size60+size36+size21;
                y2R = y0+size21/2;
                x1L = x0-(distanceOffset/2)-size60-size36-size21;
                y1L = y0-size21/2;
                x2L = x0-(distanceOffset/2)-size60-size36;
                y2L = y0+size21/2;
                smallCircleSize = size21;
                variableLength = size60+size36;
            end
        end
    end
    
    % toggle on off the filled in line space
    if keycode(buttonU)
       if fillInSpace == 1
           fillInSpace = 0;
       elseif fillInSpace == 0
           fillInSpace = 1;
       end
       KbReleaseWait;
    end
    if fillInSpace == 1
%         for j=1:4
%             if j == 1
%                 slp = abs(((y1UL-y2UL)/(x1UL-x2UL)));
%                 x1 = x2UL;
%                 x2 = x1;
%                 y1 = y2UL;
%                 y2 = y0;
%             elseif j == 2
%                 slp = abs(((y1LR-y2LR)/(x1LR-x2LR)));
%                 x1 = x2LR;
%                 x2 = x1;
%                 y1 = y2LR;
%                 y2 = y0;
%             elseif j == 3
%                 slp = abs(((y1LL-y2LL)/(x1LL-x2LL)));
%                 x1 = x2LL;
%                 x2 = x1;
%                 y1 = y2LL;
%                 y2 = y0;
%             elseif j == 4
%                 slp = abs(((y1UR-y2UR)/(x1UR-x2UR)));
%                 x1 = x2UR;
%                 x2 = x1;
%                 y1 = y2UR;
%                 y2 = y0;
%             end
%             for i=1:round(x1UL-x2UL)
%                 Screen('DrawLine',w,[dotColor dotColor dotColor],x1,y1,x2,y2,1);
%                 if j == 1
%                     x1 = x1+1;
%                     y1 = y1-slp;
%                     x2 = x1;
%                 elseif j == 2
%                     x1 = x1-1;
%                     y1 = y1+slp;
%                     x2 = x1;
%                 elseif j == 3
%                     x1 = x1+1;
%                     y1 = y1+slp;
%                     x2 = x1;
%                 elseif j == 4
%                     x1 = x1-1;
%                     y1 = y1-slp;
%                     x2 = x1;
%                 end
%             end
%         end
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1UL;x1UL,y1UL;x2UL,y2UL;x2LL,y2LL;x1LL,y1LL;x0,y1LL]);
        Screen('FillPoly',w,[dotColor dotColor dotColor], [x0,y1LR;x1LR,y1LR;x2LR,y2LR;x2UR,y2UR;x1UR,y1UR;x0,y1UR]);
    end
    
    if drawThree == 1
        Screen('FillOval',w,[dotColor dotColor dotColor],[x3R, y3R, x4R, y4R]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x3L, y3L, x4L, y4L]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x5R, y5R, x6R, y6R]);
        Screen('FillOval',w,[dotColor dotColor dotColor],[x5L, y5L, x6L, y6L]);
    end
    
    % Draw the four circles
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1T, y1T-extraRoundedRect, x2T,y2T-extraRoundedRect]);
    Screen('FillOval',w,[dotColor dotColor dotColor],[x1B, y1B+extraRoundedRect, x2B,y2B+extraRoundedRect]);
    
    Screen('FillOval',w,sideCircleColor,[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
    Screen('FillOval',w,sideCircleColor,[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
    
    if keycode(buttonW)
        if whiteCircles == 1
            whiteCircles = 0;
        elseif whiteCircles == 0
            whiteCircles = 1;
        end
        KbReleaseWait;
    end
    if whiteCircles == 1
        % Draw the four white circles
        Screen('FillOval',w,[255 255 255],[x1T+1, y1T+1, x2T-1,y2T-1]);
        Screen('FillOval',w,[255 255 255],[x1B+1, y1B+1, x2B-1,y2B-1]);
        
        Screen('FillOval',w,sideCircleColor,[x1L-extraDistance, y1L, x2L-extraDistance, y2L]);
        Screen('FillOval',w,sideCircleColor,[x1R+extraDistance, y1R, x2R+extraDistance, y2R]);
        
        Screen('FillOval',w,[255 255 255],[x1L-extraDistance+1, y1L+1, x2L-extraDistance-1, y2L-1]);
        Screen('FillOval',w,[255 255 255],[x1R+extraDistance+1, y1R+1, x2R+extraDistance-1, y2R-1]);
    end
    
%     Screen('FillRect',w,[255, 255, 255], [x1T, y1UL+5, x2T, y1LR-5]);
%     Screen('FillRect',w,[255, 255, 255], [x2UL+5, y1L, x2L, y2L]);
%     Screen('FillRect',w,[255, 255, 255], [ x1R, y1R, x2UR-5, y2R]);
    
    % Draw the dots on the tangent lines
    % Calculate the slopes of the tangent lines
    slpUL = abs(((y1UL-y2UL)/(x1UL-x2UL)));
    slpUR = abs(((y1UR-y2UR)/(x1UR-x2UR)));
    slpLL = abs(((y1LL-y2LL)/(x1LL-x2LL)));
    slpLR = abs(((y1LR-y2LR)/(x1LR-x2LR)));
    
    % Draw tangent lines between the circles
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UL,y1UL,x2UL,y2UL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LL,y1LL,x2LL,y2LL);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1UR,y1UR,x2UR,y2UR);
    Screen('DrawLine',w,[dotColor dotColor dotColor],x1LR,y1LR,x2LR,y2LR);
    
    % Toggle on off the occluding rects to just look at a quadrant
    if keycode(buttonS)
        if occluderToggle == 1
            occluderToggle = 0;
        elseif occluderToggle == 0
            occluderToggle = 1;
        end
        KbReleaseWait;
    end
    if occluderToggle == 1
        % Draw the occluding rects
        Screen('FillRect',w,[128 128 128],[x2UL, y1T, x1UL, y2B]);
        Screen('FillRect',w,[128 128 128],[x1UR, y1T, x2UR, y2B]);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Turn on the colors of the side circles and add in a square around the
    % center circle
    if keycode(buttonD)
        if sideCircleCount == 1
            sideCircleCount = 0;
        elseif sideCircleCount == 0
            sideCircleCount = 1;
        end
        KbReleaseWait;
    end
    if sideCircleCount == 1
        sideCircleColor = [255 0 0];
        Screen('FrameRect',w,[0 0 255],[x1T, y1T, x2B, y2B]);
    elseif sideCircleCount == 0
        sideCircleColor = [0 0 0];
    end
    
    % toggles on/off the ref circles
    if keycode(buttonX)
        if refCircCount == 1
            x1ULCount = 0;
            x2ULCount = 0;
            y1ULCount = 0;
            y2ULCount = 0;
            slpCount = 0;
            refCircCount = 0;
        elseif refCircCount == 0
            x1ULCount = 0;
            x2ULCount = 0;
            y1ULCount = 0;
            y2ULCount = 0;
            slpCount = 0;
            refCircCount = 1;
        end
        slpCheckUL = slpUL;
        KbReleaseWait;
    end
    
    % moves the circles along the tangent
    if keycode(buttonC)
        if x1ULRef <= x1UL
            x1ULCount = x1ULCount + 5;
            x2ULCount = x2ULCount + 5;
            y1ULCount = y1ULCount - slpUL*5;
            y2ULCount = y2ULCount - slpUL*5;
            
            slpCount = slpCount + 1;
        end
    elseif keycode(buttonZ)
        if x1ULRef >= x2UL
            x1ULCount = x1ULCount - 5;
            x2ULCount = x2ULCount - 5;
            y1ULCount = y1ULCount + slpUL*5;
            y2ULCount = y2ULCount + slpUL*5;
            
            slpCount = slpCount - 1;
        end
    end
    
    % Recalculate the position of the dots each time due to changing slopes
    % as tangent lines change
    if slpUL ~= slpCheckUL
        x1ULCount = 0;
        x2ULCount = 0;
        y1ULCount = 0;
        y2ULCount = 0;
        if slpCount >= 1
            for i = 1:slpCount
                x1ULCount = x1ULCount + 5;
                x2ULCount = x2ULCount + 5;
                y1ULCount = y1ULCount - slpUL*5;
                y2ULCount = y2ULCount - slpUL*5;
            end
        elseif slpCount <= -1
            for i = -1:slpCount
                x1ULCount = x1ULCount - 5;
                x2ULCount = x2ULCount - 5;
                y1ULCount = y1ULCount + slpUL*5;
                y2ULCount = y2ULCount + slpUL*5;
            end
        end
        slpCheckUL = slpUL;
    end
    
    % draws the ref circles
    if refCircCount == 0
        x1ULRef = ((x1UL+x2UL)/2)-5 + x1ULCount;
        x2ULRef = ((x1UL+x2UL)/2)+5 + x2ULCount;
        y1ULRef = ((y1UL+y2UL)/2)-5 + y1ULCount;
        y2ULRef = ((y1UL+y2UL)/2)+5 + y2ULCount;
        destRectRefCirc(1,:) = [x1ULRef, y1ULRef, x2ULRef, y2ULRef];
        %             destRectRefCirc(2,:) = [];
        %             destRectRefCirc(3,:) = [];
        %             destRectRefCirc(4,:) = [];
        
        Screen('FillOval',w,[0 255 0], destRectRefCirc);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Screen('Flip',w);
    
    % Up/Down & L/; increase and decrease the size of the circles
    if keycode(buttonUp)
        % Allows the increase of the small circles to a max of large
        % cirlces
        if smallCircleSize < circleSize-1
            smallCircleSize = smallCircleSize+10;
        else
            smallCircleSize = smallCircleSize;
        end
    elseif keycode(buttonDown)
        if smallCircleSize > 1
            smallCircleSize = smallCircleSize-10;
            if x0-(circleSize/2) < (x0-(smallCircleSize/2))-distanceOffset/2
                smallCircleSize = smallCircleSize + 10;
            end
        else
            smallCircleSize = smallCircleSize;
        end
    end
    if keycode(buttonL)
        if circleSize > 1
            if circleSize < smallCircleSize+1
                circleSize = circleSize;
            else
                circleSize = circleSize -1;
            end
        else
            circleSize = circleSize;
        end
    elseif keycode(buttonColon)
        if circleSize < 300
            circleSize = circleSize+1;
        else
            circleSize = circleSize;
        end
    end
    
    % Right/Left & </> increase and decrease the distance between the
    % circles (allows the left/right circles to go in up until their
    % outer 25% point hits the top/bot circles outer edge)
    if keycode(buttonRight)
        if x2R<rect(3)
            distanceOffset = distanceOffset + 5;
        else
            distanceOffset = distanceOffset;
        end
    elseif keycode(buttonLeft)
%         if x2L<x1R
            distanceOffset = distanceOffset - 5;
%         else
%             distanceOffset = distanceOffset;
%         end
    end
    if keycode(buttonRArrow)
        if distanceOffsetBig < rect(4)-circleSize
            distanceOffsetBig = distanceOffsetBig + 1;
        else
            distanceOffsetBig = distanceOffsetBig;
        end
    elseif keycode(buttonLArrow)
        if distanceOffsetBig > 1
            distanceOffsetBig = distanceOffsetBig - 1;
        else
            distanceOffsetBig = distanceOffsetBig;
        end
    end
    
    if keycode(buttonE)
        toggleOn = 1;
        KbReleaseWait;
    end

    while toggleOn == 1
        [keyIsDown, secs, keycode] = KbCheck(dev_ID);
        
        slpUL = ((y0-(circleSize/2)+distanceOffsetBig)-y0)/((x0)-(x0-distanceOffset-(smallCircleSize/2)));
        slpLL = ((y0+(circleSize/2)+distanceOffsetBig)-y0)/((x0)-(x0-distanceOffset-(smallCircleSize/2)));
        
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
        Screen('Flip',w);
        
        if keycode(buttonE)
            toggleOn = 0;
            KbReleaseWait;
        end
    end

    
    % R resets to starting
    if keycode(buttonR)
        circleSize = x0/2;
        ratioSize = .1;
        smallCircleSize = circleSize*ratioSize;
        % distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
        distanceOffset = circleSize;
        distanceOffsetBig = 0;
    end
    
    % T makes a perfect rounded rect
    if keycode(buttonT)
        if roundedRectToggle == 0
            roundedRectToggle = 1;
        elseif roundedRectToggle == 1
            reoundedRectToggle = 0;
        end
    end
    if roundedRectToggle == 1
        %         if circleSize<smallCircleSize
        %             circleSize=smallCircleSize;
        %             if distanceOffsetBig < distanceOffset
        %                 distanceOffsetBig = distanceOffset/2;
        %             else
        %                 distanceOffset = distanceOffsetBig;
        %             end
        %         else
        %             smallCircleSize = circleSize;
        %             if distanceOffsetBig < distanceOffset
        %                 distanceOffsetBig = distanceOffset/2;
        %             else
        %                 distanceOffset = distanceOffsetBig;
        %             end
        %         end
        circleSize=smallCircleSize;
        distanceOffsetBig = distanceOffset/2;
        extraRoundedRect = smallCircleSize/2;
    elseif roundedRectToggle == 0
        extraRoundedRect = 0;
    end
    %     if keycode(buttonT)
    %        smallCircleSize = circleSize;
    %        distanceOffsetBig = distanceOffset;
    %     end
    
    % 1 takes a screen shot
    if keycode(buttonOne);
        imagetemp(counter).image = Screen('GetImage',w);
        counter=counter+1;
        KbReleaseWait;
    end
    
    % Q toggles on and off directions
    if keycode(buttonQ)
        if instructions==1
            instructions=0;
        elseif instructions==0
            instructions=1;
        end
        KbReleaseWait;
    end
    
    if lengthExperiment == 0
        variableLength = 0;
        % 2-5 changes the ratio
        if keycode(buttonTwo)
            circleSize = x0/2;
            ratioSize = .15;
            smallCircleSize = circleSize*ratioSize;
            % distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
            distanceOffset = circleSize;
            distanceOffsetBig = 0;
        elseif keycode(buttonThree)
            circleSize = x0/2;
            ratioSize = .3;
            smallCircleSize = circleSize*ratioSize;
            % distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
            distanceOffset = circleSize;
            distanceOffsetBig = 0;
        elseif keycode(buttonFour)
            circleSize = x0/2;
            ratioSize = .6;
            smallCircleSize = circleSize*ratioSize;
            % distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
            distanceOffset = circleSize;
            distanceOffsetBig = 0;
        elseif keycode(buttonFive)
            circleSize = x0/2;
            ratioSize = .9;
            smallCircleSize = circleSize*ratioSize;
            % distanceOffset = ((circleSize/2)+(smallCircleSize/2))+50;
            distanceOffset = circleSize;
            distanceOffsetBig = 0;
        end
    end

if lengthExperiment == 0
    variableLength = 0;
    if keycode(buttonTwo)
        
    elseif keycode(buttonThree)
        
    elseif keycode(buttonFour)
        
    elseif keycode(buttonFive)
        
    end
end

if instructions==1
        Screen('TextSize',w,17);
        text='Up/Down & L/; increase and decrease the size of the circles';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10),[0 255 0]);
        text='Right/Left & </> increase and decrease the distance between the circles';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+20,[0 255 0]);
        text='R resets to starting position';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+40,[0 255 0]);
        text='T makes a perfect rounded rectangle';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+60,[0 255 0]);
        text='1 takes a screen shot';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+80,[0 255 0]);
        text='2-5 set the ratio to .1, .3, .6, .9';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+100,[0 255 0]);
        text='Q toggles on and off directions';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+120,[0 255 0]);
        text='D turns on the center square and changes color of side circles';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(10)+140,[0 255 0]);
        text='9 toggles between starting at 90% center position and next to center circle';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25),[0 255 0]);
        text='X toggles on the tangent line circles';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-20,[0 255 0]);
        text='C & Z move the dot up and down the line, up to the tangent point';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-40,[0 255 0]);
        text='Y toggles on drawing out to intersect vs to tangent';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-60,[0 255 0]);
        text='U toggles on off the filled in sections';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-80,[0 255 0]);
        text='O switches between experiment condition types (length and size changes)';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-100,[0 255 0]);
        text='S toggles on off the quadrant occluders';
        width=RectWidth(Screen('TextBounds',w,text));
        Screen('DrawText',w,text,(rect(3)*.65)-(width/2),(rect(4)-25)-120,[0 255 0]);
    end
    
    %     arcDistX = 20;
    %     arcDistY = 20;
    %     arcSize = 225;
    %     arcStart = 60;
    %
    %     Screen('FrameArc',w,[dotColor dotColor dotColor],[arcDistX, arcDistY, (arcDistX+(arcSize*2)), (arcDistY+arcSize)],270+arcStart,60,10);
    %     Screen('FrameArc',w,[dotColor dotColor dotColor],[arcDistX, arcDistY, (arcDistX+(arcSize*2)), (arcDistY+arcSize)],270-arcStart,-60,10);
    %     Screen('DrawLine',w,[dotColor dotColor dotColor],arcDistX+((arcDistX+(arcSize*2)))/4, ((arcDistY+arcSize)/2)+5, (arcDistX+(arcSize*2))-((arcDistX+(arcSize*2)))/4, ((arcDistY+arcSize)/2)+5,5);
    %
    %     [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    %
    %     Screen('TextSize',w,20);
    %     text='best resembles the indicated portion of the shape.';
    %     width=RectWidth(Screen('TextBounds',w,text));
    %     Screen('DrawText',w,text,(rect(3)*.75)-(width/2),(y0/3)+30,[0 0 0]);
    %     text='Which of the three line segments to the left,';
    %     width=RectWidth(Screen('TextBounds',w,text));
    %     Screen('DrawText',w,text,(rect(3)*.75)-(width/2),y0/3,[0 0 0]);
    
    
    
    [keyIsDown, secs, keycode] = KbCheck(dev_ID);
    
    
end

counter=counter-1;

for i=1:counter
    imwrite(imagetemp(i).image,sprintf('%s%d%s','lemonLargeSide',i,'.jpg'),'jpg')
end

ListenChar(0);
Screen('CloseAll');
ShowCursor;





