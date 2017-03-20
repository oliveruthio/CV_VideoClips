function [x hist1 hist2] = EdgeDist1(im1, im2)  

% green channel only
im1g = im1(:,:,2);
im2g = im2(:,:,2);

% histograms
hist1 = makeHist(im1g);
hist2 = makeHist(im2g);

% normalize
hist1 = hist1./(size(im1, 1) * size(im1, 2));
hist2 = hist2./(size(im2, 1) * size(im2, 2));

%euclidean distance
dist = (hist1 - hist2).^2;
x = sqrt(sum(sum(dist)));

    %makes histogram
    function a = makeHist(im)
        %bins are [E,NE,N,NW,W,SW,S,SE,small]
        a = zeros(9,1); 
        
        %finds the two sobel matrices, Gx, Gy
        kernel1 = [-1 0 1; -2 0 2; -1 0 1;];
        kernel2 = [1 2 1; 0 0 0; -1 -2 -1;];
        
        %Gx and Gy
        Gx = convo(im,kernel1);
        Gy = convo(im,kernel2);

        G = sqrt(Gx.^2 + Gy.^2);
        deg = atan2d(Gy,Gx);
        
        % scans through image
        for i = 1:size(im,1)
            for j = 1:size(im,2)  
                if(G(i,j) < 10) % alpha = 10
                    a(9) = a(9) + 1;
                else                  
                    % atan2d outputs degrees in [-180,180]
                    if(deg(i,j) < 0)
                        deg2 = 360 + deg(i,j);
                    else
                        deg2 = deg(i,j);
                    end                  
                    % +22.5 shift so E will be [0,45] not [-22.5, 22.5]
                    deg3 = mod(deg2+22.5,360);
                    dir = floor(deg3/45) + 1;
                    a(dir) = a(dir) + 1;
                end
        
            end
        end
    end
    
    % convolutes the image
    function cm = convo(im, k)
        cm_temp = xcorr2(double(im), double(k));
        %crops it since convolution adds a border
        cm = cm_temp(2:size(cm_temp,1)-1, 2:size(cm_temp,2)-1);
    end
    
end