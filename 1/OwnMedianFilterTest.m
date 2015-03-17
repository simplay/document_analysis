

    img = readImgFileByName('Input/Shapes_Noise_Heavy_Validation');
    img1 = ownMedianFilter(img, 5);
    del = img1-medfilt2(img, [5 5]);
    testShouldBe(sum(abs(del(:)))<2000, 1);


