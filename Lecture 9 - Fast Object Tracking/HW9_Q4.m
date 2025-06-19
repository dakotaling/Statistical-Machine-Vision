% Code inspired by Professor Daniel Rowe
clear all; close all;

% Load and prepare image
I = imread('cat.jpg');
I = double(I);
[ny, nx] = size(I);

figure; imagesc(I); colormap(gray); axis image; axis off;
title('Input Image (cat.jpeg)');

% Create template (extract from image)
template = I(520:619, 980:1079); % 51x51 template
[a, b] = size(template);

figure; imagesc(template); colormap(gray); axis image; axis off;
title('Template (51x51)');

% Template statistics for normalized correlation
Sx = sum(template(:));
Sx2 = sum(template(:).^2);
nn = a * b;
Varx = (Sx2 - Sx^2/nn)/(nn-1);

fprintf('Image size: %dx%d\n', ny, nx);
fprintf('Template size: %dx%d\n', a, b);
fprintf('Starting correlation comparison...\n\n');

tic; % Start timing

% Initialize output
Corxy_spatial = zeros(ny, nx);

% Pad image for border handling
pad_y = floor(a/2); pad_x = floor(b/2);
I_padded = padarray(I, [pad_y, pad_x], 'replicate');

% Template as vector for dot product
template_vec = template(:);

% Manual correlation with nested loops
for j = 1:ny
    for i = 1:nx
        % Extract patch from padded image
        patch = I_padded(j:j+a-1, i:i+b-1);
        patch_vec = patch(:);
        
        % Compute correlation statistics
        Sy = sum(patch_vec);
        Sy2 = sum(patch_vec.^2);
        Sxy = sum(patch_vec .* template_vec);
        
        % Compute normalized correlation
        Vary = (Sy2 - Sy^2/nn)/(nn-1);
        Covxy = (Sxy - Sx*Sy/nn)/(nn-1);
        
        % Avoid division by zero
        if Vary > 0 && Varx > 0
            Corxy_spatial(j,i) = Covxy / sqrt(Varx * Vary);
        else
            Corxy_spatial(j,i) = 0;
        end
    end
    
    % Progress indicator
    if mod(j, 20) == 0
        fprintf('Processed row %d/%d\n', j, ny);
    end
end

time_spatial = toc; % End timing
fprintf('Image space correlation time: %.4f seconds\n', time_spatial);

% Find best match in spatial result
[maxval_spatial, maxidx_spatial] = max(Corxy_spatial(:));
[max_y_spatial, max_x_spatial] = ind2sub(size(Corxy_spatial), maxidx_spatial);

% Display spatial correlation result
figure; imagesc(Corxy_spatial, [-1, 1]); colormap(jet); axis image; axis off;
title(sprintf('Image Space Correlation (Time: %.4fs)', time_spatial));
hold on;
rectangle('Position', [max_x_spatial-b/2, max_y_spatial-a/2, b, a], ...
          'EdgeColor', 'm', 'LineWidth', 2);
