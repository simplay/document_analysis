run('../vlfeat/toolbox/vl_setup')
set_name = 'ParzivalDB';
FAST_CLUSTERING = true;

%% Compute DSIFT on given images
words_directory = ['Input/', set_name, '/words'];
keywords_directory = ['Input/', set_name, '/keywords'];
all_descriptors = uint8([]);
img_idxs = [];
imgs = {};
[imgs, all_descriptors, img_idxs] = compute_descriptors(words_directory, imgs, all_descriptors, img_idxs);
[imgs, all_descriptors, img_idxs] = compute_descriptors(keywords_directory, imgs, all_descriptors, img_idxs);
disp('Done computing dsift...');
%% Cluster!
% See http://www.vlfeat.org/sandbox/overview/kmeans.html for a description
% of available algorithms for kmeans
% with k clusters
k = 50;
if FAST_CLUSTERING
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k, ...
        'Algorithm', 'ANN', 'MaxNumComparisons', ceil(k / 50));
else
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k);
end
disp('Done clustering...');

%% find closest match for image with given id:
nrImages = max(img_idxs(:));
queryImg = 1001;
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

%% Evaluation
Stuff = {{'A-r-t-v-s'}, {'d-a-z'}, {'G-r-a-l-s'}, {'k-v-n-e-g-i-n-n-e'}};