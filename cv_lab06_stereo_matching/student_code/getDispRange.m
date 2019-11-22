function maxR = getDispRange(imgRectL, imgRectR, upper)
    iter = 10;
    maxRList = zeros(1, iter);
    for i=1:iter
        [x1s, x2s] = getMatchedPointsRANSAC(imgRectL, imgRectR);
        dispMatched = vecnorm((x1s - x2s)); 
        dispMatched = dispMatched(dispMatched < upper);
        maxRList(i) = ceil(max(dispMatched));
    end
    
    maxR = ceil(mean(maxRList));
end
