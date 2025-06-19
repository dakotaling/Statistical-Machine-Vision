% Code inspired by Professor Daniel Rowe
clear; clc;
saveimage=0;

% load image
I = imread('MyImage.jpg');
testImage=double(I(:,:,1));

mx=255;

% original image
figure;
imagesc(testImage,[0,mx])
axis image, colormap(gray), axis off
title('Original Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','originalImage')
end

% 3x3 Laplacian kernel
gk=[0,-1,0;-1,4,-1;0,-1,0];

% apply Laplacian filter
testImageLaplace=MyConv(testImage,gk);

figure;
imagesc(testImageLaplace,[-500,500])
axis image, colormap(gray), axis off
title('Laplacian Filtered Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','laplacianFiltered')
end