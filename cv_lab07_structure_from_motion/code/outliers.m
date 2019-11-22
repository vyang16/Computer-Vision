function [outliers1, outliers2] = outliers(x1, x2, inliers)

condition = zeros(1, size(x1,2));
condition(inliers) = 1;
condition = logical(condition); 
outliers1 = x1(1:2, ~condition); outliers2 = x2(1:2, ~condition);

end

