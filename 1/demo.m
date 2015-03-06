% Shape recognition
clc
clear all;
close all;

%filename = 'Shapes2N2A';
filename = 'Shapes0';
suffix = '_noisy';
suffix = '';

isNoiseInputImage = 1;
filepathname = ['Input/', filename];
if isNoiseInputImage == 1,
    filepathname = strcat(filepathname, suffix);
end

img = imread(strcat(filepathname, '.png'));
img = ~img;
img = im2double(img);


img = imnoise(img,'gaussian', 0, .1);

PREPROCESS = detectNoiseType(img);

% Image img is (M x N)
[M,N] = size(img); 

ground_truth_classification = textread(['Input/', filename, '.txt'], '%s');

% correct gaussian noise using a wiener filter - relying on a common
% degregation noise model:
%       given_image := conv(clean_img, blur_kernel) + noise
if (PREPROCESS == 1)
    img_preprocessed = wiener2(img,[5 5]);
% median filter
elseif (PREPROCESS == 2)
    img_preprocessed = medfilt2(img, [5 5]);
else
    img_preprocessed = img;
end

imshow(img_preprocessed)
idx = 1;
equalityCount = 0;
% Iterate over all subimages of size 100x100
% and classify them. Compare classification results
% with ground truth stored in 'ground_truth_classification'
for m=1:100:M,
    for n=1:100:N,
        counter = 0;
        
        % from constraint: given images is segmented into 100x100
        % subimages.
        subimage = img_preprocessed(m:m+99, n:n+99);
        if(PREPROCESS == 2) 
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

