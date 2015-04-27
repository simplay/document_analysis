function histograms = assemble_histograms(assignments, centers, img_idxs)
%ASSEMBLE_HISTOGRAMS 
	max_idx = max(img_idxs(:));
	for img_nr = 1:max_idx
		img_assignments = assignments(img_idxs == img_nr);
		histograms(:,img_nr) = histc(img_assignments, 1:length(centers));
    end
end
