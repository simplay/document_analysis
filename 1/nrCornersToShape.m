function [ shape_classification ] = nrCornersToShape( nr_corners )
%NRCORNERSTOSHAPE Returns either 'circle', 'triangle', 'square' or star
%depending on the number of corners passed.
   if nr_corners < 3
        shape_classification = 'circle';
   elseif nr_corners == 3
        shape_classification = 'triangle';
   elseif nr_corners == 4,
        shape_classification = 'square';
   else
        shape_classification = 'star';
   end
end

