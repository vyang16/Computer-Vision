function [err_real, err_ls, err_ransac] = ransacTest(iter)
    for i = 1:iter
        [err_real(i), err_ls(i), err_ransac(i)] = runTest();
    end
end


function [err_real, err_ls, err_ransac] = runTest()
% Generate noisy points for the real model
num = 200; % number of points
X = -num/2:num/2;
outlr_ratio = .5;
inlr_std = 4;
k = .5;
b = 10;
pts = genRansacTestPoints(num, outlr_ratio, inlr_std, [k b]);

err_real = sqr_error(k, b, pts(:,1:num*(1-outlr_ratio)));

coef2 = polyfit(pts(1,:), pts(2,:), 1);
k1 = coef2(1);
b1 = coef2(2); 
err_ls = sqr_error(k1, b1, pts(:,1:num*(1-outlr_ratio)));

iter = 1000;
thresh_dist = 3;
[k2, b2] = ransacLine(pts, iter, thresh_dist);
err_ransac = sqr_error(k2, b2, pts(:,1:num*(1-outlr_ratio)));
end

