function [descriptors,patches] = descriptors_hog(img,vPoints,cellWidth,cellHeight)

    nBins = 8;
    nCellsW = 4; % number of cells, hard coded so that descriptor dimension is 128
    nCellsH = 4; 

    w = cellWidth; % set cell dimensions
    h = cellHeight;   

    pw = w*nCellsW; % patch dimensions
    ph = h*nCellsH; % patch dimensions

    descriptors = zeros(0,nBins*nCellsW*nCellsH); % one histogram for each of the 16 cells
    patches = zeros(0,pw*ph); % image patches stored in rows    
    
    [grad_x,grad_y] = gradient(img);    
    Gdir = (atan2(grad_y, grad_x)); 
    
    for i = [1:size(vPoints,1)] % for all local feature points
        ...
        ...
    end % for all local feature points
    
end
