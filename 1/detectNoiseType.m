function type = detectNoiseType(img)
%DETECTNOISETYPE detect type of noise: underlying main assumption: our image is binary
%   valued.
%   @param img input 2d image can be noisy but is valued 0 or 1.
%   @return type a integer
%       1: gaussian noise
%       2: salt and peper noise
%       3: no noise detected
    
    [counts,binLocations] = imhist(img);
    % two types of buckets mean we have only values 0, 1
    % this means we either do have salt and peper noise or no noise.
    if length(binLocations(counts > 0)) == 2,
        type = 2;
        % heuristics: if there are at most 1.2 times the larger dimension
        % of an image wrong then we assume we have no noise given. 
        if abs(abs(sum(sum(medfilt2(img, [5 5])-img)))) < max(size(img))*1.1,
            disp('there is no significant noise in your image');
            type = 3;
        end
    % this corresponds to gaussian noise
    else
        type = 1;
    end
end

