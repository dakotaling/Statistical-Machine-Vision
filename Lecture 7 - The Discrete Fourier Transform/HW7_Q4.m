% Code inspired by Professor Daniel Rowe
close all
clear all

% Based on sampleDFT2D.m
% Load the data from Question 2
load noisy.mat

% take inverse Fourier transforms
OmegaBarxC=zeros(nx,nx);
for k=1:nx         
   for j=1:nx
      OmegaBarxC(k,j)=exp(1i*2*pi*(k-(nx/2+1))*(j-(nx/2+1))/nx);
   end
end
OmegaBarxC=OmegaBarxC/nx;

OmegaBaryC=zeros(ny,ny);
for k=1:ny         
   for j=1:ny
      OmegaBaryC(k,j)=exp(1i*2*pi*(k-(ny/2+1))*(j-(ny/2+1))/ny);
   end
end
OmegaBaryC=OmegaBaryC/ny;

% Display original image
figure;
imagesc(Y)
axis image, colormap(gray), axis off
title('Original Image')

% Low-pass filter (remove high frequencies)
F_lowpass = F;

% Zero out the outer portions of the frequency domain
margin = floor(min(ny, nx) * 0.1); % 10% margin from edges
F_lowpass(1:margin, :) = 0;
F_lowpass(end-margin+1:end, :) = 0;
F_lowpass(:, 1:margin) = 0;
F_lowpass(:, end-margin+1:end) = 0;

% Display the low frequency
figure;
imagesc(real(F_lowpass))
axis image, axis off, colormap(gray)
title('Real Part of Low-Pass Filtered DFT')

figure;
imagesc(imag(F_lowpass))
axis image, axis off, colormap(gray)
title('Imaginary Part of Low-Pass Filtered DFT')

% Calculate inverse low-pass filter
Y_lowpass = (OmegaBaryC*F_lowpass*transpose(OmegaBarxC));

% Display the low-pass image
figure;
imagesc(real(Y_lowpass))
axis image, colormap(gray), axis off
title('Low-Pass Filtered Image (High Frequencies Removed)')

% High-pass filter (remove low frequencies)
F_highpass = F;
center_y = floor(ny/2) + 1;
center_x = floor(nx/2) + 1;
radius = floor(min(ny, nx) * 0.05); % 5% of image size

% Create a circular mask to zero out low frequencies
[Y_grid, X_grid] = meshgrid(1:nx, 1:ny);
mask = sqrt((X_grid - center_y).^2 + (Y_grid - center_x).^2) < radius;
F_highpass(mask) = 0;

% Display the highpass frequency
figure;
imagesc(real(F_highpass))
axis image, axis off, colormap(gray)
title('Real Part of High-Pass Filtered DFT')

figure;
imagesc(imag(F_highpass))
axis image, axis off, colormap(gray)
title('Imaginary Part of High-Pass Filtered DFT')

% Calculate inverse DFT of highpass
Y_highpass = (OmegaBaryC*F_highpass*transpose(OmegaBarxC));

% Display high-pass filtered image
figure;
imagesc(real(Y_highpass))
axis image, colormap(gray), axis off
title('High-Pass Filtered Image (Low Frequencies Removed)')

% Save results
save('filtered_results.mat', 'F_lowpass', 'F_highpass', 'Y_lowpass', 'Y_highpass');