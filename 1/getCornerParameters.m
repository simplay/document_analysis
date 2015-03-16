function [ threshold ] = getCornerParameters( preprocessingFlag )
%GETCORNERPARAMETERS get threshold boundary for given issue case
%   values have been experimentally determined.
%   @param preprocessingFlag 
% it is equal to:
%       1 if Gaussian noise detected
%       2 if Salt- and Peper noise detected
%       3 if no noise detected
%       4 if Fringes in images detected
% @return threshold lower bound for corner detection.
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

