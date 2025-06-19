% Code inspired by Professor Daniel Rowe
clear all
close all

I = imread('empire_state.jpg');

figure;
imagesc(I)
colormap(gray), axis off, axis image
title('Original Empire State Building Image')

[ny,nx] = size(I);

% Define derivative kernels
kernelx = [ones(3,1),zeros(3,1),-ones(3,1)]/6;
kernely = [ones(1,3);zeros(1,3);-ones(1,3)]/6;
kernelxx = [[1;2;1],[-2;-4;-2],[1;2;1]]/16;
kernelyy = [[1,2,1];[-2,-4,-2];[1,2,1]]/16;
kernelxy = [1,0,-1;0,0,0;-1,0,1]/16;

% Create zero-padded kernels for FFT
kernelfillx = zeros(ny,nx);  kernelfilly = zeros(ny,nx); 
kernelfillxx = zeros(ny,nx); kernelfillyy = zeros(ny,nx); 
kernelfillxy = zeros(ny,nx); 

[ky,kx] = size(kernelx);
if (mod(ky,2)==1)
    kernelfillx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelx;
    kernelfilly(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernely;
    kernelfillxx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelxx;
    kernelfillyy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelyy;
    kernelfillxy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelxy;
end

% Apply kernels using FFT convolution
ftI = fftshift(fft2(fftshift(I)));
ftkernx = fftshift(fft2(fftshift(kernelfillx)));
ftkerny = fftshift(fft2(fftshift(kernelfilly)));
ftkernxx = fftshift(fft2(fftshift(kernelfillxx)));
ftkernyy = fftshift(fft2(fftshift(kernelfillyy)));
ftkernxy = fftshift(fft2(fftshift(kernelfillxy)));

Ix = real(fftshift(ifft2(fftshift(ftkernx.*ftI))));
Iy = real(fftshift(ifft2(fftshift(ftkerny.*ftI))));
Ixx = real(fftshift(ifft2(fftshift(ftkernxx.*ftI))));
Iyy = real(fftshift(ifft2(fftshift(ftkernyy.*ftI))));
Ixy = real(fftshift(ifft2(fftshift(ftkernxy.*ftI))));

ED = zeros(ny,nx,2,2);
lambda1 = zeros(ny,nx);
lambda2 = zeros(ny,nx);

for j=1:ny
    for i=1:nx
        H = [Ixx(j,i),Ixy(j,i);Ixy(j,i),Iyy(j,i)];
        [V,D] = eig(H);
        ED(j,i,:,:) = D;
        lambda1(j,i) = D(1,1);
        lambda2(j,i) = D(2,2); 
    end
end

% Classify critical points based on eigenvalues
local_maxima = (lambda1 < 0) & (lambda2 < 0);
local_minima = (lambda1 > 0) & (lambda2 > 0);
saddle_points = (lambda1.*lambda2 < 0);

% Display results
figure;
imagesc(local_maxima)
colormap(gray), axis off, axis image
title('Local Maxima (white pixels)')

figure;
imagesc(local_minima)
colormap(gray), axis off, axis image
title('Local Minima (white pixels)')

figure;
imagesc(saddle_points)
colormap(gray), axis off, axis image
title('Saddle Points (white pixels)')

% Display eigenvalue images
figure;
imagesc(lambda1)
colormap(gray), axis off, axis image
title('First Eigenvalue λ1')

figure;
imagesc(lambda2)
colormap(gray), axis off, axis image
title('Second Eigenvalue λ2')

combined = zeros(ny,nx,3);
combined(:,:,1) = local_maxima;  
combined(:,:,2) = local_minima;   
combined(:,:,3) = saddle_points; 

figure;
image(combined)
axis off, axis image
title('Combined: Red=Maxima, Green=Minima, Blue=Saddle Points')