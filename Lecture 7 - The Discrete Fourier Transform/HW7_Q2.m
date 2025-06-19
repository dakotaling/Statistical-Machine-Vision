% Code inspired by Professor Daniel Rowe
close all
clear all

% Based on sampleDFT2D.m
% Load the image "noisy_image.jpg"
img = imread('noisy_image.jpg');
if size(img, 3) == 3
    img = img(:,:,1); % Using first image
end

Y = double(img);
[ny, nx] = size(Y);

figure;
imagesc(Y)
axis image, axis off, colormap(gray)
title('Original Image')

% DFT by matrix multiplication
OmegaxC=zeros(nx,nx);
for k=1:nx        
   for j=1:nx
      OmegaxC(k,j)=exp(-1i*2*pi*(k-(nx/2+1))*(j-(nx/2+1))/nx);
   end
end
OmegayC=zeros(ny,ny);
for k=1:ny         
   for j=1:ny
      OmegayC(k,j)=exp(-1i*2*pi*(k-(ny/2+1))*(j-(ny/2+1))/ny);
   end
end

% Calculate 2D DFT
F  = (OmegayC*Y *transpose(OmegaxC));

% Display real 2D DFT
figure;
imagesc(real(F))
axis image, axis off, colormap(gray)
title('Real Part of 2D DFT')

% Display imaginary 2D DFT
figure;
imagesc(imag(F))
axis image, axis off, colormap(gray)
title('Imaginary Part of 2D DFT')

save('noisy.mat', 'F', 'Y', 'ny', 'nx', 'OmegaxC', 'OmegayC');