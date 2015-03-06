% Shape recognition
clc
clear all;
close all;

%filename = 'Shapes2N2A';
filename = 'Shapes0';
suffix = '_noisy';
suffix = '';


filepathname = ['Input/', filename];
if PREPROCESS == 1 || PREPROCESS == 2,
    filepathname = strcat(filepathname, suffix);
end

img = imread(strcat(filepathname, '.png'));
img = ~img;
img = im2double(img);


%img = imnoise(img,'gaussian', 0, 1);

PREPROCESS = detectNoiseType(img);


% Image img is (M x N)
[M,N] = size(img); 

% Traverse Image: image consists of 100 x 100 pixels subimages:
ground_truth_classification = textread(['Input/', filename, '.txt'], '%s');

idx = 1;
equalityCount = 0;

% Gaussian noise correction
if (PREPROCESS == 1)
    se = strel('diamond',1);
    img_dil = imdilate(img, se);
    se = strel('diamond',2);
    img_preprocessed = imerode(img_dil,se);
    
% median filter
elseif (PREPROCESS == 2)
    img_preprocessed = medfilt2(img, [5 5]);
else
    img_preprocessed = img;
end
imshow(img_preprocessed)
% iterate over all subimages and classify them. Compare classified results
% with given solution stored in ''
for m=1:100:M,
    for n=1:100:N,
        counter = 0;
        keyboard
        % from constraint: given images is segmented into 100x100
        % subimages.
        subimage = img_preprocessed(m:m+99, n:n+99);
        if(PREPROCESS == 1 || PREPROCESS == 2) 
            subimage = restoreImg(subimage, 2.3);
        end
        % preprocess image - pre-smooth it => good results
        G = fspecial('gaussian');
        subimage = imfilter(subimage, G, 'same');
        % retrieve corners in subimages using a harris-corner-detector.
        threshold = 0.24;
        radius = 3;
        if (PREPROCESS == 3)
            threshold = 0.5;
            radius = 1;
        end
        [~, c] = corners(subimage, 1.0, threshold, radius);
        
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
            ' ' , num2str(length(c))])
        
        % update index counter for next iteration.
        idx = idx + 1;
    end
end
disp(['equality count: ',num2str(equalityCount)]);

