function [similarities, p, q] = computeSimilarities(histograms, compare_hist)% 
% sort similarities descending according to their for column (similarity
% value of imgs)

    nrImages = length(histograms);
    similarities = zeros(nrImages, 2);
    p = {};
    q = {};
    for img=1:nrImages
        %sim_mat = simmx(histograms{img}, compare_hist);
        %[p,q,D,dist] = dpfast(sim_mat);
        %[p2,q2,D2] = dp(sim_mat);
        [dist, p_img, q_img] = dtw(histograms{img}', compare_hist', 1);
        p{img} = p_img;
        q{img} = q_img;
        similarities(img, :) = [dist img];
    end
    
    [x, i] = sort(similarities(:, 1), 'ascend');
    similarities = [x, similarities(i, 2)];    
end