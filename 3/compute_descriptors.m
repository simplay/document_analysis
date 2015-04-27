function [imgs, all_descriptors, img_idxs, db_size] = ...
    compute_descriptors(directory, imgs, all_descriptors, img_idxs)
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

h = waitbar(0,'Please wait while computing sift features...');
if isempty(img_idxs)
    current_idx = 1;
else
    current_idx = max(img_idxs) + 1;
end

USE_DSIFT = true;

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
        [~, descriptors] = vl_sift(img_smooth, 'levels', 4, 'Magnif', 5, 'windowsize', 5);
    end
    imgs = [imgs, {img}];
    all_descriptors = [all_descriptors, descriptors];
    img_idxs = [img_idxs, repmat(current_idx, [1 size(descriptors, 2)])];
    current_idx = current_idx + 1;
    waitbar(i / length(files));
end
close(h);
db_size = length(files);
end

