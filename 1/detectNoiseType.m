function type = detectNoiseType(img)
%DETECTNOISETYPE detect type of noise: underlying main assumption: our image is binary
%   valued. In order to apply an appropriate pre-processing we first have
%   to detect the corresponding type of issue. this detection is done by
%   applying a series of combinatorial heuristics. The main idea is to
%   compare a given image with a certain preprocessed version of itself. If
%   the diff is large enoug, we assume that the image suffers from that
%   particular kind of issue (noise or fringes). Note that it is very
%   important to first be able to detect whether a image suffers from some
%   median shift issues (i.e. salt & pepper noise) and only then try to
%   decide it is really a salt & pepper issue case (or rather a fringe
%   case). fringes are detected by applying an edge restauration algorithm.
%   this is done by smoothing out all edges. the result is an image of
%   "thick" edges that are smoothed out. we then apply a thresholding: if
%   the smoothed pixelvalue is below some epsilon value, we set it to zero
%   (pixel does not belong to edge). otherwise it is set to 1 (belongs to
%   edge). this guarantees a continuous edge reconstruction. the then use
%   this iamge as a AND-Mask and apply it to the original. if the
%   difference is too great (sum of pixels in and-ed image), then we assume
%   our input image suffers from fringes. otherwise we continue assuming it
%   suffers from salt-and pepper noise. in case no kind of issue was
%   detected, we assume that our image does not require any particular
%   preprocessing and yields the corresponding response flag.
%
%   @param img input 2d image can be noisy but is valued 0 or 1.
%   @return type an integer flag to decide what pre-processing we have to
%   apply. it is equal to:
%       1 if Gaussian noise detected
%       2 if Salt- and Peper noise detected
%       3 if no noise detected
%       4 if Fringes in images detected
%
    [counts,binLocations] = imhist(img);
    % two types of buckets mean we have only values 0, 1
    % this means we either do have salt and peper noise or no noise.
    if length(binLocations(counts > 0)) == 2,
        type = 2;
        % heuristics: if there are at most 1.1 times the larger dimension
        % of an image wrong then we assume we have no noise given. Sadly, 
        % fringes also resond positively to that thest. however, 
        % there is another heuristic in order to detect fringes.  
        if abs(sum(sum(medfilt2(img, [5 5])-img))) < max(size(img))*1.1,
            % If more than 100 pixels differ (according to the diff. of a gaussian
            % smoothed thresholding reconstruction of the image, we assume
            % that there are fringes present. NB: applying a gaussian
            % reconstruction is a faster variant of applying a bilateral
            % filter but its reconstruction yields not that well results,
            % though. The case fringeRanking < 200 is for ultra soft
            % fringes. Clean images have a fringeRanking > 200 (around 300)
            % all constants have been determined by try and error.
            fringeRanking = sum(sum(abs(img-restoreImg( img, 0.5 , false)&img)));
            if  fringeRanking > 1000 || fringeRanking < 200,
                type = 4;
            else
                type = 3;
            end
          

        end
    % this corresponds to gaussian noise
    else
        type = 1;
    end
end

