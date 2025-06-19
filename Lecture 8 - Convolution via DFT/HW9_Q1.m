% FFT-based Template Matching with Complete Visualization
% Based on templateCorr.m - simplified for demonstration

clear all; close all;

% Read and prepare image
I = imread('feeding_pigeons.jpg'); % Replace with your image file
I = I(:,:,1); % Using first image

I = double(I);
[ny, nx] = size(I);

% Create or extract template (modify coordinates for your image)
% Example: extract a small region as template
template = I(50:100, 50:100); % Adjust these coordinates
[a, b] = size(template);

% Display original image
figure(1);
imagesc(I, [0, 255]);
colormap(gray); axis image; axis off;
title('Original Image I');

% Display template
figure(2);
imagesc(template, [0, 255]);
colormap(gray); axis image; axis off;
title('Template');

% Create I^2 for variance calculation
I2 = I.^2;
figure(3);
imagesc(I2, [0, 255^2]);
colormap(gray); axis image; axis off;
title('Image Squared (I^2)');

% Create centered kernel of ones (same size as template)
tones = ones(a, b);
tonesfill = zeros(ny, nx);
% Center the ones kernel
if mod(a,2) == 1
    tonesfill(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1, nx/2-(b-1)/2+1:nx/2+(b-1)/2+1) = tones;
else
    tonesfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = tones;
end

figure(4);
imagesc(tonesfill, [0, 1]);
colormap(gray); axis image; axis off;
title('Centered Kernel (ones)');

% Create centered template
tfill = zeros(ny, nx);
tfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = template;

figure(5);
imagesc(tfill, [0, 255]);
colormap(gray); axis image; axis off;
title('Centered Template');

% Calculate FFTs
ftI = fftshift(fft2(fftshift(I)));           % FFT of image
ftI2 = fftshift(fft2(fftshift(I2)));         % FFT of image squared
ftt1fill = fftshift(fft2(fftshift(tonesfill))); % FFT of ones kernel
fttfill = fftshift(fft2(fftshift(tfill)));   % FFT of template

% Display FFT of image (log scale for visibility)
figure(6);
imagesc(log(abs(real(ftI))+1));
colormap(gray); axis image; axis off;
title('FFT of Image I (log scale)');

% Display FFT of image squared
figure(7);
imagesc(log(abs(real(ftI2))+1));
colormap(gray); axis image; axis off;
title('FFT of Image Squared (log scale)');

% Display FFT of ones kernel
figure(8);
imagesc(log(abs(real(ftt1fill))+1));
colormap(gray); axis image; axis off;
title('FFT of Ones Kernel (log scale)');

% Display FFT of template
figure(9);
imagesc(log(abs(real(fttfill))+1));
colormap(gray); axis image; axis off;
title('FFT of Template (log scale)');

% Calculate products and inverse FFTs for correlation
% Precompute template statistics
Sx = sum(template(:));
Sx2 = sum(template(:).^2);
Varx = (Sx2 - Sx^2/(a*b))/(a*b-1);

% Calculate local sums using FFT
Sy = real(fftshift(ifft2(fftshift(ftI .* ftt1fill))));      % sum(y)
Sy2 = real(fftshift(ifft2(fftshift(ftI2 .* ftt1fill))));    % sum(y^2)
Sxy = real(fftshift(ifft2(fftshift(ftI .* conj(fttfill))))); % sum(xy)

% Display products of FFTs (before inverse transform)
figure(10);
imagesc(log(abs(real(ftI .* ftt1fill))+1));
colormap(gray); axis image; axis off;
title('Product: FFT(I) * FFT(ones) (log scale)');

figure(11);
imagesc(log(abs(real(ftI .* conj(fttfill)))+1));
colormap(gray); axis image; axis off;
title('Product: FFT(I) * conj(FFT(template)) (log scale)');

% Display inverse FFTs (local sums)
figure(12);
imagesc(Sy, [0, a*b*255]);
colormap(gray); axis image; axis off;
title('Local Sum(y) - IFFT result');

figure(13);
imagesc(Sy2, [0, a*b*255^2]);
colormap(gray); axis image; axis off;
title('Local Sum(y^2) - IFFT result');

figure(14);
imagesc(Sxy);
colormap(gray); axis image; axis off;
title('Local Sum(xy) - IFFT result');

% Calculate variance of local patches
Vary = (Sy2 - (Sy.^2)/(a*b))/(a*b-1);

figure(15);
imagesc(Vary);
colormap(gray); axis image; axis off;
title('Local Variance Image');

% Calculate correlation
Covxy = (Sxy - (Sx*Sy)/(a*b))/(a*b-1);
Corxy = Covxy ./ sqrt(Varx * Vary);

% Display final correlation image
figure(16);
imagesc(Corxy, [-1, 1]);
colormap(gray); axis image; axis off;
title('Correlation Image');

% Find maximum correlation and draw bounding box
[maxval, maxidx] = max(Corxy(:));
[indy, indx] = ind2sub(size(Corxy), maxidx);

figure(17);
imagesc(I, [0, 255]);
colormap(gray); axis image; axis off;
title(['Template Match (correlation = ', num2str(maxval, '%.3f'), ')']);
hold on;
% Draw bounding box around best match
rectangle('Position', [indx-b/2, indy-a/2, b, a], 'EdgeColor', 'm', 'LineWidth', 2);
hold off;