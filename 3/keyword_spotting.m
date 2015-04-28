clear all
clc
run('../vlfeat/toolbox/vl_setup')
set_name = 'ParzivalDB';
FAST_CLUSTERING = false;

%% Compute DSIFT on given images
is_week2 = true;
if is_week2
    words_directory = ['Input/data-week2/', set_name, '/lines'];
    keywords_directory = ['Input/data-week2/', set_name, '/keywords'];
else
    words_directory = ['Input/', set_name, '/words'];
    keywords_directory = ['Input/', set_name, '/keywords'];
end
all_descriptors = uint8([]);
img_idxs = [];
imgs = {};
[imgs, all_descriptors, img_idxs, db_size] = ...
    compute_descriptors(words_directory, imgs, all_descriptors, img_idxs);
% Information of keywords are appended to the information of other words.
[imgs, all_descriptors, img_idxs] = ...
    compute_descriptors(keywords_directory, imgs, all_descriptors, img_idxs);
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
if is_week2
    gt_file = fopen(['Input/data-week2/', set_name, '/lines', set_name '.txt'], 'r');
else
    gt_file = fopen(['Input/', set_name, '/', set_name '.txt'], 'r');
end
gt_strings = load_gt_strings(set_name, words_directory, gt_file, is_week2);
query_histograms = histograms(:, db_size + 1:end);
db_histograms = histograms(:, 1:db_size);
% Images/descriptors etc are at the end of this array
% Query words must be alphabetically sorted, UPPERCASE COME FIRST.
if strcmp(set_name, 'ParzivalDB')
    query_words = {{'A-r-t-v-s'}, {'G-r-a-l-s'}, {'d-a-z'}, {'k-v-n-e-g-i-n-n-e'}};
else
    query_words = {{'O-c-t-o-b-e-r'}, {'s-o-o-n'}, {'t-h-a-t'}};
end
for i = 1:size(query_histograms, 2)
    similarities = computeSimilarities(db_histograms, query_histograms(:, i));
    query_word = query_words{i};
    hit_words = draw_tpr_fpr_graph(query_word, gt_strings, similarities);
end

%% For debugging: Show query img and 5 closest matches
% top left is query
% others sorted by similarity from left to right and top to bottom.
figure
subplot(4,2,1);
queryImg = 2;
imshow(imgs{queryImg + db_size}, [0 255]);
similarities = computeSimilarities(db_histograms, query_histograms(:, queryImg));
for topHits = 1:6
    subplot(4, 2, 2 + topHits);
    similar_img_idx = similarities(topHits, 2);
    disp(gt_strings{similar_img_idx});
    imshow(imgs{similar_img_idx}, [0 255]);
end
