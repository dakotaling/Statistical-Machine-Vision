% Code inspired by Professor Daniel Rowe
clear; clc;

saveimage = 0;

load cardata.txt
[n, p] = size(cardata);
nx = sqrt(n);
fxy = reshape(cardata, [nx, nx])';

mx = 200;

figure
imagesc(fxy, [0 mx]);
colormap gray; axis image off
title('Original Scene')

carScene = fxy;

% Pick of choice 1, 2, 3
smoothed = ConvSmooth(carScene);
    
figure
imagesc(smoothed, [0 mx])
colormap gray; axis image off
title('Smooth: 5-point Cross Kernel')

diffImg = smoothed - carScene;

figure
imagesc(diffImg, [-mx/10 mx/10])
colormap gray; axis image off
title('Diff: Smooth - Original')

% zoom in on part of image
car = fxy(93:104, 27:64);
figure
imagesc(car, [0 mx])
colormap gray; axis image off
title('Car zoom')

carSmooth = ConvSmooth(car);
figure
imagesc(carSmooth, [0 mx])
colormap gray; axis image off
title('Smooth car')