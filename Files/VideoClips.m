function [ num clipnums ] = VideoClips( videofile, outfilename )
    % This function creates video clips from an input video, where the
    % output clips are contiguous segments of the input video that
    % represent a continuouse scene or action taken from a single camera.
    % That is, every time the view point is changed abruptly, a new clip
    % begins.
    
    % num is the amount of clips. 
    % clipnums is a vector containing the beginning frame numbers of each
    % clip
    
    % start the video up
    iVid = VideoReader(videofile);
    frame = readFrame(iVid);
    prevFrame = frame;
    count = 0;
    
    % start the writer up
    num = 1;
    clipnums(1) = 1;
    oVid = VideoWriter([outfilename, '_', num2str(num)], 'MPEG-4');
    open(oVid);
    
    while hasFrame(iVid)
       frame = readFrame(iVid);
       diff = compare(frame,prevFrame);
       prevFrame = frame;
       count = count + 1;

       % if different and not empty, end clip and create a new one. 
       if diff && notEmpty
           % closes the video
           close(oVid);
           num = num + 1;
           
           %creates a new video
           oVid = VideoWriter([outfilename, '_', num2str(num)], 'MPEG-4');
           open(oVid);
           notEmpty = 0;
           clipnums(num) = count;
       else
           writeVideo(oVid,frame);
           notEmpty = 1;
       end
       
    end
    close(oVid);
    
    
    function diff = compare(im1, im2)
        % 3 tools to calculate the differences
        x = EdgeDist1(im1,im2);
        y = ColorDist3(im1,im2,3);
        % intensity
        z = abs(mean(mean(mean(im1))) - mean(mean(mean(im2))));
        
        % value is the count of how many of these programs proves true
        % diff returns a 1 or 0 determining if it is different
        value = int8(logical(x>0.03)) + int8(logical(y>0.05))...
            + int8(logical(z>3));
        diff = idivide(value,int8(2));
    end 


end

