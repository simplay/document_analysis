% test our detector for all known data sets

% Info: our detector returns a
%       1: gaussian noise
%       2: salt and peper noise
%       3: no noise detected
%       4: fringes in images detected

%% clean data set
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Clean_Validation')), 3);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes0')), 3);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes1')), 3);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes2')), 3);

%% fringe data sets
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Border_Heavy_Validation')),4);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Border_Medium_Validation')),4);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Border_Easy_Validation')),4);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes2N2B')),4);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes1N1')),4);

%% Salt % Pepper data sets
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Noise_Easy_Validation')),2);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Noise_Medium_Validation')),2);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes_Noise_Heavy_Validation')),2);
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes0_noisy')),2);

%% hard: Salt & Pepper noise with small fringes.
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes2N2A')),2);

%% Gaussian noise detection.
testShouldBe(detectNoiseType(readImgFileByName('Input/Shapes0_gaussian_noise')),1);
