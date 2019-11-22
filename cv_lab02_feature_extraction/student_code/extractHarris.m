% Extract Harris corners.
%
% Input:
%   img           - n x m gray scale image
%   sigma         - smoothing Gaussian sigma
%                   suggested values: .5, 1, 2
%   k             - Harris response function constant
%                   suggested interval: [4e-2, 6e-2]
%   thresh        - scalar value to threshold corner strength
%                   suggested interval: [1e-6, 1e-4]
%   
% Output:
%   corners       - 2 x q matrix storing the keypoint positions
%   C             - n x m gray scale image storing the corner strength
function [corners, C] = extractHarris(img, sigma, k, thresh)
    [n,m] = size(img);

    %1.1compute Ix and Iy out of img
    filter_x = 0.5*[1 0 -1];
    filter_y = 0.5*[1 0 -1]';
    
    Ix = conv2(img, filter_x, "same");
    Iy = conv2(img, filter_y, "same");
    
    %[Ix_g, Iy_g] = imgradientxy(img, 'central');
    %figure(2);
    %subplot(2,2,1), imshow(Ix);
    %subplot(2,2,2), imshow(Iy);
    %subplot(2,2,3), imshow(Ix_g);
    %subplot(2,2,4), imshow(Iy_g);
    
    %1.2 compute local auto-correlation matrix
    N = [1 1 1;1 0 1; 1 1 1]; %neighbor function
    
    Ix2 = imgaussfilt(Ix.^2, sigma);
    Iy2 = imgaussfilt(Iy.^2, sigma);
    Ixy = imgaussfilt(Ix.*Iy, sigma);
    
    Ix2_sum = conv2(Ix2, N, "same");
    Iy2_sum = conv2(Iy2, N, "same");
    Ixy_sum = conv2(Ixy, N, "same");
    
    detM = Ix2_sum.*Iy2_sum - Ixy_sum.^2;
    traceM = Ix2_sum+Iy2_sum;
    
    C = detM - k*traceM.^2;
    Cmax = imregionalmax(C).*C;
    C = (C==Cmax) & (C>thresh);
    
    [row, col] = find(C);
    
    corners = [row'; col'];
    
    %throw corners on the edges away
    corners = corners(:, corners(2,:) > 2 & corners(2,:) < n-2);
    corners = corners(:, corners(1,:) > 2 & corners(1,:) < m-2);
    
end