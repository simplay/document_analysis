function [ threshold,  minBlobSizeFactor] = getCornerParameters( preprocessingFlag, fringeRanking)
%GETCORNERPARAMETERS get threshold boundary for given issue case
%   values have been experimentally determined (by try and error).
%   @param preprocessingFlag 
% it is equal to:
%       1 if Gaussian noise detected
%       2 if Salt- and Peper noise detected
%       3 if no noise detected
%       4 if Fringes in images detected
% @return threshold lower bound for corner detection.

    minBlobSizeFactor = 0.3;
    if preprocessingFlag == 3,
        threshold = 0.5;
    elseif preprocessingFlag == 4
        threshold = 0.19;
        % heuristics: From comparisons between many data-sets we
        % noticed that low-fringe examples exhibit a ranking 450 < r < 600
        % usually. Being a low fringe mean that we have a higher lower
        % bound for later corner detection. Idally, this value would be
        % linearly interpolated between 0.19 and 0.22 instead of applying
        % this kind of clipping scheme.
        if (fringeRanking > 450 && fringeRanking < 600)
            threshold = 0.22;
        end     
    elseif preprocessingFlag == 2;
        threshold = 0.21;
    else
        threshold = 0.56;
    end
end

