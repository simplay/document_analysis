function histograms = assemble_histograms(assignments, nr_bins, img_idxs, descriptors_per_slot)
%ASSEMBLE_HISTOGRAMS 
	max_idx = max(img_idxs(:));
    histograms = {};
	for img_nr = 1:max_idx
		img_assignments = assignments(img_idxs == img_nr);
        for slot_nr = 0:length(img_assignments)/descriptors_per_slot - 1
            slot_start = slot_nr*descriptors_per_slot + 1;
            slot_end = slot_start + descriptors_per_slot - 1;
            histograms{img_nr}(:,slot_nr + 1) = histc(img_assignments(slot_start:slot_end), 1:nr_bins);
        end
	end
end
