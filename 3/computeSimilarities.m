function [similarities, p] = computeSimilarities(histograms, compare_hist)% 
% sort similarities descending according to their for column (similarity
% value of imgs)

    nrImages = length(histograms);
    similarities = zeros(nrImages, 2);
    p = {};
    for img=1:nrImages
        %sim_mat = simmx(histograms{img}, compare_hist);
        %[p,q,D,dist] = dpfast(sim_mat);
        %[p2,q2,D2] = dp(sim_mat);
        img_hist = histograms{img};
        slot_count = size(compare_hist, 2);
        last_possible_keyword_start = size(img_hist, 2) - slot_count;
        if last_possible_keyword_start < 1
             img_hist = padarray(img_hist, ...
                 [0, abs(last_possible_keyword_start)], 0, 'post');
             last_possible_keyword_start = 1;
        end
        sims = zeros(1, last_possible_keyword_start);
        for slot_nr = 1:last_possible_keyword_start
            slot_selection = img_hist(:, (0:slot_count - 1) + slot_nr);
            C = (slot_selection - compare_hist).^2;
            sims(slot_nr) = sum(C(:));
        end
        p{img} = sims;
        similarities(img, :) = [min(sims) img];
    end
    
    [x, i] = sort(similarities(:, 1), 'ascend');
    similarities = [x, similarities(i, 2)];    
end