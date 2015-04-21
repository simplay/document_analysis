function [hit_words, tpr, fpr] = draw_tpr_fpr_graph(query_word, gt_strings, similarities )
%DRAW_TPR_FPR_GRAPH Summary of this function goes here
%   Detailed explanation goes here
    keywords_in_manuscript = length(find(strcmp(query_word, gt_strings)));
    non_keywords_in_manuscript = length(gt_strings) - keywords_in_manuscript;
    correct_count = 0;
    wrong_count = 0;
    true_positives = zeros(1, length(similarities));
    false_positives = zeros(1, length(similarities));
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
        true_positives(i) = correct_count;
        false_positives(i) = wrong_count;
    end

    tpr = true_positives ./ keywords_in_manuscript;
    fpr = false_positives ./ non_keywords_in_manuscript;
    plot(fpr, tpr);
    xlabel('False positive rate');
    ylabel('True positive rate');
    title(query_word)
    
    recall = tpr;
    precision = true_positives ./ ...
        (true_positives + false_positives);
    plot(recall, precision, '.');    
    xlabel('Recall');
    ylabel('Precision');
    title(query_word);
end

