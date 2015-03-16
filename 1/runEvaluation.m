function runEvaluation( img, img_preprocessed, responses, failures, targets, outputs, hits, filename, suffix)
%RUNEVALUATION Summary of this function goes here
%   Detailed explanation goes here

    %% Draw confusion matrix of classifications and other debug images.
    % Fix '_' characters being used for subscripts.
    set(0,'DefaultTextInterpreter','none')
    plotconfusion(targets, outputs, [filename, suffix])
    confusion_labels = {'circle' 'triangle' 'square' 'star', 'Overall'};
    set(gca,'xticklabel', confusion_labels)
    set(gca,'yticklabel', confusion_labels)
    failure_image = responses;
    % Dump confusion matrix to file
    %export_fig(['confusion_matrix_', filename, suffix, '.png'], '-transparent');
    failure_image(:,:,2) = hits;
    failure_image(:,:,3) = failures;
    figure; imshow(failure_image);

    img_vs_preprocessed = img;
    img_vs_preprocessed(:,:,2) = img_preprocessed;
    img_vs_preprocessed(:,:,3) = zeros(size(img));
    figure; imshow(img_vs_preprocessed);
end

