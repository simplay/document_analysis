function [ img ] = readImgFileByName( filePathName )
%READIMGFILEBYNAME loads png input images used for classification
% assumption: shapes are white (=1), background is black (=0)
%   @param filePathName String with path and filename of target dataset.
%   @return MxN binary valued image with described color encoding.

    img = imread(strcat(filePathName, '.png'));
    % Invert image, we want background to be black.
    img = ~img;
    img = im2double(img);
end

