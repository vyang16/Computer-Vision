% Viviane Yang 16-944-530
% Use these variables to enable/disable different parts of the script.
%

clear all;

loadImages           = true;  % also displays silhouettes
displayVolumeCorners = true;
computeVisualHull    = true;
displayVolumeSlices  = true;
displayIsoSurface    = true;

%
% Adjust these variables, one at a time, to get a good visual hull.
%

% Task 9.1 silhouette threshold
% This should be a suitable value between 0 and 255
silhouetteThreshold = 120;

% Task 9.2 define bounding box
% It should be as small as possible, but still contain the whole region of
% interest.
bbox = [0.4 -0.2 -1.8; 2.2 1.2 2.6]; % [minX minY minZ; maxX maxY maxZ];
volumeX = 64;
volumeY = 64;
volumeZ = 128;
volumeThreshold = 17;

home;
numCameras = 18; %18 pictures max

if loadImages
    % Load silhouette images and projection matrices
    for n=1:numCameras
        % Projection matrices
        % This does not normalize the depth value
        Ps{n} = textread(sprintf('../data/david_%02d.pa',n-1));
        Ps{n} = [eye(3,2) [1 1 1]']*Ps{n};  % add 1 for one-based indices
        % Images
        ims{n} = imread(sprintf('../data/david_%02d.jpg',n-1));
        % Silhouettes
        sils{n} = rgb2gray(ims{n})>silhouetteThreshold;
        
        figure(1);
        subplot(1,2,1);
        imshow(sils{n});
        subplot(1,2,2);
        imshow(double(rgb2gray(ims{n}))/255.*sils{n}); %black and white picture
        drawnow;
    end
end

% Define transformation from volume to world coordinates.
T = [eye(4,3) [bbox(1,:) 1]'] * ...
    diag([(bbox(2,1)-bbox(1,1))/volumeX ...
          (bbox(2,2)-bbox(1,2))/volumeY ...
          (bbox(2,3)-bbox(1,3))/volumeZ ...
          1]);
T = [1  0 0 0; ...
     0  0 1 0; ...  % flip y and z axes for better display in matlab figure (isosurface)
     0 -1 0 0; ...
     0  0 0 1] * T;
T = T*[eye(4,3) [-[1 1 1] 1]'];  % subtract 1 for one-based indices
pcorners = cell(numCameras,1);

if displayVolumeCorners
    % Draw projection of volume corners.
    for n=1:numCameras
        figure(2);
        hold off;
        imshow(ims{n});
        hold on;
        corners = [[      0       0       0 1]' ...
                   [      0       0 volumeZ 1]' ...
                   [      0 volumeY       0 1]' ...
                   [      0 volumeY volumeZ 1]' ...
                   [volumeX       0       0 1]' ...
                   [volumeX       0 volumeZ 1]' ...
                   [volumeX volumeY       0 1]' ...
                   [volumeX volumeY volumeZ 1]'];
        pcorners{n} = Ps{n}*T*corners;
        pcorners{n} = pcorners{n}./repmat(pcorners{n}(3,:),3,1);
        plot(pcorners{n}(1,:),pcorners{n}(2,:),'g*');
        drawnow;
        pause(0.1);
    end
end

if computeVisualHull
    % Define volume. This is used to store the number of observations for
    % each voxel.
    volume = zeros(volumeX,volumeY,volumeZ);
    
    % Visual hull computation    
    % Task 9.3 Visual hull computation
    %   - For each image add one to the voxel if projection is within
    %     silhouette region.
    %   - Be careful with the order of coordinates. The point is stored as
    %     (x,y,z), but matrix element access in Matlab is mat(row,col).
    
    
    for i=1:volumeX
        for j=1:volumeY
           for k=1:volumeZ
               voxel = [i j k 1]'; %center of the voxel
               for n=1:numCameras
                   %project to image
                   pvoxel = Ps{n}*T*voxel;
                   pvoxel = pvoxel./repmat(pvoxel(3,:),3,1);
                   xp = round(pvoxel(2)); %change x and y axis
                   yp = round(pvoxel(1));
                   %check out of bound
                   min_x = 1;
                   min_y = 1;
                   [max_x, max_y] = size(sils{n});
                   in_bound = xp >= min_x && xp <= max_x && yp >= min_y && yp <=max_y;
                   if in_bound
                    if sils{n}(xp, yp)
                        volume(i,j,k) = volume(i,j,k)+1;
                    end
                   end

               end
           end
        end
    end
    
end

if displayVolumeSlices
    figure(3);
    hold off;
    for n=1:size(volume,3)
        imagesc(volume(:,:,n));
        drawnow;
        pause(0.1);
    end
end

if displayIsoSurface
    % display result
    figure(4);
    clf;
    grid on;
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on;
    [xMesh yMesh zMesh] = meshgrid(1:volumeY,1:volumeX,1:volumeZ);
    pt = patch(isosurface(yMesh, xMesh, zMesh, volume, volumeThreshold));
    set(pt,'FaceColor','red','EdgeColor','none');
    axis equal;
    daspect([volumeX/(bbox(2,1)-bbox(1,1)) volumeY/(bbox(2,2)-bbox(1,2)) volumeZ/(bbox(2,3)-bbox(1,3))]);
    camlight(0,0);
    camlight(180,0);
    camlight(0,90);
    camlight(0,-90);
    lighting phong;
    view(30,30);
end


