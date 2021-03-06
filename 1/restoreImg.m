function [ out ] = restoreImg( img, N, useBilatFilter)
%RESTOREIMG Summary of this function goes here
%   Detailed explanation goes here

    % Apply thresholding to reconstruct edges.
   if useBilatFilter == true
    out = (double(im2bw(bfilt(img, 2, 2), 0.85)));
   else   
    g = fspecial('gaussian', max(1,fix(6*N)), N);
    % Smoothed squared image derivatives
    blurredImg = conv2(img, g, 'same');
    out = double(im2bw(blurredImg, 0.8));
   end
    
end

