function [hit_words, tpr, fpr] = ...
    draw_tpr_fpr_graph(query_word, gt_strings, similarities)
%DRAW_TPR_FPR_GRAPH Draws various graphs for evaluation of the results.
%   @query_word, a string of the current query word. Should correspond to
%   its representation in gt_strings
%   @gt_strings, a cell array with the ground truth of every image in the
%   database.
%   @similarities, a matrix of the format [similarity, img_idx] sorted
%   descendingly by similarity (i. e. most similar image is at the top).
    keywords_in_manuscript = 0;
    for gt_string = gt_strings
        if any(strcmp(query_word, gt_string{1}))
            keywords_in_manuscript = keywords_in_manuscript + 1;
        end
    end
    non_keywords_in_manuscript = length(gt_strings) - keywords_in_manuscript;
    correct_count = 0;
    wrong_count = 0;
    true_positives = zeros(1, length(similarities));
    false_positives = zeros(1, length(similarities));
    hit_words = {length(similarities)};
    % Go over all similarities descendingly, compare with ground truth and
    % increment correct_count resp. wrong_count. Also computes true/false
    % positives (when pulling n-images).
    for i=1:length(similarities)
        hit_idx = similarities(i, 2);
        hit_word = gt_strings{hit_idx};
        hit_words{i} = hit_word;
        % This works for cell arrays of strings as well as single strings 
        % (Returns 'contains' in case of array)
        if any(strcmp(hit_word, query_word));
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
    [~, equal_error_rate_idx] = min(abs(1 - tpr - fpr));
    title(sprintf('%s, tpr@EER=%f, %d occurences', query_word, ...
        tpr(equal_error_rate_idx), keywords_in_manuscript));
        
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
    axis([0 1 0 1]);
    title(sprintf('%s, F1=%f, AP=%f', query_word, F_one_max, average_precision));
    
    fprintf('%s: tpr@EER=%f, AP=%f\n', ...
        query_word, tpr(equal_error_rate_idx), average_precision);
end

