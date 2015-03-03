% Shape recognition
clc
clear all;
close all;

filename = 'Shapes1';

img = imread(['Input/', filename, '.png']);
img = ~img;
img = im2double(img);

% Image img is (M x N)
[M,N] = size(img); 

% Traverse Image: image consists of 100 x 100 pixels subimages:
ground_truth_classification = textread(['Input/', filename, '.txt'], '%s');

idx = 1;
equalityCount = 0;
% iterate over all subimages and classify them. Compare classified results
% with given solution stored in ''
for m=1:100:M,
    for n=1:100:N,
        counter = 0;
        
        % from constraint: given images is segmented into 100x100
        % subimages.
        subimage = img(m:m+99, n:n+99);
        
        % preprocess image - pre-smooth it => good results
        G = fspecial('gaussian');
        subimage = imfilter(subimage, G, 'same');
        
        % retrieve corners in subimages using a harris-corner-detector.
        [~, c] = corners(subimage, 1.0, 0.5, 1);
        
        % classify shapes in subimage.
        shape_classification = '';
        if length(c) == 0,
            shape_classification = 'circle';
        elseif length(c) == 3
            shape_classification = 'triangle';
        elseif length(c) == 4,
            shape_classification = 'square';
        else
            shape_classification = 'star';
        end
        
        % report results from current iteration.
        current_reference_solution = strjoin(ground_truth_classification(idx));
        
        equalityCount = equalityCount + ... 
            strcmp(current_reference_solution, shape_classification);
        
        disp([num2str(idx), '. ', shape_classification, '<=>', current_reference_solution, ...
            ' ' , num2str(strcmp(current_reference_solution, shape_classification))])
        
        % update index counter for next iteration.
        idx = idx + 1;
    end
end
disp(['equality count: ',num2str(equalityCount)]);

