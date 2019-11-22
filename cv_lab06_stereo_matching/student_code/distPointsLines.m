% Compute the distance for pairs of points and lines
% Input
%   points    Homogeneous 2D points 3xN
%   lines     2D homogeneous line equation 3xN
% 
% Output
%   d         Distances from each point to the corresponding line N
function d = distPointsLines(point, line)
    d = abs(line(1)*point(1)+line(2)*point(2)+line(3))/norm(line(1:2));
end