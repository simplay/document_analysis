function [ threshold ] = getCornerParameters( preprocessingFlag )
%GETCORNERPARAMETERS Summary of this function goes here
%   Detailed explanation goes here
    if preprocessingFlag == 3,
        threshold = 0.5;
    elseif preprocessingFlag == 4
        threshold = 0.19;
    elseif preprocessingFlag == 2;
        threshold = 0.21;
    else
        threshold = 0.56;
    end
end

