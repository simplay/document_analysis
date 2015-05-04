function [imgs, all_descriptors, img_idxs, db_size, descriptors_per_x_pos] = ...
    compute_descriptors(directory)
%COMPUTE_DESCRIPTOR Takes the given directory and iterates over all png
%files within the directory. Of these images, dsift features are computed
%and appended to the given imgs, all_descriptors and img_idxs.
%  @directory, the directory where the images to be treated are placed in
%  (only format .png is supported)
%  @imgs, a cell of all images, read images are appended here.
%  @all_descriptors, a matrix of all descriptors, descriptors generated are
%  appended here
%  @img_idxs, a matrix that contains the corresponding image index for every
%  descriptor. Has the same length as all_descriptors.

all_descriptors = uint8([]);
img_idxs = [];
imgs = {};

handle = waitbar(0,'Please wait while computing sift features...');
current_idx = 1;

USE_DSIFT = false;

files = dir([directory, '/*.png']);
for i = 1:length(files)
    filename = files(i).name;
    img = single(~imread([directory, '/', filename]))*255;
    binSize = 20;
    magnif = 20;
    img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
    if USE_DSIFT
        [~, descriptors] = vl_dsift(img_smooth, 'size', binSize, 'step', 20);
    else
        [w, h] = size(img);
        descriptors_per_x_pos = 20;
        x_pos = repmat(5:5:h, descriptors_per_x_pos, 1);
        % Flatten, such that each x position is repeated four times sequentially.
        x_pos = x_pos(:)'; 
        y_pos = repmat(40:10:70, 1, descriptors_per_x_pos/4);
        % Scale stays the same for all.
        scale = repmat(20, 1, descriptors_per_x_pos);
        % 5 different angles 
        angle = repmat([-0.1 0.05, 0, 0.05, 0.1], 1, descriptors_per_x_pos/5); 
        frames = [x_pos; repmat([y_pos; scale; angle;], 1, ...
            size(x_pos, 2)/descriptors_per_x_pos)]; 
        [~, descriptors] = vl_sift(img_smooth, 'frames', frames);
        %[~, descriptors] = vl_sift(img_smooth, 'levels', 4, 'Magnif', 5, 'windowsize', 5);
    end
    imgs = [imgs, {img}];
    all_descriptors = [all_descriptors, descriptors];
    img_idxs = [img_idxs, repmat(current_idx, [1 size(descriptors, 2)])];
    current_idx = current_idx + 1;
    waitbar(i / length(files));
end
close(handle);
db_size = length(files);
end

