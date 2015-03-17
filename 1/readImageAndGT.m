function [ img_preprocessed, gt, img, PREPROCESS, fringeRanking ] = readImageAndGT(filename, suffix, useGaussianNoise)
%READIMAGEANDGT Returns a preprocessed image and the ground truth
    filepathname = ['Input/', filename];
    filepathname = strcat(filepathname, suffix);
    
    img = readImgFileByName(filepathname);

    if (useGaussianNoise == 1) img = imnoise(img,'gaussian', 0, .1); end

    [PREPROCESS, fringeRanking] = detectNoiseType(img);
    % Image img is (M x N)

    gt = textread(['Input/', filename, '.txt'], '%s');
    G = fspecial('gaussian');
    % correct gaussian noise using a wiener filter - relying on a common
    % degregation noise model:
    %       given_image := conv(clean_img, blur_kernel) + noise
    if (PREPROCESS == 1)
        img_preprocessed = wiener2(img,[5 5]);
        G = fspecial('gaussian',[5 5], 1);
    % Median filter, effective against salt and pepper noise.
    elseif (PREPROCESS == 4)
        img_preprocessed = restoreImg(img, 2.3, false);
    elseif (PREPROCESS == 2)
        img_preprocessed = medfilt2(img, [5 5]);
        
        % img_preprocessed = ownMedianFilter(img, 5);
        
        img_preprocessed = restoreImg(img_preprocessed, 2.3, true);
    elseif (PREPROCESS == 3)
        img_preprocessed = img;
    end

    % preprocess image for sobel edge detector - pre-smooth it => good results
    img_preprocessed = imfilter(img_preprocessed, G, 'same');
    if (PREPROCESS == 1)
        img_preprocessed = double(im2bw(img_preprocessed, 0.5));
    end
end

