% DOCUMENT ANALYSIS PROJECT 2
% Stefan Moser, Michael Single
% Please use the prespecified default settings.

%% Read file, get line and smooth image
addpath('../GCMex');
addpath('src');

% what DC data set should be used: Integer from 1 .. 5
DATA_SET_NR = 5; 

% should we use precomputed data in order to speed up computation?
USE_PRECOMPUTED = true;

% should a user select new foreground and background masks to estimate a
% new color model? Only considered in case USE_PRECOMPUTED is true
SPECIFY_CUES = false;

% image downscaling factor to speed up computation 
DOWNSCALE_FACTOR = 5;

% show some debugging information
VERBOSE = false;

mat_idx = 0;
[filepaths, dc_mat_files] = loadDataSetData(DATA_SET_NR);
for filepath_cell = filepaths
    mat_idx = mat_idx + 1;
    filepath = filepath_cell{1};
    img = imread(filepath);
    [M,N, ~] = size(img);
    
    if USE_PRECOMPUTED
        if DATA_SET_NR == 5
            load(dc_mat_files{mat_idx});
        else
            load(dc_mat_files{1});   
        end      
        foregroundLabels = foregroundLabels(:,:,1);
    else
        img = im2double(imresize(img, 1 / DOWNSCALE_FACTOR));
        img = 1 - img;
        [foregroundLabels, smoothness] = imageSegmentation(img, SPECIFY_CUES, VERBOSE);
    end
    
    % preprocessing steps for dc 5 data-set
    % use smoothness term instead extracted foreground
    % apply appropriate prprocessing
    if DATA_SET_NR == 5
        % artifact free blur kernel applied to smoothness term
        % removes noise from data set (background page noise encoded in smoothness)
        H = fspecial('disk',10);
        blurredSmoothness = imfilter(smoothness,H,'replicate');
        
        % threshold blurred smoothness to mask text blocks extracted
        % from smoothness image.
        smoothnessPostMask = ((1-blurredSmoothness) > 0.4);
        
        % along page boundaries there are perceptually notable
        % artifcats present: assume there is no text on the page border
        % thus mask this out.
        zeroBorderWidth = 5;
        boundaryMask = ones(size(smoothnessPostMask));
        boundaryMask(1:zeroBorderWidth,:) = 0;
        boundaryMask(end-zeroBorderWidth:end,:) = 0;
        boundaryMask(:,1:zeroBorderWidth) = 0;
        boundaryMask(:,end-zeroBorderWidth:end) = 0;
        
        thresholdedSmoothness = ((1-smoothness) > 0.85);
        foregroundLabels = thresholdedSmoothness .* smoothnessPostMask .* boundaryMask;
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