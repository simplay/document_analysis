%% Read file, get line and smooth image
addpath('../GCMex');
addpath('src');

USE_PRECOMPUTED = false;
DOWNSCALE_FACTOR = 5;
VERBOSE = false;

filepaths = { ...
    'Input/DC3/DC3.1/0005-1.jpg', ...
    'Input/DC3/DC3.1/0013-4.jpg', ...
    'Input/DC3/DC3.1/0018-7.jpg', ...
    'Input/DC3/DC3.1/0027-7.jpg', ... % Extremely narrow human writing.
    'Input/DC3/DC3.2/0004-8.jpg', ...
    'Input/DC3/DC3.2/0012-1.jpg', ... % Machine & Human writing
    'Input/DC3/hard/8528e_lg1.jpg', ... 
    'Input/DC3/hard/8528e_lg2.jpg', ... 
    };

for filepath_cell = filepaths
    filepath = filepath_cell{1};
    img = imread(filepath);
    [M,N, ~] = size(img);
    if USE_PRECOMPUTED
        load('DC3.2.0012-1.jpg.mat');
        foregroundLabels = foregroundLabels(:,:,1);
    else
        img = im2double(imresize(img, 1 / DOWNSCALE_FACTOR));
        img = 1 - img;
        foregroundLabels = imageSegmentation(img, true, VERBOSE);
    end
    line_img = scanline_approach(foregroundLabels);

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
        container = {};
        idx = 1;
        current_row = labeled_rows == i;
        current_row_font_components = false(size(current_row));
        for j = 1:num_font_components
            jth_font_component = labeled_font_components == j;
            if sum(reshape(current_row & jth_font_component, 1, [])) > 1
                current_row_font_components = ...
                    current_row_font_components | jth_font_component;
                % Remove this component, so it's not reassigned.
                target = labeled_font_components == j;
                labeled_font_components(target) = 0;

                container{idx} = {{target}, {j}};
                idx = idx + 1;
            end
        end
        if sum(current_row_font_components(:)) < 100
            % if line is rejected, erased components should be
            % reintroduced  
            for k=1:length(container)
                labeled_font_components(container{k}{1}{1}) = container{k}{2}{1};
            end

            continue;
        end
        [convex_hull, x_convex, y_convex] = ...
            convex_hull_bw(current_row_font_components);
        output_vector = reshape([x_convex; y_convex], 1, []);
        % Rescale to real size, shift by one pixel so that top left = (0,0).
        output_vector = (output_vector - 1) * DOWNSCALE_FACTOR;
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
    imwrite(label2rgb(labeled_rows, 'jet', 'w', 'shuffle'), ...
        ['Output/', name, '_labeled_rows.png']);
end