function vPoints = grid_points(img,nPointsX,nPointsY,border)
    [row, column] = size(img);
    %cut of boarder
    start_x = border + 1;
    start_y = border + 1;
    end_x = column - border;
    end_y = row - border;
    step_x = floor((end_x - start_x + 1)/nPointsX);
    step_y = floor((end_y - start_y + 1)/nPointsY);
    x = start_x : step_x : end_x;
    y = start_y : step_y : end_y;
    vPoints = zeros(nPointsX*nPointsY, 2);
    c = 1;
    for i =1:nPointsX
        for j =1:nPointsY
            vPoints(c, :) = [y(i), x(j)];
            c = c + 1;
        end
    end
    
end
