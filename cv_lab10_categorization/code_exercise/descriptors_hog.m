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
    
    binEdges = -pi:(2*pi/nBins):pi;
    for i = [1:size(vPoints,1)] % for all local feature points
        center = vPoints(i, :); %2D point
        start_x = center(2) - pw/2;
        end_x = center(2) + pw/2 - 1;
        start_y = center(1) - ph/2;
        end_y = center(1) + ph/2 - 1;
        
        patch = Gdir(start_y:end_y , start_x:end_x); 
        patch_img = img(start_y:end_y, start_x:end_x);
        patches(i,:) = patch_img(:);
        
        cells = mat2cell(patch, w*ones(1,nCellsW), h*ones(1,nCellsH));
        
        descriptor = [];
        for n = 1:nCellsW*nCellsH %16 cells
            cell = cells{n};
            hg = histcounts(cell(:), binEdges); 
            descriptor = [descriptor hg];
        end
        descriptors(i, :) = descriptor;
        
    end % for all local feature points
    
end
