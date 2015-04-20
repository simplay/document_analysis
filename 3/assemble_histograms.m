function histograms = assemble_histograms(assignments, centers, img_idxs)
	max_idx = max(img_idxs(:));
	for img = 1:max_idx
		  img_assignments = assignments(img_idxs == img);
		  histograms(:,img) = histc(img_assignments, 1:length(centers));
end
