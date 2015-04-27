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
    figure
    subplot(1,2,1)
    tpr = true_positives ./ keywords_in_manuscript;
    fpr = false_positives ./ non_keywords_in_manuscript;
    plot(fpr, tpr);
    xlabel('False positive rate');
    ylabel('True positive rate');
    title(sprintf('%s, %d occurences', query_word{1}, keywords_in_manuscript));
    
    [~, equal_error_rate_idx] = min(abs(1 - tpr - fpr));
    fprintf('%s: At EER point, we have tpr: %f, fpr: %f\n', ...
        query_word{1}, tpr(equal_error_rate_idx), fpr(equal_error_rate_idx));
    
    subplot(1,2,2)
    recall = tpr;
    precision = true_positives ./ ...
         (true_positives + false_positives);
    F_one = 2 * recall .* precision ./ (precision + recall);
    F_one_max = max(F_one);
    % Compute area below graph:
    average_precision = trapz(recall,precision);
    plot(recall, precision);    
    xlabel('Recall');
    ylabel('Precision');
    title(sprintf('%s, F1=%f, AP=%f', query_word{1}, F_one_max, average_precision));
end

