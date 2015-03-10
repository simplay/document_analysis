function [ class_nr ] = shapeToClassNr( shape )
%SHAPE_TO_NR_CORNERS Takes a string describing a shape and returns the
%number of corners of it.
    if strcmp(shape, 'circle')
        class_nr = 1;
    elseif strcmp(shape, 'triangle')
        class_nr = 2;
    elseif strcmp(shape, 'square'),
        class_nr = 3;
    elseif strcmp(shape, 'star');
        class_nr = 4;
    end
end

