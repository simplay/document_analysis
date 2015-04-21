function similarities = computeSimilarities(histograms, compare_hist, nrImages)
    similarities = zeros(nrImages, 2);
    for img=1:nrImages
        sim = sum(histograms(:,img).*compare_hist)/...
            (norm(histograms(:,img) * norm(compare_hist)));
        similarities(img, :) = [sim img];
    end
    similarities = sortrows(similarities);
    similarities = flipud(similarities);
end