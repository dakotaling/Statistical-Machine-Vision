% Code inspired by Professor Daniel Rowe
clear; clc;

saveimage = 0;

img = imread('FrMarquette.jpg');
img = rgb2gray(img);
img = double(img);

mx = 255;

figure;
imagesc(img, [0 mx]); colormap gray; axis image off
title('Fr Marquette - Original')

% run Laplacian sharp filter
sharp = LaplacianFilter(img);

figure;
imagesc(sharp, [0 mx]); colormap gray; axis image off
title('Sharpened Marquette')

% show diff
diffImg = sharp - img;

figure;
imagesc(diffImg, [-100 100]); colormap gray; axis image off
title('Sharp - Original')