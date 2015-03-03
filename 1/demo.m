% shape recognition
clc
clear all;
close all;

img = imread('Input/Shapes1.png');
img = ~img;
img = im2double(img);


% Image img is (M x N)
[M,N] = size(img); 

% Traverse Imgae: image consists of 100 x 100 pixels subimages:
slice = ones(100,1);
solution = textread('Input/Shapes0.txt','%s');

idx = 1;
equalityCount = 0;
% iterate over all subimages and classify.
for m=1:100:M,
    for n=1:100:N,
        counter = 0;
        subimage = img(m:m+99, n:n+99);
        
        % preprocess image - pre-smooth it => good results
        G = fspecial('gaussian');
        subimage = imfilter(subimage,G,'same');
        
        % retrieve edges using a harris corner detector.
        [~,c] = corners(subimage, 1.0, 0.5, 1);
        shape = '';
        if length(c) == 0,
            shape = 'circle';
        elseif length(c) == 3
            shape = 'triangle';
        elseif length(c) == 4,
            shape = 'square';
        else
            shape = 'star';
        end
        
        current_solution = strjoin(solution(idx));
        equalityCount = equalityCount + strcmp(current_solution, shape);
        disp([num2str(idx), '. ' ,shape, '<=>' ,current_solution, ' ' , num2str(strcmp(current_solution, shape))])
        idx = idx + 1;
    end
end
disp(['equality count: ',num2str(equalityCount)]);