text(max_x_spatial, max_y_spatial-a/2-5, sprintf('Max: %.3f', maxval_spatial), ...
     'Color', 'm', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
hold off;

tic;

% Create centered kernel of ones
tones = ones(a, b);
tonesfill = zeros(ny, nx);
if mod(a,2) == 1
    tonesfill(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1, nx/2-(b-1)/2+1:nx/2+(b-1)/2+1) = tones;
else
    tonesfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = tones;
end

% Create centered template
tfill = zeros(ny, nx);
tfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = template;

% Compute DFTs
ftI = fftshift(fft2(fftshift(I))); % DFT of image
ftI2 = fftshift(fft2(fftshift(I.^2))); % DFT of image squared
ftt1fill = fftshift(fft2(fftshift(tonesfill))); % DFT of kernel
fttfill = fftshift(fft2(fftshift(tfill))); % DFT of template

% Compute sums via inverse DFT
Sy = real(fftshift(ifft2(fftshift(ftI .* ftt1fill)))); % Sum of y
Sy2 = real(fftshift(ifft2(fftshift(ftI2 .* ftt1fill)))); % Sum of y^2
Sxy = real(fftshift(ifft2(fftshift(ftI .* conj(fttfill))))); % Sum of xy

% Compute correlation
Vary = (Sy2 - (Sy.^2)/nn)/(nn-1);
Covxy = (Sxy - (Sx*Sy)/nn)/(nn-1);
Corxy_dft = Covxy ./ sqrt(Varx * Vary);

% Handle NaN values
Corxy_dft(isnan(Corxy_dft)) = 0;

time_dft = toc; % End timing
fprintf('DFT space correlation time: %.4f seconds\n', time_dft);

% Find best match in DFT result
[maxval_dft, maxidx_dft] = max(Corxy_dft(:));
[max_y_dft, max_x_dft] = ind2sub(size(Corxy_dft), maxidx_dft);

% Display DFT correlation result
figure; imagesc(Corxy_dft, [-1, 1]); colormap(jet); axis image; axis off;
title(sprintf('DFT Space Correlation (Time: %.4fs)', time_dft));
hold on;
rectangle('Position', [max_x_dft-b/2, max_y_dft-a/2, b, a], ...
          'EdgeColor', 'm', 'LineWidth', 2);
text(max_x_dft, max_y_dft-a/2-5, sprintf('Max: %.3f', maxval_dft), ...
     'Color', 'm', 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
hold off;

figure;
subplot(2,3,1); imagesc(I); colormap(gray); axis image; axis off;
title('Original Image');

subplot(2,3,2); imagesc(I.^2); colormap(gray); axis image; axis off;
title('Image Squared');

subplot(2,3,3); imagesc(tonesfill); colormap(gray); axis image; axis off;
title('Centered Kernel');

subplot(2,3,4); imagesc(tfill); colormap(gray); axis image; axis off;
title('Centered Template');

subplot(2,3,5); imagesc(log(abs(ftI)+1)); colormap(gray); axis image; axis off;
title('DFT of Image (log)');

subplot(2,3,6); imagesc(log(abs(fttfill)+1)); colormap(gray); axis image; axis off;
title('DFT of Template (log)');

% Display DFT intermediate results
figure;
subplot(2,2,1); imagesc(Sy); colormap(gray); axis image; axis off;
title('Sum(y) via IDFT');

subplot(2,2,2); imagesc(Sy2); colormap(gray); axis image; axis off;
title('Sum(y^2) via IDFT');

subplot(2,2,3); imagesc(Sxy); colormap(gray); axis image; axis off;
title('Sum(xy) via IDFT');

subplot(2,2,4); imagesc(Vary); colormap(gray); axis image; axis off;
title('Variance Image');

% Compare correlation results
correlation_diff = abs(Corxy_spatial - Corxy_dft);
max_diff = max(correlation_diff(:));
mean_diff = mean(correlation_diff(:));

% Display difference map
figure; imagesc(correlation_diff); colormap(hot); axis image; axis off;
title(sprintf('Correlation Difference (Max: %.6f)', max_diff));
colorbar;

% Side-by-side comparison
figure;
subplot(1,3,1);
imagesc(Corxy_spatial, [-1, 1]); colormap(jet); axis image; axis off;
title(sprintf('Spatial (%.4fs)', time_spatial));

subplot(1,3,2);
imagesc(Corxy_dft, [-1, 1]); colormap(jet); axis image; axis off;
title(sprintf('DFT (%.4fs)', time_dft));

subplot(1,3,3);
imagesc(correlation_diff); colormap(hot); axis image; axis off;
title(sprintf('Difference (Max: %.6f)', max_diff));

% Display original image with both results
figure;
imagesc(I); colormap(gray); axis image; axis off;
title('Template Matching Results Comparison');
hold on;
% Spatial result in magenta
rectangle('Position', [max_x_spatial-b/2, max_y_spatial-a/2, b, a], ...
          'EdgeColor', 'm', 'LineWidth', 2, 'LineStyle', '-');
% DFT result in cyan
rectangle('Position', [max_x_dft-b/2, max_y_dft-a/2, b, a], ...
          'EdgeColor', 'c', 'LineWidth', 2, 'LineStyle', '--');
legend('Spatial Method', 'DFT Method', 'Location', 'best');
hold off;

spatial_ops = ny * nx * a * b; % Approximate operations for spatial method
dft_ops = ny * nx * log2(ny * nx) * 6; % Approximate operations for DFT method (6 FFTs)