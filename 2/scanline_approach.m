% A simple Run Length Smearing Algorithm (RLSA)‫‏‬ approach for finding
% lines in text.
%% Compute stuff
clear all;
close all;
clc;
%%
% Bring to range [0, 1] and grayscale, then invert so we have black = bg,
% white = fg.
img = 1 - rgb2gray(im2double(imread('Input/DC3/DC3.2/0012-1.jpg')));
sum_rows = sum(img, 1);
sum_columns = sum(img, 2);

% Convert to binary by thresholding sum values according to mean. 
thresholdFactor = 0.3;
binary_rows = sum_rows > mean(sum_rows)*thresholdFactor;
binary_columns = sum_columns > mean(sum_columns)*thresholdFactor;

row_binary_img = repmat(binary_rows, [size(img, 1), 1]);
col_binary_img = repmat(binary_columns, [1, size(img, 2)]);
line_img =  row_binary_img & col_binary_img;

%% Visualize

lines_visualized = img;
bw_smooth = ~im2bw(smoothness(:,:,1));
lines_visualized(:,:,2) = imresize((imresize(line_img, 0.2) & bw_smooth) | bw_smooth, ...
    [2800 1998]);
lines_visualized(:,:,3) = img; %line_img;
imshow(lines_visualized);