% Match descriptors.
%
% Input:
%   descr1        - k x q descriptor of first image
%   descr2        - k x q' descriptor of second image
%   matching      - matching type ('one-way', 'mutual', 'ratio')
%   
% Output:
%   matches       - 2 x m matrix storing the indices of the matching
%                   descriptors
function matches = matchDescriptors(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    
    if strcmp(matching, 'one-way')
        matches = matchOneWay(descr1, descr2, matching);  
    elseif strcmp(matching, 'mutual')
        matches = matchMutual(descr1, descr2, matching);
    elseif strcmp(matching, 'ratio')
        matches = matchRatio(descr1, descr2, matching, 0.1);
    else
        error('Unknown matching type.');
    end
end

function matches = matchMutual(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    r = size(descr1,2);
    s = size(descr2,2);
    %find the one with the minimum distance for each in descr1
    matches = [0 0]';
    for i = 1:r
        match1 = find(distances(i,:) == min(distances(i,:)));
        if match1 <= s
            match2 = find(distances(:,match1) == min(distances(:,match1)));
            if match2 == i
                matches = [matches, [i match1]'];
            end
        end
    end
    matches = matches(:,2:end);
    
end

function matches = matchOneWay(descr1, descr2, matching)
    distances = ssd(descr1, descr2);
    r = size(descr1,2);
    s = size(descr2, 2);
    %find the one with the minimum distance for each in descr1
    matches = zeros(2, r);
    for i = 1:r
        matches(1,i) = i;
        matches(2, i) = find(distances(i,:) == min(distances(i,:)));
    end
end

function matches = matchRatio(descr1, descr2, matching, thres)
    distances = ssd(descr1, descr2);
    r = size(descr1,2);
    s = size(descr2, 2);
    %find the one with the minimum distance for each in descr1
    matches = [0 0]';
    for i = 1:r
        distancesi = sort(distances(i,:));
        if(distancesi(1)/distancesi(2) < thres)
            %distancesi(1)/distancesi(2)
            match = find(distances(i,:) == distancesi(1));
            matches = [matches, [i match]'];
        end
    end
    matches = matches(:,2:end);
end
function distances = ssd(descr1, descr2)
    n = size(descr1, 2);
    m = size(descr2, 2);
    distances = zeros(n,m);
    
    for i = 1:n
        for j = 1:m
            distances(i,j) = pdist2(descr1(:,i)', descr2(:,j)', 'squaredeuclidean');
        end
    end
end