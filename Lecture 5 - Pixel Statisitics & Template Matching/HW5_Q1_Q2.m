% Code inspired by Professor Daniel Rowe
% Based on ImageStats.m structure and MyConv.m
clear; clc;

% Q.1
printfigs = 0;
load myposnegmapblk.txt
load myposmapblk.txt

limMin = 0; limMaxI = 255; yhist = 1000; yhist2 = 5000;

I_rgb = imread('FrMarquette.jpg');
I = double(rgb2gray(I_rgb));

[ny, nx] = size(I);

kernel_size = 7;
kernel = ones(kernel_size, kernel_size);
ksum = sum(kernel(:));

% Original image statistics
Ibar = mean(I(:)); 
s2I = var(I(:));
figure;
imagesc(I, [limMin,limMaxI])
colormap(gray), axis image, axis off
title('Original Image')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'OriginalImage')
end


I2 = I.^2;

% Compute local sum statistics
O = MyConv(I, kernel);
Obar = mean(O(:)); 
s2O = var(O(:));
figure;
imagesc(O, [limMin, ksum*limMaxI])
colormap(myposmapblk), axis image, axis off
title('Local Sum')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalSum')
end
figure;
histogram(O(:), 50)
xlim([limMin, ksum*limMaxI])
title('Histogram of Local Sum')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalSumHist')
end

% Compute local sum of squares
O2 = MyConv(I2, kernel);
O2bar = mean(O2(:)); 
s2O2 = var(O2(:));
figure;
imagesc(O2, [limMin, ksum*limMaxI^2])
colormap(myposmapblk), axis image, axis off
title('Local Sum of Squares')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalSumSquares')
end
figure;
histogram(O2(:), 50)
xlim([limMin, ksum*limMaxI^2])
title('Histogram of Local Sum of Squares')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalSumSquaresHist')
end

% Compute local variance
S2 = (O2 - (O.^2)/ksum)/(ksum-1);
S2bar = mean(S2(:)); 
s2S2 = var(S2(:));

S2 = max(S2, 0);
figure;
imagesc(S2, [0, max(S2(:))])
colormap(myposmapblk), axis image, axis off
title('Local Variance')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalVariance')
end
figure;
histogram(S2(:), 50)
title('Histogram of Local Variance')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalVarianceHist')
end

% Q.2
S2 = max(S2, 0);

figure;
imagesc(S2, [0, max(S2(:))])
colormap(myposmapblk), axis image, axis off
title('Local Variance')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalVariance')
end

figure;
histogram(S2(:), 50)
title('Histogram of Local Variance')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'LocalVarianceHist')
end


kernel_smooth_large = ones(5,5) / 25;
kernel_smooth_small = ones(3,3) / 9;

S2_max = max(S2(:));
I_smooth = I; % start with original

% Low variance
mask_smooth = S2 < S2_max/3;
I_temp = MyConv(I, kernel_smooth_large);
I_smooth(mask_smooth) = I_temp(mask_smooth);

% Medium variance 
mask_medium = (S2 >= S2_max/3) & (S2 < 2*S2_max/3);
I_temp = MyConv(I, kernel_smooth_small);
I_smooth(mask_medium) = I_temp(mask_medium);

% High variance
figure;
imagesc(I_smooth, [limMin, limMaxI])
colormap(gray), axis image, axis off
title('Adaptively Smoothed Image')
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'AdaptivelySmoothed')
end

% kernel size map
kernel_size_map = zeros(size(I));
for j = 1:ny
    for i = 1:nx
        if S2(j,i) < S2_max/4
            kernel_size_map(j,i) = 5;
        elseif S2(j,i) < S2_max/2  
            kernel_size_map(j,i) = 3;
        else
            kernel_size_map(j,i) = 1;
        end
    end
end

figure;
imagesc(kernel_size_map, [1, 5])
colormap(myposmapblk), axis image, axis off
title('Kernel Size Map')
colorbar
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'KernelSizeMap')
end

% difference
diff_image = abs(I - I_smooth);
figure;
imagesc(diff_image, [0, max(diff_image(:))])
colormap(myposmapblk), axis image, axis off
title('Difference Image (|Original - Smoothed|)')
colorbar
if (printfigs == 1)
    print(gcf, '-dtiffn', '-r100', 'DifferenceImage')
end