function [ filepaths, dc_mat_files ] = loadDataSetData( dataset_nr )
%LOADDATASET Summary of this function goes here
%   Detailed explanation goes here

dc_mat_files = {'DC3.2.0012-1.jpg.mat'};
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
        'Input/DC5/e-codices_csg-0027_039_max.jpg', ...
        'Input/DC5/e-codices_csg-0027_103_max.jpg'
    };  
    dc_mat_files = {'DC5_39.mat', 'DC5_103.mat'};
end



end

