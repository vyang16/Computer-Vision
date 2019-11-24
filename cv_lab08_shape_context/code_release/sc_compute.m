% Assume X is nx2, everything else double

function d = sc_compute(X, nbBins_theta, nbBins_r, smallest_r, biggest_r)
    
    %for histogram
    theta_step = 2*pi/nbBins_theta;
    r_step = log(biggest_r) - log(smallest_r) / nbBins_r;
    shift_r = mean([log(smallest_r) log(biggest_r)]);
    n = size(X, 1);
    %compute histogram for distances between point pi and all other points
    %q != pi
    hist = zeros(nbBins_r, nbBins_theta);
    for i = 1:n
       for j = 1:n
          if(i == j)
              continue;
          end
          dist = X(i,:) - X(j,:);
          [theta, r] = cart2pol(dist(1), dist(2));
          while(theta < 0)
            theta = theta + 2*pi;
          end
          %add to bucket
          if(r < smallest_r)
               idx_r = 1;
          elseif(r > biggest_r)
              idx_r = nbBins_r;
          else
              logr = log(r) - shift_r;
              idx_r = floor(logr/r_step)+1; %log r
              idx_r = min(idx_r, nbBins_r);
          end
          
          idx_t = floor(theta/theta_step)+1; %uniform theta
          hist(idx_r, idx_t) = hist(idx_r, idx_t) + 1; 
       end
    end
    
    d = hist;
end