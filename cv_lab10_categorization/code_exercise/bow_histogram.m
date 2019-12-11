
function histo = bow_histogram(vFeatures, vCenters)
  % input:
  %   vFeatures: MxD matrix containing M feature vectors of dim. D
  %   vCenters : NxD matrix containing N cluster centers of dim. D
  % output:
  %   histo    : N-dim. vector containing the resulting BoW
  %              activation histogram.
  [M, D] = size(vFeatures);
  N = size(vCenters, 1);
  
  
  % Match all features to the codebook and record the activated
  % codebook entries in the activation histogram "histo".
  histo = zeros(1, N);
  
  %for each feature, look which center it is closest to
  dist_matrix = dist2(vFeatures, vCenters);
  for i= 1:M
      %find one with smallest distance, add one for histogram
      [~, index] = min(dist_matrix(i,:));
      histo(1,index) = histo(1, index) + 1;
  end
end
