function [ unary ] = computeClassPotentials( fMask, bMask, foregroundPDF, backgroundPDF )
%MAKEUNARY Specify the potentials (data term) for each of the C possible
%classes at each of the N nodes. Here, C is equal two, since we have two
%classes, fore-and background.
%   @papram fMask foreground mask
%   @papram bMask background mask
%   @papram foregroundPDF foreground pdf
%   @papram backgroundPDF background pdf
%   @return potentials does a node belong a certain class.

    eps = 1E-5;

    % 2xN matrix containing the negative logarithm of the PDFs (fore-and
    % background). Instead of adding such a small constant in order to get rid
    % of this 'taking the log of zero' issue, is clip it for the zero case.
    unary = [-log(max(foregroundPDF,eps)'); -log(max(backgroundPDF,eps)')];

    
    % Foreground mask:
    % The cost that this pixel belongs to the foreground is set to 0
    % and that this pixel belongs to the background is set to a high value.
    I = find(fMask == 1);
    for k = 1:length(I)
        idx = I(k);
        unary(1, idx) = 0;
        unary(2, idx) = -log(eps);
    end
    
    % Background mask:
    % The cost that this pixel belongs to the background is set to 0
    % and that this pixel belongs to the foreground is set to a high value.
    I = find(bMask == 1);
    for k = 1:length(I)
        idx = I(k);
        unary(1,idx) = -log(eps);
        unary(2,idx) = 0;
    end

end