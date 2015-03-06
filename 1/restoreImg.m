function [ out ] = restoreImg( img, N )
%RESTOREIMG Summary of this function goes here
%   Detailed explanation goes here
    g = fspecial('gaussian', max(1,fix(6*N)), N);
    
    % Smoothed squared image derivatives
    blurredImg = conv2(img, g, 'same');
    % Apply thresholding to reconstruct edges.
    out = double(im2bw(blurredImg, 0.8));
end

