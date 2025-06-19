% Code inspired by Professor Daniel Rowe
clear all
close all

% HOMEWORK PROBLEM: Edge Detection and Structural Analysis using Derivatives
% Problem: Analyze the Empire State Building image using derivative information
% to detect edges, measure edge strength, and identify structural features.

I = imread('empire_state.jpg');

figure;
imagesc(I)
colormap(gray), axis off, axis image
title('Original Empire State Building Image')

[ny,nx] = size(I);

% Compute derivatives 
kernelx = [ones(3,1),zeros(3,1),-ones(3,1)]/6;
kernely = [ones(1,3);zeros(1,3);-ones(1,3)]/6;
kernelxx = [[1;2;1],[-2;-4;-2],[1;2;1]]/16;
kernelyy = [[1,2,1];[-2,-4,-2];[1,2,1]]/16;
kernelxy = [1,0,-1;0,0,0;-1,0,1]/16;

kernelfillx = zeros(ny,nx); kernelfilly = zeros(ny,nx); 
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

% PART 1: Edge Detection and Analysis
gradient_magnitude = sqrt(Ix.^2 + Iy.^2);
gradient_direction = atan2(Iy, Ix);

% Detect strong edges using threshold
edge_threshold = 0.3 * max(gradient_magnitude(:));
strong_edges = gradient_magnitude > edge_threshold;

figure;
imagesc(gradient_magnitude)
colormap(gray), axis off, axis image
title('Gradient Magnitude (Edge Strength)')

figure;
imagesc(gradient_direction)
colormap(hsv), axis off, axis image
title('Gradient Direction (Edge Orientation)')

figure;
imagesc(strong_edges)
colormap(gray), axis off, axis image
title('Strong Edges (Binary)')

% PART 2: Structural Feature Analysis
mean_curvature = 0.5 * (Ixx + Iyy);
gaussian_curvature = Ixx.*Iyy - Ixy.^2;

figure;
imagesc(mean_curvature)
colormap(gray), axis off, axis image
title('Mean Curvature')

figure;
imagesc(gaussian_curvature)
colormap(gray), axis off, axis image
title('Gaussian Curvature')

% PART 3: Corner Detection using Harris Response
k = 0.04;
det_H = Ixx.*Iyy - Ixy.^2;  % Determinant of Hessian
trace_H = Ixx + Iyy;        % Trace of Hessian
harris_response = det_H - k*(trace_H.^2);

% Find corner points
corner_threshold = 0.1 * max(harris_response(:));
corners = harris_response > corner_threshold;

figure;
imagesc(harris_response)
colormap(gray), axis off, axis image
title('Harris Corner Response')

figure;
imagesc(corners)
colormap(gray), axis off, axis image
title('Detected Corners (white pixels)')

% PART 4: Texture Analysis
% Calculate local texture measures
structure_tensor = zeros(ny,nx,2,2);
for j=1:ny
    for i=1:nx
        structure_tensor(j,i,:,:) = [Ix(j,i)*Ix(j,i), Ix(j,i)*Iy(j,i);
                                    Ix(j,i)*Iy(j,i), Iy(j,i)*Iy(j,i)];
    end
end

% Coherence measure (anisotropy)
coherence = zeros(ny,nx);
for j=1:ny
    for i=1:nx
        S = squeeze(structure_tensor(j,i,:,:));
        [V,D] = eig(S);
        lambda1 = D(2,2);
        lambda2 = D(1,1);
        if lambda1 + lambda2 > 0
            coherence(j,i) = (lambda1 - lambda2)/(lambda1 + lambda2);
        end
    end
end

figure;
imagesc(coherence)
colormap(gray), axis off, axis image
title('Texture Coherence (0=isotropic, 1=anisotropic)')

% PART 5: Summary Statistics
fprintf('IMAGE ANALYSIS RESULTS:\n');
fprintf('Total strong edge pixels: %d (%.1f%% of image)\n', ...
    sum(strong_edges(:)), 100*sum(strong_edges(:))/(ny*nx));
fprintf('Total corner pixels: %d\n', sum(corners(:)));
fprintf('Mean gradient magnitude: %.3f\n', mean(gradient_magnitude(:)));
fprintf('Mean coherence: %.3f\n', mean(coherence(:)));
fprintf('Range of curvature values: [%.3f, %.3f]\n', ...
    min(mean_curvature(:)), max(mean_curvature(:)));