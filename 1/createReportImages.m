clc
clear all;
close all;
OUTPUT = 0;
%% Select position of subimage and prefix (for dumping)
if OUTPUT ==0
    img_prefix = 'square';
    filename = 'Shapes0';
    suffix = '';
    n = 5 * 100 + 1; % on x axis
    m = 1 * 100 + 1; % on y axis
elseif OUTPUT == 1
    img_prefix = 'square_noisy';
    filename = 'Shapes_Noise_Heavy_Validation';
    suffix = '';
    n = 6 * 100 + 1; % on x axis
    m = 4 * 100 + 1; % on y axis
end

[img_preprocessed, gt, img_full] = readImageAndGT(filename, suffix, false);
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
    window_size = 20;
    pos = [47 62 window_size window_size];
    rectangle('Position', pos , 'LineWidth',2, 'EdgeColor','r');
    f=getframe(gca);
    response_with_rect = frame2im(f);
    % Need to crop a tiny bit
    imwrite(response_with_rect(2:101, 2:101, :), [img_prefix, '_response_with_rect.png'])
    
    % dump detail
    detail_response = response(pos(2):(pos(2) + window_size - 1), pos(1):(pos(1)+window_size - 1));
    % resize to 100 x 100
    detail_response_big = imresize(detail_response, 5, 'nearest');
    imshow(detail_response_big)
    rectangle('Position', [2 2 98 98] , 'LineWidth',2, 'EdgeColor','r');
    f=getframe(gca);
    detail_with_rect = frame2im(f);
    % Need to crop a tiny bit
    imwrite(detail_with_rect(2:101, 2:101, :), [img_prefix, '_detail_response.png'])
end
close all

%% Comparison gaussian vs bilateral blur on fringes.
filename = 'Input/Shapes2N2A';
suffix = '';
img_full = readImgFileByName(filename);

m = 6*100 + 1;
n = 0*100 + 1;

current_range = false(size(img_full));
current_range(m:m+99, n:n+99) = true;
img = reshape(img_full(current_range), 100, 100);
spatial_sigma = 2;
img_bilat_smoothed = im2bw(bfilt(img, spatial_sigma, 2), 0.8);
g = fspecial('gaussian', max(1,fix(6*spatial_sigma)), spatial_sigma);
img_gaussian_smoothed = im2bw(imfilter(img, g), 0.8);
prefix = 'smoothing_comparison';

imwrite(img, [prefix, '_original.png']);
imwrite(img_bilat_smoothed, [prefix, '_bilat.png']);
imwrite(img_gaussian_smoothed, [prefix, '_gauss.png']);

diff = im2double(img_bilat_smoothed);
diff(:,:,2) = im2double(img_gaussian_smoothed);
diff(:,:,3) = 0;
imshow(diff);

%% Dump all primitive shapes

filename = 'Input/Shapes0';
img_full = readImgFileByName(filename);

for i = 1:80 
    [x, y] = ind2sub([8, 10], i);
    x = (x-1) * 100 + 1;
    y = (y-1) * 100 + 1;
    imwrite(img_full(x:x+99, y:y+99), [num2str(i), '.png']);
end

%% Dump shape under different noise conditions

filename = 'Input/Shapes1';
img_full = readImgFileByName(filename);

m = 3*100 + 1;
n = 3*100 + 1;
img_clean = img_full(m:m+99, n:n+99);
imwrite(img_clean, 'noise_types_clean.png');

img_salt_n_pepper = imnoise(img_clean, 'salt & pepper', 0.1);
imwrite(img_salt_n_pepper, 'noise_types_snp.png');

img_gaussian = imnoise(im2double(img_clean),'gaussian', 0, .1);
imwrite(img_gaussian, 'noise_types_gaussian.png');

filename = 'Input/Shapes1N1';
img_full = readImgFileByName(filename);
img_fringe = img_full(m:m+99, n:n+99);
imwrite(img_fringe, 'noise_types_fringe.png');

