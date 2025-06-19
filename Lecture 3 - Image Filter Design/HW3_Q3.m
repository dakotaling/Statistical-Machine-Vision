% Code inspired by Professor Daniel Rowe
clear; clc;
saveimage=0;

% load image
I = imread('MyTest.jpg');
testImage=double(I);

mx=255;

% original image
figure;
imagesc(testImage,[0,mx])
axis image, colormap(gray), axis off
title('Original MyTest Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','originalMyTest')
end

% Smoothing (Gaussian)
k=5;
sigma2=0.5;
gk=kernelG(k,sigma2);
testImageSmooth=MyConv(testImage,gk);

figure;
imagesc(testImageSmooth,[0,mx])
axis image, colormap(gray), axis off
title('Smoothed Image (Gaussian)')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','smoothed')
end

% Sharpening (High-boost)
A=3;
testImageSharp=A*testImage-testImageSmooth;
testImageSharp=255*testImageSharp/max(max(testImageSharp));

figure;
imagesc(testImageSharp,[0,255])
axis image, colormap(gray), axis off
title('Sharpened Image (High-boost)')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','sharpened')
end

% Edge Detection (Laplacian)
gkLap=[0,-1,0;-1,4,-1;0,-1,0];
testImageEdge=MyConv(testImage,gkLap);

figure;
imagesc(testImageEdge,[-500,500])
axis image, colormap(gray), axis off
title('Edge Detection (Laplacian)')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','edges')
end

% Binomial Smoothing
k=5;
p=0.5;
gkBin=kernelB(k,p);
testImageBinomial=MyConv(testImage,gkBin);

figure;
imagesc(testImageBinomial,[0,mx])
axis image, colormap(gray), axis off
title('Binomial Smoothed Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','binomial')
end

% 5x5 Laplacian (stronger edge detection)
gkLap5=[0,0,1,0,0;0,1,2,1,0;1,2,-16,2,1;0,1,2,1,0;0,0,1,0,0];
testImageEdge5=MyConv(testImage,gkLap5);

figure;
imagesc(testImageEdge5,[-500,500])
axis image, colormap(gray), axis off
title('5x5 Laplacian Edge Detection')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','edges5x5')
end

% side-by-side comparison
figure;
subplot(2,3,1)
imagesc(testImage,[0,mx])
axis image, colormap(gray), axis off
title('Original')

subplot(2,3,2)
imagesc(testImageSmooth,[0,mx])
axis image, colormap(gray), axis off
title('Gaussian Smoothed')

subplot(2,3,3)
imagesc(testImageSharp,[0,255])
axis image, colormap(gray), axis off
title('High-boost Sharpened')

subplot(2,3,4)
imagesc(testImageEdge,[-500,500])
axis image, colormap(gray), axis off
title('3x3 Laplacian')

subplot(2,3,5)
imagesc(testImageBinomial,[0,mx])
axis image, colormap(gray), axis off
title('Binomial Smoothed')

subplot(2,3,6)
imagesc(testImageEdge5,[-500,500])
axis image, colormap(gray), axis off
title('5x5 Laplacian')

if (saveimage==1)
    print(gcf,'-dtiffn','-r100','allFilters')
end