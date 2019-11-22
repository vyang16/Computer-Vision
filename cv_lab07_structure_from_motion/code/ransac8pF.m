% Compute the fundamental matrix using the eight point algorithm and RANSAC
% Input
%   x1, x2 	  Point correspondences 3xN
%   threshold     RANSAC threshold
%
% Output
%   best_inliers  Boolean inlier mask for the best model
%   best_F        Best fundamental matrix
%
function [best_inliers, best_F] = ransac8pF(x1, x2, threshold)

iter = 1000;
N = 8;
num_pts = size(x1, 2); % Total number of correspondences
best_num_inliers = 0; best_inliers = [];
best_F = 0;
p_thres = 0.99;
r = 0;
c = 1; % set higher than 1 to converge quicker in trade off with #inliers
p = 0;
av_sampson = 0;
for M=1:iter
    % Randomly select 8 points and estimate the fundamental matrix using these.
    random_index = randperm(num_pts, 8);
    
    x1_N = zeros(3,N);
    x2_N = zeros(3,N);
   
    for j = 1:N
       x1_N(:, j) = x1(:,random_index(j));
       x2_N(:, j) = x2(:,random_index(j));
    end
    
    Fh = fundamentalMatrix(x1_N, x2_N);
    % Compute the Sampson error.
    sampson = threshold + 1; %set error initially higher
    inliers = zeros(1, num_pts);
    num_inliers = 0;
    total_sampson = 0;
    for j = 1:num_pts
        sampson = computeSampsonError(x1(:,j), x2(:,j), Fh);
        % Compute the inliers with errors smaller than the threshold.
        if(sampson < threshold)
            num_inliers = num_inliers + 1;
            inliers(j) = 1; 
            total_sampson = total_sampson + sampson;
        end
    end
        
    % Update the number of inliers and fitting model if the current model
    % is better.
    if(num_inliers > best_num_inliers)
       best_num_inliers = num_inliers;
       best_F = Fh;
       best_inliers = logical(inliers);
       av_sampson = total_sampson / best_num_inliers;
    end
 
    
%uncomment for adaptive RANSAC, set iter higher   
%     r = best_num_inliers/num_pts;
%     p = (1-((1-(c*r)^N)^M));
%     if(p >= p_thres)
%         break;
%     end
    
end

%sum(best_inliers)
%M
%av_sampson
end

function s = computeSampsonError(x1, x2, F)
    s = distPointsLines(x2, F*x1) + distPointsLines(x1, F'*x2);
end