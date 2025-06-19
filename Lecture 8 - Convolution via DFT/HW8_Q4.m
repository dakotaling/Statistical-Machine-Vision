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

% Apply kernel by moving across (from ftConvImCar.m)
kernel=[0,1,0;1,1,1;0,1,0]/5;
[a,b]=size(kernel);

% appends border pixels for wrap-around
IW=[I(ny-(a-1)/2+1:ny,nx-(b-1)/2+1:nx),I(ny-(a-1)/2+1:ny,1:nx),I(ny-(a-1)/2+1:ny,1:(b-1)/2);...
    I(1:ny         ,nx-(b-1)/2+1:nx)  ,I(1:ny           ,1:nx),I(1:ny           ,1:(b-1)/2);...
    I(1:(a-1)/2    ,nx-(b-1)/2+1:nx)  ,I(1:(a-1)/2      ,1:nx),I(1:(a-1)/2      ,1:(b-1)/2)];

% perform convolution
Ism=zeros(ny,nx);
for j=1:ny
    for i=1:nx
        Ism(j,i)=sum(sum(kernel.*IW(j:j+a-1,i:i+b-1)));
    end
end

figure;
imagesc(Ism,[0,255])
colormap(gray), axis image, axis off
title('Smoothed Image (Direct Convolution)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','IsmDirect')
end

% FFT convolution (from ftConvImCar.m)
kMat=zeros(ny,nx);
kMat(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1,nx/2-(a-1)/2+1:nx/2+(a-1)/2+1)=kernel;

ftI=fftshift(fft2(fftshift(I)));
ftkMat=fftshift(fft2(fftshift(kMat)));

figure;
imagesc(real(ftkMat),[0,1])
axis image, axis off, colormap(gray)
title('FFT of Kernel')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftkMatR')
end

ftkMatftI=ftkMat.*ftI;
IsmFT=fftshift(ifft2(fftshift(ftkMatftI)));

figure;
imagesc(real(IsmFT),[0,255])
colormap(gray), axis image, axis off
title('Smoothed Image (FFT Convolution)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','IsmFFT')
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

% Forward FFT of new image
ftI_wave = fftshift(fft2(fftshift(I_with_wave)));

figure;
imagesc(log(abs(ftI_wave)+1))
colormap(gray), axis image, axis off
title('FFT of Image with Plane Wave')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIwave')
end

%% Find coefficients for plane wave frequency
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