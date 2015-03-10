function [ nr_corners ] = shape_to_class_nr( shape )
%SHAPE_TO_NR_CORNERS Takes a string describing a shape and returns the
%number of corners of it.
    if strcmp(shape, 'circle')
        nr_corners = 1;
    elseif strcmp(shape, 'triangle')
        nr_corners = 2;
    elseif strcmp(shape, 'square'),
        nr_corners = 3;
    elseif strcmp(shape, 'star');
        nr_corners = 4;
    end
end

