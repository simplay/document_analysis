function [labels, numcomponents, size_components] = connectedComponents(bw)
% This function mimics the behavior of matlabs own function bwfill.
% It does additionally return the size of the connected components.
% Benchmarks have shown that it's about 4 times slower than matlab's
% implementation.

    labels = zeros(size(bw));
    % Operate on inverted image due to how bwfill works.
    bw = ~bw;
    current_component_nr = 1;
    size_components = [];
    % Operate as long as not everything is labeled/flooded by flood fill.
    while ~all(bw(:))
        % Find position of first nonzero value.
        [row, col] = find(bw == 0, 1);
        % Flood fill from this position, keep reference to painted pixels.
        [bw, idxs] = bwfill(bw, col, row);
        
        % Label all flooded pixels with the current number
        labels(idxs) = current_component_nr;
        % Prepare for next iteration.
        size_components = [size_components, length(idxs)];
        current_component_nr = current_component_nr + 1;
    end
    numcomponents = current_component_nr - 1;
end