% Code inspired by Professor Daniel Rowe
clear; clc;

% Load image
img = imread('feeding_pigeons.jpg');
if size(img, 3) == 3
    img = img(:,:,1); % Using first image
end

% Convert image to double
img = double(img);

% Show original image
figure;
imagesc(img, [0, 255]);
colormap(gray);
axis off;
title('Original');

% Apply 7x7 Gaussian filter
filteredImg = Gaussian7Filter(img);

% Show filtered image
figure;
imagesc(filteredImg, [0, 255]);
colormap(gray);
axis off;
title('Filtered');

% Show difference image
diffImg = filteredImg - img;
figure;
imagesc(diffImg, [-25.5, 25.5]);
colormap(gray);
axis off;
title('Difference');

