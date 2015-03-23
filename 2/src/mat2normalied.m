function [ normalizedMatrix ] = mat2normalied( matrix )
%MAT2NORMALIED maps linearly the entries of a given matrix into the range [0,1]
%   @param matrix of dimension (m x n) in range [a,b]
%   @return matrix of dimension (m x n) in range [0,1]
    
    normalizedMatrix = matrix - min(matrix(:));
    normalizedMatrix = normalizedMatrix ./ max(normalizedMatrix(:));

end

