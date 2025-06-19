% Code inspired by Professor Daniel Rowe
clear; clc; 

saveimage = 0;

% read the image
img = imread('FrMarquette.jpg');  % check filename
if size(img, 3) == 3
    img = rgb2gray(img);  % grayscale
end
img = double(img);

[n, m] = size(img);
mx = 255;

figure;
imagesc(img, [0 mx]);
colormap gray; axis image off
title('Original')

% run the custom smoother
filt = FourNeighborFilter(img);

figure;
imagesc(filt, [0 mx]);
colormap gray; axis image off
title('Filtered')

% diff image
d = filt - img;

figure;
imagesc(d, [-25 25]);
colormap gray; axis image off
title('Diff')

