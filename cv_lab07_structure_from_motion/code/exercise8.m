% =========================================================================
% Exercise 8
% Viviane Yang 16-944-530 vyang
% =========================================================================
close all
clear
% Initialize VLFeat (http://www.vlfeat.org/)
%run('C:\Users\Viviane Yang\Downloads\vlfeat-0.9.21\toolbox\vl_setup')

%K Matrix for house images (approx.)
K = [  670.0000     0     393.000
         0       670.0000 275.000
         0          0        1];

%Load images
imgName1 = '../data/house.000.pgm';
imgName2 = '../data/house.004.pgm';

img1 = single(imread(imgName1));
img2 = single(imread(imgName2));

%extract SIFT features and match
[fa, da] = vl_sift(img1);
[fb, db] = vl_sift(img2);

%don't take features at the top of the image - only background
filter = fa(2,:) > 100;
fa = fa(:,find(filter));
da = da(:,find(filter));

[matches, ~] = vl_ubcmatch(da, db);

showFeatureMatches(img1, fa(1:2, matches(1,:)), img2, fb(1:2, matches(2,:)), 1);

%% Compute essential matrix and projection matrices and triangulate matched points

%use 8-point ransac or 5-point ransac - compute (you can also optimize it to get best possible results)
%and decompose the essential matrix and create the projection matrices

x1 = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
x2 = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
threshold = 0.05;
%[inliers, F] = ransac8pF(x1, x2, threshold); %self implemented function
[F, inliers] = ransacfitfundmatrix(x1, x2, threshold);
[out1, out2] = outliers(x1, x2, inliers);
showFeatureMatches(img1, x1(1:2, inliers), img2, x2(1:2, inliers), 2, out1, out2);

x1_in = x1(:, inliers);
x2_in = x2(:, inliers);
E = K'*F*K;
x1_calibrated = K \ x1_in;
x2_calibrated = K \ x2_in;

%draw epipolar lines
figure(40),clf, imshow(img1, []); hold on, plot(x1_in(1,:), x1_in(2,:), '*r');
figure(50),clf, imshow(img2, []); hold on, plot(x2_in(1,:), x2_in(2,:), '*r');
figure(40)
for k = 1:size(x1_in,2)
    drawEpipolarLines(F'*x2_in(:,k), img1);
end
figure(50)
for k = 1:size(x2_in,2)
    drawEpipolarLines(F*x1_in(:,k), img2);
end

Ps{1} = eye(4);
Ps{2} = decomposeE(E, x1_calibrated, x2_calibrated);

%triangulate the inlier matches with the computed projection matrix
[XS1_2, ~] = linearTriangulation(Ps{1}, x1_calibrated, Ps{2}, x2_calibrated);
%% Add an addtional view of the scene 

imgName3 = '../data/house.001.pgm';
img3 = single(imread(imgName3));
[fc, dc] = vl_sift(img3);
fa_in  = fa(:, matches(1, inliers));
da_in = da(:, matches(1, inliers));
%match against the features from image 1 that where triangulated
%only look at matches that where matched in first 2 pictures. 
[matchesac, ~] = vl_ubcmatch(da_in, dc);

x1_ac = makehomogeneous(fa_in(1:2, matchesac(1,:)));
x1_calibrated_ac = x1_calibrated(:, matchesac(1,:));
x3 = fc(1:2, matchesac(2,:));
x3_calibrated = K \ makehomogeneous(x3);

%run 6-point ransac
threshold_proj = 0.1;
[P, inliers3] = ransacfitprojmatrix(x3_calibrated, XS1_2(:, matchesac(1,:)), threshold_proj);
XS1_2_ac = XS1_2(:, matchesac(1, inliers3));
if (det(P(1:3,1:3)) < 0 )
    P(1:3,1:3) = -P(1:3,1:3);
    P(1:3, 4) = -P(1:3, 4);
end
Ps{3} = P;
[out1ac, out2ac] = outliers(x1_ac, x3, inliers3);
showFeatureMatches(img1, x1_ac(1:2, inliers3), img3, x3(1:2, inliers3), 3, out1ac, out2ac);
%triangulate the inlier matches with the computed projection matrix
[XS1_3, ~]= linearTriangulation(Ps{1}, x1_calibrated_ac(:, inliers3), Ps{3}, x3_calibrated(:, inliers3));
%% Add more views...
% 4th house

imgName4 = '../data/house.002.pgm';
img4 = single(imread(imgName4));
[fd, dd] = vl_sift(img4);
%match against the features from image 1 that where triangulated
%only look at matches that where matched in first 2 pictures. 
[matchesad, ~] = vl_ubcmatch(da_in, dd);

x1_ad = makehomogeneous(fa_in(1:2, matchesad(1,:)));
x1_calibrated_ad = x1_calibrated(:, matchesad(1,:));
x4 = fd(1:2, matchesad(2,:));
x4_calibrated = K \ makehomogeneous(x4);

%run 6-point ransac
[P, inliers4] = ransacfitprojmatrix(x4_calibrated, XS1_2(:, matchesad(1,:)), threshold_proj);

if (det(P(1:3,1:3)) < 0 )
    P(1:3,1:3) = -P(1:3,1:3);
    P(1:3, 4) = -P(1:3, 4);
end
Ps{4} = P;
[out14, out24] = outliers(x1_ad, x4, inliers4);
showFeatureMatches(img1, x1_ad(1:2, inliers4), img4, x4(1:2, inliers4), 4, out14, out24);
%triangulate the inlier matches with the computed projection matrix
[XS1_4, ~]= linearTriangulation(Ps{1}, x1_calibrated_ad(:, inliers4), Ps{4}, x4_calibrated(:, inliers4));


imgName5 = '../data/house.003.pgm';
img5 = single(imread(imgName5));
[fe, de] = vl_sift(img5);

%match against the features from image 1 that where triangulated
%only look at matches that where matched in first 2 pictures. 
[matchesae, ~] = vl_ubcmatch(da_in, de);

x1_ae = makehomogeneous(fa_in(1:2, matchesae(1,:)));
x1_calibrated_ae = x1_calibrated(:, matchesae(1,:));
x5 = fe(1:2, matchesae(2,:));
x5_calibrated = K \ makehomogeneous(x5);



%run 6-point ransac
threshold_proj = 0.1;
[P, inliers5] = ransacfitprojmatrix(x5_calibrated, XS1_2(:, matchesae(1,:)), threshold_proj);

if (det(P(1:3,1:3)) < 0 )
    P(1:3,1:3) = -P(1:3,1:3);
    P(1:3, 4) = -P(1:3, 4);
end
Ps{5} = P;
[out15, out25] = outliers(x1_ae, x5, inliers5);
showFeatureMatches(img1, x1_ae(1:2, inliers5), img5, x5(1:2, inliers5), 5, out15, out25);
%triangulate the inlier matches with the computed projection matrix
[XS1_5, ~]= linearTriangulation(Ps{1}, x1_calibrated_ae(:, inliers5), Ps{5}, x5_calibrated(:, inliers5));


%% Plot stuff

fig = 10;
figure(fig);
rotate3d on
hold on

%use plot3 to plot the triangulated 3D points
scatter3(XS1_2_ac(1,:), XS1_2_ac(2,:), XS1_2_ac(3,:), 'r.'); %filter out not matched points in XS1_2
scatter3(XS1_3(1,:), XS1_3(2,:), XS1_3(3,:), 'y.');
scatter3(XS1_4(1,:), XS1_4(2,:), XS1_4(3,:), 'g.');
scatter3(XS1_5(1,:), XS1_5(2,:), XS1_5(3,:), 'b.');
%draw cameras
drawCameras(Ps, fig);

hold off