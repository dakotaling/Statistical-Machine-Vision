% Code inspired by Professor Daniel Rowe
clear; clc;

img = imread('feeding_pigeons.jpg');
if size(img, 3) == 3
    img = img(:,:,1);
end

img = double(img);
maxVal = 255;

figure;
imagesc(img, [0, maxVal]);
colormap(gray);
axis off;
title('Original');

filteredImg = EmbossFilter(img);

figure;
imagesc(filteredImg, [0, maxVal]);
colormap(gray);
axis off;
title('Embossed');

diffImg = filteredImg - img;
figure;
imagesc(diffImg, [-maxVal/2, maxVal/2]);
colormap(gray);
axis off;
title('Difference');
