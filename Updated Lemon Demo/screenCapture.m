function [] = screenCapture(w, name)
% This function will capture whatever is on the screen and save it to the
% current folder
% Input: The screen number, name of image (if empty leave as [])

if isempty(name) % If no predefined name ask user for one manually
    name = input('What is the name of the image: ','s');  % Asks user for name of saved image
end

imArray.image = Screen('GetImage',w);
imwrite(imArray.image,name,'jpg')

