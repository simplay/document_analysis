run('../vlfeat/toolbox/vl_setup')
set_name = 'ParzivalDB';

%% Compute DSIFT on given images
words_directory = ['Input/', set_name, '/words'];
keywords_directory = ['Input/', set_name, '/keywords'];
words_files = dir([words_directory, '/*.png']);
all_descriptors = single([]);
img_idxs = [];
h = waitbar(0,'Please wait while computing sift features...');
imgs = {};
for i = 1:length(words_files)
    filename = words_files(i).name;
    img = single(~imread([words_directory, '/', filename]))*255;
    binSize = 8 ;
    magnif = 8 ;
    img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
    [~, descriptors] = vl_dsift(img_smooth, 'size', binSize);
    
    imgs{i} = img;
    all_descriptors = [all_descriptors, descriptors];
    img_idxs = [img_idxs, repmat(i, [1 length(descriptors)])];
    waitbar(i / length(words_files));
end
disp('Done computing dsift...');
%% Cluster!
% See http://www.vlfeat.org/sandbox/overview/kmeans.html for a description
% of available algorithms for kmeans
% with k clusters
k = 1;
fast = true;
if fast
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k, ...
        'Algorithm', 'ANN', 'MaxNumComparisons', ceil(k / 50));
else
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k);
end
disp('Done clustering...');

%% find closest match for image with given id:
nrImages = max(img_idxs(:));
queryImg = 2;
histograms = assemble_histograms(assignments, centers, img_idxs);
similarities = computeSimilarities(histograms, histograms(:, queryImg), nrImages);
% delete query img itself from similarity vector
similarities(similarities(:,2) == queryImg, :) = [];

%% show query img and 5 closest matches
% top left is query
% others sorted by similarity from left to right and top to bottom.
figure
subplot(4,2,1);
imshow(imgs{queryImg}, [0 255]);
similaritiesCleaned = similarities(repmat(~isnan(similarities(:,1)), [1 2]));
similaritiesCleaned = reshape(similaritiesCleaned, [], 2);
for similarImg=1:5
    subplot(4, 2, 2 + similarImg);
    similar_img_idx = similaritiesCleaned(similarImg, 2);
    imshow(imgs{similar_img_idx}, [0 255]);
end
