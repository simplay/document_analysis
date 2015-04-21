function similarities = computeSimilarities(histograms, compare_hist)% 
% sort similarities descending according to their for column (similarity
% value of imgs)

    nrImages = length(histograms);
    similarities = zeros(nrImages, 2);
    for img=1:nrImages
        divisor = (norm(histograms(:,img) * norm(compare_hist)));
        sim = -1;
        if divisor > 0
            sim = sum(histograms(:,img).*compare_hist)/divisor;
        end 
        similarities(img, :) = [sim img];
    end
    
    [x, i] = sort(similarities(:, 1), 'descend');
    similarities = [x, similarities(i, 2)];    
end