function [hit_words, tpr, fpr] = draw_tpr_fpr_graph(query_word, gt_strings, similarities )
%DRAW_TPR_FPR_GRAPH Summary of this function goes here
%   Detailed explanation goes here
    keywords_in_manuscript = length(find(strcmp(query_word, gt_strings)));
    non_keywords_in_manuscript = length(gt_strings) - keywords_in_manuscript;
    correct_count = 0;
    wrong_count = 0;
    correct_incorrect = zeros(2, length(similarities));
    hit_words = {length(similarities)};
    for i=1:length(similarities)
        hit_idx = similarities(i, 2);
        hit_word = gt_strings{hit_idx};
        hit_words{i} = hit_word;
        if hit_idx <= 1000 && strcmp(hit_word, query_word);
            correct_count = correct_count + 1;
        else
            wrong_count = wrong_count + 1;
        end
        correct_incorrect(:, i) = [correct_count wrong_count];
    end

    tpr = correct_incorrect(1, :) ./ keywords_in_manuscript;
    fpr = correct_incorrect(2, :) ./ non_keywords_in_manuscript;
    plot(fpr, tpr);
    xlabel('False positive rate');
    ylabel('True positive rate');
    title(query_word)
end

