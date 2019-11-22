function disp = stereoDisparity(img1, img2, dispRange, option)

    if nargin <= 3
       %default option
       option = "SSD"; 
    end
    img1 = double(img1);
    img2 = double(img2);
    disp = zeros(size(img1));
    bestDiff = ones(size(img1)) * inf;
    filterSize = 20;
    box = fspecial("average", filterSize);
    if(option == "SSD")
        for dispi = dispRange
            shiftedImg2 = shiftImage(img2, dispi);
            diff = (img1 - shiftedImg2).^2;
            %box filter
            diff = conv2(diff, box, "same");
            index = diff < bestDiff;
            disp(diff < bestDiff) = dispi;
            bestDiff = min(bestDiff, diff);        
        end
    elseif(option =="SAD")
        for dispi = dispRange
            shiftedImg2 = shiftImage(img2, dispi);
            diff = abs(img1 - shiftedImg2);
            %box filter
            diff = conv2(diff, box, "same");
            index = diff < bestDiff;
            disp(diff < bestDiff) = dispi;
            bestDiff = min(bestDiff, diff);        
        end
    else
        error("Don't know this option: %s, Please use SSD or SAD", option);
    end
    
end