% Shape recognition
clc
clear all;
close all;

filename = 'Shapes2';
suffix = 'N2A';

useBilatFilter = 1;
isNoiseInputImage = 1;
filepathname = ['Input/', filename];
if isNoiseInputImage == 1,
    filepathname = strcat(filepathname, suffix);
end

img = imread(strcat(filepathname, '.png'));
img = ~img;
img = im2double(img);


%img = imnoise(img,'gaussian', 0, .1);

PREPROCESS = detectNoiseType(img);

% Image img is (M x N)
[M,N] = size(img); 

ground_truth_classification = textread(['Input/', filename, '.txt'], '%s');

% correct gaussian noise using a wiener filter - relying on a common
% degregation noise model:
%       given_image := conv(clean_img, blur_kernel) + noise
if (PREPROCESS == 1)
    img_preprocessed = wiener2(img,[5 5]);
% Median filter, effective against salt and pepper noise.
elseif (PREPROCESS == 2)
    img_preprocessed = medfilt2(img, [5 5]);
    img_preprocessed = restoreImg(img_preprocessed, 2.3, useBilatFilter);
else
    img_preprocessed = img;
end

%% Run analysis
idx = 1;
equalityCount = 0;
% For building confusion matrix, 80 cases with 4 possible outcomes/classes.
targets = zeros(4, 80);
outputs = zeros(4, 80);
failures = zeros(size(img));
hits = zeros(size(img));
responses = zeros(size(img));

% Iterate over all subimages of size 100x100
% and classify them. Compare classification results
% with ground truth stored in 'ground_truth_classification'

for m=1:100:M,
    for n=1:100:N,
        counter = 0;
        
        % from constraint: given images is segmented into 100x100
        % subimages.
        current_range = false(size(img));
        current_range(m:m+99, n:n+99) = true;
        subimage = reshape(img_preprocessed(current_range), 100, 100);
        % preprocess image - pre-smooth it => good results
        G = fspecial('gaussian');
        subimage = imfilter(subimage, G, 'same');
        % retrieve corners in subimages using a harris-corner-detector.
        threshold = 0.21;
        radius = 3;
        minBlobSizeFactor = 0.3;
        if (PREPROCESS == 3)
            threshold = 0.5;
            radius = 1;
        end
        [~, c, response] = corners(subimage, 1.0, threshold, radius, ...
            minBlobSizeFactor);
        
        % classify shapes in subimage.
        if length(c) < 3
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
        
        % Save for showing confusion matrix later on.
        targets(shape_to_class_nr(current_reference_solution), idx) = 1;
        outputs(shape_to_class_nr(shape_classification), idx) = 1;

        if strcmp(current_reference_solution, shape_classification)
            equalityCount = equalityCount + 1;
            hits(current_range) = subimage;
        else
            failures(current_range) = subimage;
        end
        responses(current_range) = response;
        
        disp([num2str(idx), '. ', shape_classification, ' <=> ', current_reference_solution, ...
            ' ' , num2str(length(c))])
        
        % update index counter for next iteration.
        idx = idx + 1;
    end
end
disp(['equality count: ',num2str(equalityCount)]);

%% Draw confusion matrix of classifications.
plotconfusion(targets, outputs, filepathname)
confusion_labels = {'circle' 'triangle' 'square' 'star', 'Overall'};
set(gca,'xticklabel', confusion_labels)
set(gca,'yticklabel', confusion_labels)
failure_image = responses;
failure_image(:,:,2) = hits;
failure_image(:,:,3) = failures;
figure; imshow(failure_image);

img_vs_preprocessed = img;
img_vs_preprocessed(:,:,2) = img_preprocessed;
img_vs_preprocessed(:,:,3) = zeros(size(img));
figure; imshow(img_vs_preprocessed);