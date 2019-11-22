function diffs = diffsGC(img1, img2, dispRange)

    filterSize = 20;
    m = size(img1, 1);
    n = size(img1, 2);
    r = length(dispRange);
    % get data costs for graph cut
    %return Dc = zeros([sz(1:2) k],'single'); dimensions mxnxr
    diffs = zeros(m,n,r);
    box = fspecial("average", filterSize);
    for i = 1:r
        offset  = -1+ceil(r/2);
        diff = (img1 - shiftImage(img2, dispRange(i))).^2;
        diffs(:,:,i) = conv2(diff, box, "same");
    end
    
end