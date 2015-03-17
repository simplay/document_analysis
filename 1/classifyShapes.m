function [ img, img_preprocessed, responses, failures, targets, outputs, hits ] = classifyShapes(filename, suffix, verbose)
%CLASSIFYSHAPES Summary of this function goes here
%   Detailed explanation goes here

    [img_preprocessed, gt, img, PREPROCESS, fringeRanking] = readImageAndGT(filename, suffix, 0);

    %% Run analysis
    [M,N] = size(img); 

    idx = 1;
    equalityCount = 0;
    % For building confusion matrix, 80 cases with 4 possible outcomes/classes.
    targets = zeros(4, 80);
    outputs = zeros(4, 80);
    failures = zeros(size(img));
    hits = zeros(size(img));
    responses = zeros(size(img));
    f = fopen(['output/', filename, suffix, '.txt'], 'w');
    % Iterate over all subimages of size 100x100
    % and classify them. Compare classification results
    % with ground truth stored in 'ground_truth_classification'

    for m=1:100:M,
        for n=1:100:N,
            counter = 0;

            % from constraint: given images is segmented into 100x100
            % subimages.
            current_range = false(size(img));
            current_range(m:m+99, n:n+99) = true;
            subimage = reshape(img_preprocessed(current_range), 100, 100);

            % retrieve corners in subimages using a harris-corner-detector.
            [threshold, minBlobSizeFactor] = getCornerParameters(PREPROCESS, fringeRanking);
            
            radius = 3;

            [~, c, response] = corners(subimage, 1.0, threshold, radius, ...
                minBlobSizeFactor);

            % classify shapes in subimage.
            shape_classification = nrCornersToShape(numel(c));

            % report results from current iteration.
            fprintf(f, [shape_classification, '\n']);
            current_reference_solution = strjoin(gt(idx));

            % Save for showing confusion matrix later on.
            targets(shapeToClassNr(current_reference_solution), idx) = 1;
            outputs(shapeToClassNr(shape_classification), idx) = 1;

            if strcmp(current_reference_solution, shape_classification)
                equalityCount = equalityCount + 1;
                hits(current_range) = subimage;
            else
                if verbose
                    disp([num2str(idx), '. ', shape_classification, ' <=> ', ...
                        current_reference_solution, ' ' , num2str(length(c))])
                end
                failures(current_range) = subimage;
            end
            responses(current_range) = response;

            % update index counter for next iteration.
            idx = idx + 1;
        end
    end
    fclose(f);
    disp(['equality count: ',num2str(equalityCount)]);



end

