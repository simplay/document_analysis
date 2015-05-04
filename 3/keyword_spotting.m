clear all
clc
run('../vlfeat/toolbox/vl_setup')
set_name = 'ParzivalDB';
FAST_CLUSTERING = false;

%% Compute DSIFT on database images
is_week2 = true;
if is_week2
    words_directory = ['Input/data-week2/', set_name, '/lines'];
    keywords_directory = ['Input/data-week2/', set_name, '/keywords'];
else
    words_directory = ['Input/', set_name, '/words'];
    keywords_directory = ['Input/', set_name, '/keywords'];
end
[imgs, all_descriptors, img_idxs, db_size] = compute_descriptors(words_directory);
disp('Done computing sift on database...');

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
% i. e. count which word occurs how many times on which image.
db_histograms = assemble_histograms(assignments, k, img_idxs);
disp('Done assembling histograms...');

%% Compute descriptors on keywords, assign to words using centers above. 
[key_imgs, key_descriptors, key_img_idxs] = compute_descriptors(keywords_directory);
query_histograms = compute_query_histograms(centers, key_descriptors, key_img_idxs);

%% Find closest match for image with given id:
if is_week2
    gt_file = fopen(['Input/data-week2/', set_name, '/lines/', 'Lines', set_name '.txt'], 'r');
else
    gt_file = fopen(['Input/', set_name, '/', set_name '.txt'], 'r');
end
gt_strings = load_gt_strings(words_directory, gt_file, is_week2);

% Expect, that the name of a query file is the word it contains.
query_files = dir([keywords_directory '/*.png']);
for i = 1:size(query_histograms, 2)
    similarities = computeSimilarities(db_histograms, query_histograms{i});
    [~, query_word] = fileparts(query_files(i).name);
    [hit_words, tpr, fpr] = draw_tpr_fpr_graph(query_word, gt_strings, similarities);
end

%% For debugging: Show query img and 5 closest matches
% top left is query
% others sorted by similarity from left to right and top to bottom.
figure
subplot(4,2,1);
queryImg = 2;
imshow(key_imgs{queryImg}, [0 255]);
[similarities, p_all, q_all] = computeSimilarities(db_histograms, query_histograms{queryImg});
hold on
% Paint matched slots on input image for first image.
for l = q_all{similarities(1, 2)}
    line([l, l]*5, [1 size(img, 2)]);
end
hold off

for topHits = 1:6
    subplot(4, 2, 2 + topHits);
    dist = similarities(topHits, 1);
    similar_img_idx = similarities(topHits, 2);
    if iscell(gt_strings{similar_img_idx})
        gt_string = strjoin(gt_strings{similar_img_idx}, '|');
    else
        gt_string = gt_strings{similar_img_idx};
    end
    fprintf('%f: %s\n', dist, gt_string);
    img = imgs{similar_img_idx};
    imshow(img, [0 255]);
    % paint a line on sentences where slots were matched to query image.
    hold on;
    for l = p_all{similar_img_idx}
        line([l, l]*5, [1 size(img, 2)]);
    end
    hold off;
end