function pixelCounts= LBPnew(fname)
%LBPNEW Summary of this function goes here
%   Detailed explanation goes here
grayImage=imread(fname);
% Get the dimensions of the image.  numberOfColorBands should be = 1.
[rows columns numberOfColorBands] = size(grayImage);

% Display the original gray scale image.
%%subplot(2, 2, 1);
%%imshow(grayImage, []);
%title('Original Grayscale Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
%%set(gcf, 'Position', get(0,'Screensize')); 
%%set(gcf,'name','Image Analysis Demo','numbertitle','off') 
% Let's compute and display the histogram.
[pixelCount grayLevels] = imhist(grayImage);
%%subplot(2, 2, 2); 
%%bar(pixelCount);
%title('Histogram of original image', 'FontSize', fontSize);
%%xlim([0 grayLevels(end)]); % Scale x axis manually.
% Preallocate/instantiate array for the local binary pattern.
localBinaryPatternImage = zeros(size(grayImage));
for row = 2 : rows - 1   
    for col = 2 : columns - 1    
        centerPixel = grayImage(row, col);
        pixel7=grayImage(row-1, col-1) > centerPixel;  
        pixel6=grayImage(row-1, col) > centerPixel;   
        pixel5=grayImage(row-1, col+1) > centerPixel;  
        pixel4=grayImage(row, col+1) > centerPixel;     
        pixel3=grayImage(row+1, col+1) > centerPixel;    
        pixel2=grayImage(row+1, col) > centerPixel;      
        pixel1=grayImage(row+1, col-1) > centerPixel;     
        pixel0=grayImage(row, col-1) > centerPixel;       
        localBinaryPatternImage(row, col) = uint8(...
            pixel7 * 2^7 + pixel6 * 2^6 + ...
            pixel5 * 2^5 + pixel4 * 2^4 + ...
            pixel3 * 2^3 + pixel2 * 2^2 + ...
            pixel1 * 2 + pixel0);
    end  
end 
%%subplot(2,2,3);
%%imshow(localBinaryPatternImage, []);
%title('Local Binary Pattern', 'FontSize', fontSize);
%%subplot(2,2,4);
[pixelCounts, GLs] = imhist(uint8(localBinaryPatternImage));
%%bar(GLs, pixelCounts);
end

