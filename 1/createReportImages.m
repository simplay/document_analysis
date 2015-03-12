clc
clear all;
close all;
OUTPUT = 1;
%% Select position of subimage and prefix (for dumping)
if OUTPUT ==0
    img_prefix = 'square';
    filename = 'Shapes0';
    suffix = '';
    n = 5 * 100 + 1; % on x axis
    m = 1 * 100 + 1; % on y axis
elseif OUTPUT == 1
    img_prefix = 'triangle_noisy';
    filename = 'Shapes2';
    suffix = 'N2B';
    n = 9 * 100 + 1; % on x axis
    m = 1 * 100 + 1; % on y axis
end

[img_preprocessed, gt, img_full] = readImageAndGT(filename, suffix);
threshold = 0.21;
sigma = 3;

%% Compute stuff

% from constraint: given images is segmented into 100x100
% subimages.
current_range = false(size(img_full));
current_range(m:m+99, n:n+99) = true;
img = reshape(img_preprocessed(current_range), 100, 100);

dx = [-1 0 1; -1 0 1; -1 0 1]; 
dy = dx';

% Image derivatives
Ix = conv2(img, dx, 'same');    
Iy = conv2(img, dy, 'same');    

% Gaussian filter of size 6*sigma (since std +/- 3sigma ~99.99%)
% fix(...) => round to nearest integer.
g = fspecial('gaussian', max(1,fix(6*sigma)), sigma);

% Smoothed squared image derivatives
Sx2 = conv2(Ix.^2, g, 'same'); 
Sy2 = conv2(Iy.^2, g, 'same');
Sxy = conv2(Ix.*Iy, g, 'same');

% retrieve corners in subimages using a harris-corner-detector.
minBlobSizeFactor = 0.3;
[~, c, response] = corners(img, 1.0, threshold, sigma, ...
    minBlobSizeFactor);

%% Dump images
imwrite(reshape(img_full(current_range), 100, 100), [img_prefix, '.png']);
imwrite(img, [img_prefix, '_preprocessed.png'])
imwrite(Sx2, [img_prefix, '_sx2_smoothed.png'])
imwrite(Sy2, [img_prefix, '_sy2_smoothed.png'])
imwrite(Sxy, [img_prefix, '_sxy_smoothed.png'])
imwrite(response, [img_prefix, '_response.png'])

if OUTPUT == 1
    imshow(response)
    rectangle('Position',[17 42 20 20], 'LineWidth',2, 'EdgeColor','r');
    f=getframe(gca);
    response_with_rect = frame2im(f);
    % Need to crop a tiny bit
    imwrite(response_with_rect(2:101, 2:101, :), [img_prefix, '_response_with_rect.png'])
    % dump detail
    detail_response = response(42:62, 17:37);
    % resize to 100 x 100
    detail_response_big = imresize(detail_response, 5, 'nearest');
    imwrite(detail_response_big, [img_prefix, '_detail_response.png'])
end
close all
