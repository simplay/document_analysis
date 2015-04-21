function [imgs, all_descriptors, img_idxs, db_size] = compute_descriptors(directory, imgs, all_descriptors, img_idxs)
%COMPUTE_DESCRIPTOR Takes the given directory and iterates over all png
%files within the directory. Of these images, dsift features are computed
%and appended to the given imgs, all_descriptors and img_idxs.
%   Detailed explanation goes here
h = waitbar(0,'Please wait while computing sift features...');
if isempty(img_idxs)
    current_idx = 1;
else
    current_idx = max(img_idxs) + 1;
end

files = dir([directory, '/*.png']);
for i = 1:length(files)
    filename = files(i).name;
    img = single(~imread([directory, '/', filename]))*255;
    binSize = 8;
    magnif = 8;
    img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
    [~, descriptors] = vl_dsift(img_smooth, 'size', binSize, 'step', 2);
    
    imgs = [imgs, {img}];
    all_descriptors = [all_descriptors, descriptors];
    img_idxs = [img_idxs, repmat(current_idx, [1 size(descriptors, 2)])];
    current_idx = current_idx + 1;
    waitbar(i / length(files));
end
close(h);
db_size = length(files);
end

