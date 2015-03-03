function [ out ] = restoreImg( img, N )
%RESTOREIMG Summary of this function goes here
%   Detailed explanation goes here
    g = fspecial('gaussian', max(1,fix(6*N)), N);
    
    % Smoothed squared image derivatives
    blurredImg = conv2(img, g, 'same'); 
    for k=1:10000,
        if blurredImg(k) < 0.8,
            blurredImg(k) = 0;
        else
            blurredImg(k) = 1;
        end
    end
    out = blurredImg;
end

