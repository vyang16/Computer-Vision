% Extract descriptors.
%
% Input:
%   img           - the gray scale image
%   keypoints     - detected keypoints in a 2 x q matrix
%   
% Output:
%   keypoints     - 2 x q' matrix
%   descriptors   - w x q' matrix, stores for each keypoint a
%                   descriptor. w is the size of the image patch,
%                   represented as vector
function [keypoints, descriptors] = extractDescriptors(img, keypoints)
    %filter out corners around the borders of the image
   patchsize = 9;
   [n,m] = size(img);
   
   %remove all keypoints that are too close to the border.
   border = ceil(patchsize/2);
   keypoints = keypoints(:, keypoints(2,:) > border & keypoints(2,:) < n-border);
   keypoints = keypoints(:, keypoints(1,:) > border & keypoints(1,:) < m-border);
   
   %extract patches
   descriptors = extractPatches(img, keypoints, patchsize);
end