clear all
clc
run('../vlfeat/toolbox/vl_setup')
set_name = 'WashingtonDB';
FAST_CLUSTERING = true;
%% Compute DSIFT on given images
words_directory = ['Input/', set_name, '/words'];
keywords_directory = ['Input/', set_name, '/keywords'];
all_descriptors = uint8([]);
img_idxs = [];
imgs = {};
[imgs, all_descriptors, img_idxs, db_size] = compute_descriptors(words_directory, imgs, all_descriptors, img_idxs);
% Information of keywords are appended to the information of other words.
[imgs, all_descriptors, img_idxs] = compute_descriptors(keywords_directory, imgs, all_descriptors, img_idxs);
disp('Done computing dsift...');
%% Cluster!
% See http://www.vlfeat.org/sandbox/overview/kmeans.html for a description
% of available algorithms for kmeans
% k = number of clusters
k = 50;
if FAST_CLUSTERING
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k, ...
        'Algorithm', 'ANN', 'MaxNumComparisons', ceil(k / 50));
else
    [centers, assignments, energy] = vl_kmeans(single(all_descriptors), k);
end
disp('Done clustering...');
%% Assemble histograms for computing similarities later on.
histograms = assemble_histograms(assignments, centers, img_idxs);
disp('Done assembling histograms...');
%% find closest match for image with given id:
gt_strings = load_gt_strings(set_name, words_directory);
query_histograms = histograms(:, db_size + 1:end);
db_histograms = histograms(:, 1:db_size);
% Images/descriptors etc are at the end of this array
if strcmp(set_name, 'ParzivalDB')
    query_words = {{'A-r-t-v-s'}, {'d-a-z'}, {'G-r-a-l-s'}, {'k-v-n-e-g-i-n-n-e'}};
else
    query_words = {{'O-c-t-o-b-e-r'}, {'s-o-o-n'}, {'t-h-a-t'}};
end
for i = 1:size(query_histograms, 2)
    similarities = computeSimilarities(db_histograms, query_histograms(:, i));
    % Images/descriptors etc are at the end of this array
    % TODO: Resolve issues with NaN
    similaritiesCleaned = similarities(repmat(~isnan(similarities(:,1)), [1 2]));
    similaritiesCleaned = reshape(similaritiesCleaned, [], 2);
    query_word = query_words{i};
    figure
    draw_tpr_fpr_graph(query_word, gt_strings, similaritiesCleaned);
end

%% For debugging: Show query img and 5 closest matches
% top left is query
% others sorted by similarity from left to right and top to bottom.
figure
subplot(4,2,1);
queryImg = 1002;
imshow(imgs{queryImg}, [0 255]);
similarities = computeSimilarities(db_histograms, query_histograms(:, queryImg - 1000));
similaritiesCleaned = similarities(repmat(~isnan(similarities(:,1)), [1 2]));
similaritiesCleaned = reshape(similaritiesCleaned, [], 2);
for similarImg=1:5
    subplot(4, 2, 2 + similarImg);
    similar_img_idx = similaritiesCleaned(similarImg, 2);
    disp(gt_strings{similar_img_idx});
    imshow(imgs{similar_img_idx}, [0 255]);
end
