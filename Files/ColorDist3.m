function [x hist1 hist2] = ColorDist3(im1, im2, N)

    % make histograms
    hist1 = makeHist(im1, N);
    hist2 = makeHist(im2, N);

    % normalize the histograms
    hist1 = hist1./(size(im1, 1) * size(im1, 2));
    hist2 = hist2./(size(im2, 1) * size(im2, 2));
    
    % euclidean distance
    dist = (hist1 - hist2).^2;
    x = sqrt(sum(sum(sum(dist))));
    
    function a = makeHist(im, N)     
        a = zeros(N,N,N);
        % scans through each pixel of the image
        for i = 1:size(im,1)
            for j = 1:size(im,2)
                for n = 1:N
                    % bin range
                    min = round((n-1)*256/N);
                    max = round(n*256/N - 1);
                    
                    % determines which bin each pixel intensity belongs to
                    if (min <= im(i,j,1) && im(i,j,1) <= max)
                        r = n;
                    end                   
                    if (min <= im(i,j,2) && im(i,j,2) <= max)
                        g = n;
                    end                  
                    if (min <= im(i,j,3) && im(i,j,3) <= max)
                        b = n;
                    end               
                end
                % determines which bin each pixel intensity belongs to
                a(r,g,b) = a(r,g,b) + 1;
            end
        end
    end
 
end