function histograms = compute_query_histograms(centers, key_descriptors, img_idxs)
    % Assembles bag of word for each query image (histograms). 
    % In order to do so it finds for
    % every descriptor in key_descriptors the closest center (aka
    % corresponding word).
    
    max_idx = max(img_idxs(:));
    nr_bins = size(centers, 2);
    histograms = zeros(nr_bins, max_idx);
    for img_nr = 1:max_idx
        current_img_descriptors = single(key_descriptors(:, img_idxs == img_nr));
        % Returns 'assignments' to centers.
        assignments = dsearchn(centers', current_img_descriptors');
        histograms(:, img_nr) = histc(assignments, 1:nr_bins);
    end
end
