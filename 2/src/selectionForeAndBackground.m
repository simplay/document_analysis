function [ foregroundMask, backgroundMask ] = selectionForeAndBackground( img )
%SELECTIONFOREANDBACKGROUND Summary of this function goes here
%   Detailed explanation goes here
    % show image

    foregroundMask = zeros(size(img,1), size(img,2));
    backgroundMask = zeros(size(img,1), size(img,2));
    figure('Position', [100, 100, 1024, 800], ...
           'name', 'Fore-and Background Mask Selection')
       
    imshow(img);
    while true
        inputText = strcat('Type one of the following strings: \n', ...
            '''f'' for masking the foreground (in green) \n', ...
            '''b'' for masking the background (in blue) \n', ...
            '''e'' for exiting the masking procedure \n',...
            'INPUT: ');
        userInput = input(inputText);
        switch userInput
        case 'f'
            handle = imfreehand;
            handle.setColor('green');
            mask = handle.createMask();
            foregroundMask = or(foregroundMask, mask);
        case 'b'
            handle = imfreehand;
            handle.setColor('blue');
            mask = handle.createMask();
            backgroundMask = or(backgroundMask, mask);
        case 'e'
            break;
        end
    end
    
end
