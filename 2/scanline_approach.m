%% Compute stuff
clear all;
close all;
clc;

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
col_column_img = repmat(binary_columns, [1, size(img, 2)]);
line_img =  row_binary_img & col_column_img;

%% Visualize
lines_visualized = img;
lines_visualized(:,:,2) = line_img;
lines_visualized(:,:,3) = img;
imshow(lines_visualized);