function [x1s, x2s] = getMatchedPointsRANSAC(img1, img2)
    img1 = single(rgb2gray(img1));
    img2 = single(rgb2gray(img2));
    
    %extract SIFT features and match
    [fa, da] = vl_sift(img1);
    [fb, db] = vl_sift(img2);
    [matches, scores] = vl_ubcmatch(da, db);

    x1s = [fa(1:2, matches(1,:)); ones(1,size(matches,2))];
    x2s = [fb(1:2, matches(2,:)); ones(1,size(matches,2))];
    %showFeatureMatches(img1, x1s(1:2, :), img2, x2s(1:2, :), 2);

    threshold = 0.3;

    [M, inliers, F] = ransac8pF(x1s, x2s, threshold);

    %showFeatureMatches(img1, x1s(1:2, inliers), img2, x2s(1:2, inliers), 2);
    x1s = x1s(1:2, inliers);
    x2s = x2s(1:2, inliers);
    
end