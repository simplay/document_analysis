% A simple Run Length Smearing Algorithm (RLSA)‫‏‬ approach for finding
% lines in text.
%% Compute stuff
% clear all;
% close all;
% clc;
%%
% Bring to range [0, 1] and grayscale, then invert so we have black = bg,
% white = fg.
img = 1 - rgb2gray(im2double(imread('Input/DC3/DC3.2/0012-1.jpg')));
sum_rows = sum(img, 1);
sum_columns = sum(img, 2);

% Convert to binary by thresholding sum values according to mean. 
threshold_factor_rows = -1;
threshold_factor_cols = 0.4;
binary_rows = sum_rows > mean(sum_rows)*threshold_factor_rows;
binary_columns = sum_columns > mean(sum_columns)*threshold_factor_cols;

%% Inspect runs, fill up if too small
% run_size_threshold = 5;
% run_length = 0;
% for i = 2:length(binary_columns)
%     if (binary_columns(i) == binary_columns(i-1))
%         run_length = run_length + 1;
%     else
%         if run_length < run_size_threshold
%             keyboard
%             binary_columns(i-run_length:i) = binary_columns(i);
%         else
%             run_length = 0;
%         end
%     end
% end
%% Find approach
idxs = find(binary_columns);
for i = 2:length(idxs)
    zero_count = idxs(i) - idxs(i-1) - 1;
    if (zero_count == 0 || zero_count > 10)
        continue;
    else
        binary_columns(idxs(i-1):idxs(i)) = 1;
    end
end
%% Turn into masks
row_binary_img = repmat(binary_rows, [size(img, 1), 1]);
col_binary_img = repmat(binary_columns, [1, size(img, 2)]);
line_img =  row_binary_img & col_binary_img;

%% Visualize

lines_visualized = img;
lines_visualized(:,:,2) = 0;
lines_visualized(:,:,3) = line_img;
imshow(lines_visualized);