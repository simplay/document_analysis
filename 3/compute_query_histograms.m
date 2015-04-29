function histograms = compute_query_histograms(centers, key_descriptors, img_idxs)
    % Assembles bag of word for each query image (histograms). 
    % In order to do so it finds for
    % every descriptor in key_descriptors the closest center (aka
    % corresponding word).
    
    max_idx = max(img_idxs(:));
    nr_bins = size(centers, 2);
    descriptors_per_slot = 8;
    histograms = {};
    for img_nr = 1:max_idx
        current_img_descriptors = single(key_descriptors(:, img_idxs == img_nr));
        % Returns 'assignments' to centers.
        assignments = dsearchn(centers', current_img_descriptors');
        for slot_nr = 0:length(assignments)/descriptors_per_slot - 1
            slot_start = slot_nr*descriptors_per_slot + 1;
            slot_end = slot_start + descriptors_per_slot - 1;
            histograms{img_nr}(:,slot_nr + 1) = histc(assignments(slot_start:slot_end), 1:nr_bins);
        end
    end
end
