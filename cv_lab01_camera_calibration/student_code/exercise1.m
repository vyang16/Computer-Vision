% Exervice 1
%
clear all;
close all;

IMG_NAME = 'images/image001.jpg';

%This function displays the calibration image and allows the user to click
%in the image to get the input points. Left click on the chessboard corners
%and type the 3D coordinates of the clicked points in to the input box that
%appears after the click. You can also zoom in to the image to get more
%precise coordinates. To finish use the right mouse button for the last
%point.
%You don't have to do this all the time, just store the resulting xy and
%XYZ matrices and use them as input for your algorithms.
%[xy XYZ] = getpoints(IMG_NAME);

%6 points corners
XYZ = [0,0,7,0,0,7;0,0,0,6,6,0;0,9,0,0,9,9];
xy = [865.944015444015,845.094594594594,71.3494208494209,1413.82046332046,1236.60038610039,232.353281853282;1125.78957528958,323.086872586873,1166.33011583012,1172.12162162162,18.4536679536679,125.017374517374];


%random points
%xy = [605.326254826255,1201.85135135135,846.252895752896,226.561776061776,1236.60038610039,1413.82046332046,69.0328185328185,379.457528957529;596.445945945946,486.407335907336,323.086872586873,126.175675675676,12.6621621621623,1172.12162162162,1170.96332046332,781.774131274131];
%XYZ = [3,0,0,7,0,0,7,5;0,5,0,0,6,6,0,0;5,5,9,9,9,0,0,3];


% === Task 1 Data normalization ===
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

% === Task 2 DLT algorithm ===
[P, K, R, t, error] = runDLT(xy, XYZ);
visualization_reprojected_points(xy, XYZ, P, IMG_NAME);
errorDLT = error

% === Task 3 Gold Standard algorithm ===
[P, K, R, t, error] = runGoldStandard(xy, XYZ);
visualization_reprojected_points(xy, XYZ, P, IMG_NAME);
errorGS = error
%errorGSA = error
