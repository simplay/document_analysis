function [ img_preprocessed, gt, img ] = readImageAndGT(filename, suffix, useGaussianNoise)
%READIMAGEANDGT Returns a preprocessed image and the ground truth
    useBilatFilter = 1;
    filepathname = ['Input/', filename];
    filepathname = strcat(filepathname, suffix);
    
    img = readImgFileByName(filepathname);

    if (useGaussianNoise == 1) img = imnoise(img,'gaussian', 0, .1); end

    PREPROCESS = detectNoiseType(img);
    % Image img is (M x N)

    gt = textread(['Input/', filename, '.txt'], '%s');

    % correct gaussian noise using a wiener filter - relying on a common
    % degregation noise model:
    %       given_image := conv(clean_img, blur_kernel) + noise
    if (PREPROCESS == 1)
        img_preprocessed = wiener2(img,[5 5]);
    % Median filter, effective against salt and pepper noise.
    elseif (PREPROCESS == 2)
        img_preprocessed = medfilt2(img, [5 5]);
        img_preprocessed = restoreImg(img_preprocessed, 2.3, useBilatFilter);
    else
        img_preprocessed = img;
    end

    % preprocess image for sobel edge detector - pre-smooth it => good results
    G = fspecial('gaussian');
    img_preprocessed = imfilter(img_preprocessed, G, 'same');

end

