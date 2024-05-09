function [x1T, y1T, x2T, y2T,...
    x1B, y1B, x2B, y2B,...
    x1L, y1L, x2L, y2L,...
    x1R, y1R, x2R, y2R,...
    x1UL,y1UL,x2UL,y2UL,...
    x1LL,y1LL,x2LL,y2LL,...
    x1UR,y1UR,x2UR,y2UR,...
    x1LR,y1LR,x2LR,y2LR] =...
    drawLemon(circleSize, smallCircleSize, distanceOffsetBig, distanceOffset, x0, y0)

% The function for drawing the lemon
% Inputs: the size of the large circle and the 
% small circle, and the distance between the side circles and center circles
% Outputs: x & y coordinates for the upper left and bottom right of all
% 4 circles, coordinates of the 4 tangent lines
% [x1T, y1T, x2T, y2T, x1B, y1B, x2B, y2B, x1L, y1L, x2L, y2L, x1R,
% y1R, x2R, y2R] = drawLemon(circleSize, ratio, distanceCenter,
% distanceSide)

% Calculates the tangent lines
% Start values for the left lines
p1=x0;
q1U=y0-distanceOffsetBig;
q1D=y0+distanceOffsetBig;
p2=(x0-((distanceOffset/2)+smallCircleSize/2));
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

% Start values for the right tangent lines
p1=x0;
q1U=y0+distanceOffsetBig;
q1D=y0-distanceOffsetBig;
p2=(x0+((distanceOffset/2)+smallCircleSize/2));
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

% Variables for the top and botton of the circles (T=top circle
% B=bottom etc.)
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










