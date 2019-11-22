function peak = find_peak(X, xi, r)
    L = size(X, 1);
    center = xi;
    threshold = 1;
    shift = threshold + 1;
   
    while shift > threshold 
        dist_pt_to_all = sum((repmat(center, [L 1]) - X).^2, 2);
        new_center = mean(X(dist_pt_to_all < r^2,:), 1);
        shift = norm(new_center - center);
        center = new_center;
    end
    
    peak = center; 
end