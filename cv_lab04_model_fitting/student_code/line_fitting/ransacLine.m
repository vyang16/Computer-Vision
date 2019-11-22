function [best_k, best_b] = ransacLine(data, iter, threshold)
% data: a 2xn dataset with n data points
% iter: the number of iterations
% threshold: the threshold of the distances between points and the fitting line

num_pts = size(data, 2); % Total number of points
best_num_inliers = 0;   % Best fitting line with largest number of inliers
best_k = 0; best_b = 0;     % parameters for best fitting line
 
for i=1:iter
    % Randomly select 2 points and fit line to these
    % Tip: Matlab command randperm / randsample is useful here
    random_index = randperm(num_pts, 2);
    % Model is y = k*x + b. You can ignore vertical lines for the purpose
    % of simplicity.
    
    p1 = data(:, random_index(1));
    p2 = data(:, random_index(2));
    k = (p1(2)-p2(2))/(p1(1)-p2(1));
    b = p1(2) - k*p1(1);
    
    
    distance = 0;
    inliers = 0;
    for j = 1:num_pts
        % Compute the distances between all points with the fitting line
        distance = point_to_line(data(1, j), data(2, j), p1(1),p1(2), p2(1),p2(2));
        % Compute the inliers with distances smaller than the threshold
        if(distance < threshold)
           inliers = inliers + 1;
        end
    end
    
    % Update the number of inliers and fitting model if the current model
    % is better.
    if(inliers > best_num_inliers)
       best_k = k;
       best_b = b;
       best_num_inliers = inliers;
    end
end


end

function d = point_to_line(x0, y0, x1, y1, x2, y2)
    d_unn = abs((y2-y1)*x0 - (x2-x1)*y0 + x2*y1 - y2*x1);
    norm_f = sqrt((y2-y1)^2 + (x2-x1)^2);
    d = d_unn / norm_f;
end
