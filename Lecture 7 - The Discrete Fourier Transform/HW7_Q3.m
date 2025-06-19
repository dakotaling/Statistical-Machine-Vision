% Code inspired by Professor Daniel Rowe
close all
clear all

% Based on sampleDFT2D.m
% Load the data from Question 2
load noisy.mat

% Extract center using ny/2 * nx/2 portion
ny_reduced = floor(ny/2);
nx_reduced = floor(nx/2);

% Get center portion
start_y = floor(ny/4) + 1;
start_x = floor(nx/4) + 1;
end_y = start_y + ny_reduced - 1;
end_x = start_x + nx_reduced - 1;
F_reduced = F(start_y:end_y, start_x:end_x);

% Display reduced frequency
figure;
imagesc(real(F_reduced))
axis image, axis off, colormap(gray)
title('Real Part of Reduced 2D DFT')

figure;
imagesc(imag(F_reduced))
axis image, axis off, colormap(gray)
title('Imaginary Part of Reduced 2D DFT')

% take inverse Fourier transforms
OmegaBarxC_reduced=zeros(nx_reduced,nx_reduced);
for k=1:nx_reduced         
   for j=1:nx_reduced
      OmegaBarxC_reduced(k,j)=exp(1i*2*pi*(k-(nx_reduced/2+1))*(j-(nx_reduced/2+1))/nx_reduced);
   end
end
OmegaBarxC_reduced=OmegaBarxC_reduced/nx_reduced;

OmegaBaryC_reduced=zeros(ny_reduced,ny_reduced);
for k=1:ny_reduced         
   for j=1:ny_reduced
      OmegaBaryC_reduced(k,j)=exp(1i*2*pi*(k-(ny_reduced/2+1))*(j-(ny_reduced/2+1))/ny_reduced);
   end
end
OmegaBaryC_reduced=OmegaBaryC_reduced/ny_reduced;

% Calculate inverse DFT
Y_reduced = (OmegaBaryC_reduced*F_reduced*transpose(OmegaBarxC_reduced));

% Display the reconstructed image
figure;
imagesc(real(Y_reduced))
axis image, colormap(gray), axis off
title('Reconstructed Image from Reduced DFT (Real Part)')

figure;
imagesc(imag(Y_reduced))
axis image, colormap(gray), axis off
title('Reconstructed Image from Reduced DFT (Imaginary Part)')

save('reduced_dft_results.mat', 'F_reduced', 'Y_reduced', 'ny_reduced', 'nx_reduced');