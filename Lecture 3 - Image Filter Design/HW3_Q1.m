% Code inspired by Professor Daniel Rowe

clear; clc;
saveimage=0;

% load image
I = imread('MyImage.jpg');
testImage=double(I(:,:,1));

mx=255; % image max

% original image
figure;
imagesc(testImage,[0,mx])
axis image, colormap(gray), axis off
title('Original Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','originalImage')
end

% 5x5 Gaussian Filter with sigma2 = 0.5
k1=5;
sigma2_1=0.5;
gk1=kernelG(k1,sigma2_1);

figure;
surf(gk1)
title('5x5 Gaussian Kernel (σ² = 0.5)')

testImage_5x5=MyConv(testImage,gk1);

figure;
imagesc(testImage_5x5,[0,mx])
axis image, colormap(gray), axis off
title('5x5 Gaussian Filtered Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','filtered_5x5')
end

% 11x11 Gaussian Filter with sigma2 = 2
k2=11;
sigma2_2=2;
gk2=kernelG(k2,sigma2_2);

figure;
surf(gk2)
title('11x11 Gaussian Kernel (σ² = 2)')

testImage_11x11=MyConv(testImage,gk2);

figure;
imagesc(testImage_11x11,[0,mx])
axis image, colormap(gray), axis off
title('11x11 Gaussian Filtered Image')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','filtered_11x11')
end

% differences
diff_5x5=testImage_5x5-testImage;
figure;
imagesc(diff_5x5,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Difference: 5x5 Filtered - Original')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','diff_5x5')
end

diff_11x11=testImage_11x11-testImage;
figure;
imagesc(diff_11x11,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Difference: 11x11 Filtered - Original')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','diff_11x11')
end

diff_filters=testImage_11x11-testImage_5x5;
figure;
imagesc(diff_filters,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Difference: 11x11 - 5x5 Filtered')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','diff_filters')
end

% side-by-side comparison
figure;
subplot(2,3,1)
imagesc(testImage,[0,mx])
axis image, colormap(gray), axis off
title('Original')

subplot(2,3,2)
imagesc(testImage_5x5,[0,mx])
axis image, colormap(gray), axis off
title('5x5 Gaussian (σ² = 0.5)')

subplot(2,3,3)
imagesc(testImage_11x11,[0,mx])
axis image, colormap(gray), axis off
title('11x11 Gaussian (σ² = 2)')

subplot(2,3,4)
imagesc(diff_5x5,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Diff: 5x5 - Original')

subplot(2,3,5)
imagesc(diff_11x11,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Diff: 11x11 - Original')

subplot(2,3,6)
imagesc(diff_filters,[-mx/10,mx/10])
axis image, colormap(gray), axis off
title('Diff: 11x11 - 5x5')

if (saveimage==1)
    print(gcf,'-dtiffn','-r100','comparison_all')
end