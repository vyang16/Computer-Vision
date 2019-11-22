%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function [xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ)
%data normalization
n = size(xy, 2);
%compute mean
% 1. compute centroid
mean2D = mean(xy')'; %2x1
mean3D = mean(XYZ')'; %3x^1

% 2. shift the input points so that the centroid is at the origin
xy_star = xy - mean2D;
XYZ_star = XYZ - mean3D;
% 3. compute scale

sx = sqrt(n/(xy_star(1,:)*xy_star(1,:)')); %2x1
sy = sqrt(n/(xy_star(2,:)*xy_star(2,:)'));

sX = sqrt(n/(XYZ_star(1,:)*XYZ_star(1,:)'));
sY = sqrt(n/(XYZ_star(2,:)*XYZ_star(2,:)'));
sZ = sqrt(n/(XYZ_star(3,:)*XYZ_star(3,:)'));

% 4. create T and U transformation matrices (similarity transformation)
T = [sx 0 -sx*mean2D(1);
     0 sy -sy*mean2D(2);
     0 0 1];
    
U = [sX 0 0 -sX*mean3D(1);
     0 sY 0 -sY*mean3D(2);
     0 0 sZ -sZ*mean3D(3);
     0 0 0 1];
% 5. normalize the points according to the transformations
xy_normalized = T*[xy; ones(1,n)];
XYZ_normalized = U*[XYZ; ones(1,n)];

end