function [ filepaths ] = loadDataSet( dataset_nr )
%LOADDATASET Summary of this function goes here
%   Detailed explanation goes here

if dataset_nr == 3
    filepaths = { ...
        'Input/DC3/DC3.1/0005-1.jpg', ...
        'Input/DC3/DC3.1/0013-4.jpg', ...
        'Input/DC3/DC3.1/0018-7.jpg', ...
        'Input/DC3/DC3.1/0027-7.jpg', ... % Extremely narrow human writing.
        'Input/DC3/DC3.2/0004-8.jpg', ...
        'Input/DC3/DC3.2/0012-1.jpg', ... % Machine & Human writing
        'Input/DC3/hard/8528e_lg1.jpg', ... 
        'Input/DC3/hard/8528e_lg2.jpg'
    };
elseif dataset_nr == 5
    filepaths = { ...
        'Input/DC5/e-codices_csg-0027_039_max.jpg'
    };  
end



end

