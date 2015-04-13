%% Read file, get line and smooth image
addpath('../GCMex');
addpath('src');

USE_PRECOMPUTED = true;
filepath = 'Input/DC3/DC3.2/0012-1.jpg';
img = imread(filepath);
[M,N, ~] = size(img);
if USE_PRECOMPUTED
    load('DC3.2.0012-1.jpg.mat');
    foregroundLabels = foregroundLabels(:,:,1);
else
    foregroundLabels = imageSegmentation(img);
end
line_img = scanline_approach(foregroundLabels);
% Other term was probably resized
%line_img = imresize(line_img, [M, N]);
%foregroundLabels = imresize(foregroundLabels, [M, N]);
%% Visualize
lines_visualized = imresize(im2double(rgb2gray(img)), size(foregroundLabels));
lines_visualized(:,:,2) = foregroundLabels;
lines_visualized(:,:,3) = line_img;
% imshow(lines_visualized);

%% Extract connected components of smoothness image.
fg_bw = ~im2bw(foregroundLabels);
[labeled_font_components, num_font_components] = bwlabel(foregroundLabels);

[labeled_rows, num_rows] = bwlabel(line_img);
%% Compute convex hull, dump to file.
[~, name] = fileparts(filepath);
hulls = zeros(size(labeled_rows));
f = fopen(['Output/', name, '.txt'], 'w');
written_rows = 0;
for i = 1:num_rows
    current_row = labeled_rows == i;
    current_row_font_components = false(size(current_row));
    for j = 1:num_font_components
        jth_font_component = labeled_font_components == j;
        if sum(reshape(current_row & jth_font_component, 1, [])) > 5
            current_row_font_components = ...
                current_row_font_components | jth_font_component;
        end
    end
    if sum(current_row_font_components(:)) < 100
        continue;
    end
    % TODO: somehow correct scaling.
    [convex_hull, x_convex, y_convex] = ...
        convex_hull_bw(current_row_font_components);
    output_vector = reshape([x_convex; y_convex], 1, []);
    hulls(logical(convex_hull)) = written_rows + 1;
    fprintf(f, '%d,', i, output_vector(1:end-1));
    fprintf(f, '%d', i, output_vector(end));
    fprintf(f, '\n');
    written_rows = written_rows + 1;
end
fprintf('Found %d lines\n', written_rows);
fclose(f);
%% Visualisation
vis = double(hulls);
vis(:,:,2) = fg_bw;
vis(:,:,3) = labeled_rows;
imshow(vis);

%% Dump images
imwrite(imresize(img, size(hulls)), ['Output/', name, '_rescaled.png'])
imwrite(label2rgb(hulls, 'jet', 'w', 'shuffle'), ...
    ['Output/', name, '_convex_hulls.png']);
imwrite(fg_bw, ['Output/', name, '_foreground_bw.png']);
imwrite(labeled_rows, ['Output/', name, '_labeled_rows.png']);

%% 
hold on
plot(x_convex, y_convex, 'g');
