% Code inspired by PRofessor Daniel Rowe
% Based on ftConvImCar.m
clear all
close all

printfigs=0;

% Load image
I_rgb = imread('tiny_boat.jpg');
I = double(rgb2gray(I_rgb));
[ny,nx] = size(I);

figure;
imagesc(I,[0,255])
colormap(gray), axis image, axis off
title('Original Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ioriginal')
end

% Add strong left-right plane wave (from ftConvIm.m)
A_wave = 100;
nu_wave = 8/nx;  % 8 cycles across image width

[X, Y] = meshgrid(1:nx, 1:ny);
plane_wave = A_wave * cos(2*pi*nu_wave*(X-1));
I_with_wave = I + plane_wave;

figure;
imagesc(I_with_wave,[0,255+A_wave])
colormap(gray), axis image, axis off
title('Image with Added Plane Wave')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Iwave')
end

% Forward FFT of image with plane wave
ftI_wave = fftshift(fft2(fftshift(I_with_wave)));

figure;
imagesc(log(abs(ftI_wave)+1))
colormap(gray), axis image, axis off
title('FFT of Image with Plane Wave')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIwave')
end

% Find coefficients for plane wave frequency
deltakx = 1/nx; deltaky = 1/ny;
kx = ((1:nx) - nx/2 - 1) * deltakx;
ky = ((1:ny) - ny/2 - 1) * deltaky;

[~, kx_idx] = min(abs(kx - nu_wave));
[~, ky_idx] = min(abs(ky - 0));
[~, kx_idx_neg] = min(abs(kx + nu_wave));

coeff_pos = ftI_wave(ky_idx, kx_idx);
coeff_neg = ftI_wave(ky_idx, kx_idx_neg);

expected_amplitude = A_wave * nx * ny / 2;
actual_amplitude = abs(coeff_pos);
fprintf('Expected amplitude: %.1f, Actual: %.1f\n', expected_amplitude, actual_amplitude);

% Set frequency pair to zero and inverse transform
ftI_wave_removed = ftI_wave;
ftI_wave_removed(ky_idx, kx_idx) = 0;      % positive frequency
ftI_wave_removed(ky_idx, kx_idx_neg) = 0;  % negative frequency

I_wave_removed = fftshift(ifft2(fftshift(ftI_wave_removed)));

figure;
imagesc(real(I_wave_removed),[0,255])
colormap(gray), axis image, axis off
title('Image with Plane Wave Removed')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Iremoved')
end