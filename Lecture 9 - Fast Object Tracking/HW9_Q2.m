% Code inspired by Professor Daniel Rowe
clear all
close all

filename = 'dog.mp4';
vidObj = VideoReader(filename);
nt = vidObj.NumFrames;
nx = vidObj.Width;
ny = vidObj.Height;
fr = vidObj.FrameRate;

% Read and convert video to grayscale
videoRGB = read(vidObj, [1 nt]);
I = zeros([ny, nx, nt]);
for t = 1:nt
    I(:,:,t) = rgb2gray(videoRGB(:,:,:,t));
end
I = double(I);
clear videoRGB;

% Display video frames
figure;
for t = 1:nt
    imagesc(I(:,:,t)); colormap(gray); axis image; axis off;
    title(['Frame ', num2str(t)]);
    pause(0.1);
end

% Extract template from first frame
template = I(571:670, 175:274, 1); 
[a, b] = size(template);
figure; imagesc(template); colormap(gray); axis image; axis off;
title('Template for Tracking'); % Template image

% Template statistics
Sx = sum(template(:));
Sx2 = sum(template(:).^2);
nn = a * b;
Varx = (Sx2 - Sx^2/nn)/(nn-1);

% Create centered kernel
tones = ones(a, b);
tonesfill = zeros(ny, nx);
if mod(a,2) == 1
    tonesfill(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1, nx/2-(b-1)/2+1:nx/2+(b-1)/2+1) = tones;
else
    tonesfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = tones;
end
figure; imagesc(tonesfill); colormap(gray); axis image; axis off;
title('Centered Kernel of Ones'); % Centered kernel

% Create centered template
tfill = zeros(ny, nx);
tfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = template;
figure; imagesc(tfill); colormap(gray); axis image; axis off;
title('Centered Template');

% DFTs of kernel and template
ftt1fill = fftshift(fft2(fftshift(tonesfill)));
fttfill = fftshift(fft2(fftshift(tfill))); 

figure; imagesc(log(abs(ftt1fill)+1)); colormap(gray); axis image; axis off;
title('DFT of Kernel (log magnitude)');

figure; imagesc(log(abs(fttfill)+1)); colormap(gray); axis image; axis off;
title('DFT of Template (log magnitude)');

% Process sample frame to show all intermediate steps
t_sample = round(nt/2);
I_frame = I(:,:,t_sample);
I2_frame = I_frame.^2;

% Display sample frame and I^2
figure; imagesc(I_frame); colormap(gray); axis image; axis off;
title(['Sample Frame ', num2str(t_sample)]); % Sample frame

figure; imagesc(I2_frame); colormap(gray); axis image; axis off;
title(['Sample Frame^2 ', num2str(t_sample)]); % Sample I^2

ftI = fftshift(fft2(fftshift(I_frame))); % DFT of I
ftI2 = fftshift(fft2(fftshift(I2_frame))); % DFT of I^2

figure; imagesc(log(abs(ftI)+1)); colormap(gray); axis image; axis off;
title(['DFT of Frame ', num2str(t_sample), ' (log magnitude)']); % DFT of I

figure; imagesc(log(abs(ftI2)+1)); colormap(gray); axis image; axis off;
title(['DFT of Frame^2 ', num2str(t_sample), ' (log magnitude)']); % DFT of I^2

% Compute products and inverse DFTs for sample frame
Sy = real(fftshift(ifft2(fftshift(ftI .* ftt1fill)))); % Sum of y
Sy2 = real(fftshift(ifft2(fftshift(ftI2 .* ftt1fill)))); % Sum of y^2
Sxy = real(fftshift(ifft2(fftshift(ftI .* conj(fttfill))))); % Sum of xy

% Display intermediate results for sample frame
figure; imagesc(Sy); colormap(gray); axis image; axis off;
title(['Sum(y) Frame ', num2str(t_sample)]); % Sum of y

figure; imagesc(Sy2); colormap(gray); axis image; axis off;
title(['Sum(y^2) Frame ', num2str(t_sample)]); % Sum of y^2

figure; imagesc(Sxy); colormap(gray); axis image; axis off;
title(['Sum(xy) Frame ', num2str(t_sample)]); % Sum of xy

% Compute variance and correlation for sample frame
Vary = (Sy2 - (Sy.^2)/nn)/(nn-1); % Variance of y
Covxy = (Sxy - (Sx*Sy)/nn)/(nn-1); % Covariance
Corxy = Covxy ./ sqrt(Varx * Vary); % Correlation

% Display variance and correlation for sample frame
figure; imagesc(Vary); colormap(gray); axis image; axis off;
title(['Variance Image Frame ', num2str(t_sample)]); % Variance image

figure; imagesc(Corxy, [-1, 1]); colormap(gray); axis image; axis off;
title(['Correlation Image Frame ', num2str(t_sample)]); % Correlation image

% Track object through all frames
Corxy_all = zeros(ny, nx, nt);
track_results = zeros(3, nt); % [y_pos; x_pos; max_correlation]

fprintf('Processing frames for tracking...\n');
figure;
for t = 1:nt
    ftI = fftshift(fft2(fftshift(I(:,:,t))));
    ftI2 = fftshift(fft2(fftshift((I(:,:,t)).^2)));
    
    Sy = real(fftshift(ifft2(fftshift(ftI .* ftt1fill))));
    Sy2 = real(fftshift(ifft2(fftshift(ftI2 .* ftt1fill))));
    Sxy = real(fftshift(ifft2(fftshift(ftI .* conj(fttfill)))));
    
    Vary = (Sy2 - (Sy.^2)/nn)/(nn-1);
    Covxy = (Sxy - (Sx*Sy)/nn)/(nn-1);
    Corxy_all(:,:,t) = Covxy ./ sqrt(Varx * Vary);
    
    [maxval, maxidx] = max(Corxy_all(:,:,t), [], 'all');
    [max_y, max_x] = ind2sub([ny, nx], maxidx);
    track_results(:,t) = [max_y; max_x; maxval];
    
    imagesc(I(:,:,t)); colormap(gray); axis image; axis off;
    title(['Frame ', num2str(t), ' - Correlation: ', num2str(maxval, '%.3f')]);
    hold on;
    if maxval >= 0.5 % Only show bounding box if correlation is high
        rectangle('Position', [max_x-b/2, max_y-a/2, b, a], ...
                  'EdgeColor', 'm', 'LineWidth', 2);
    end
    hold off;
    pause(0.1);
    
    if mod(t, 10) == 0
        fprintf('Processed frame %d/%d\n', t, nt);
    end
end

% Display tracking trajectory
figure;
plot(track_results(2,:), track_results(1,:), 'r-o', 'LineWidth', 2);
xlabel('X Position'); ylabel('Y Position');
title('Object Tracking Trajectory');
axis ij; grid on;

% Display correlation over time
figure;
plot(1:nt, track_results(3,:), 'b-', 'LineWidth', 2);
xlabel('Frame Number'); ylabel('Max Correlation');
title('Correlation Score Over Time');
grid on;

% Create tracking video with correlation overlay
figure;
for t = 1:nt
    subplot(1,2,1);
    imagesc(I(:,:,t)); colormap(gray); axis image; axis off;
    title(['Frame ', num2str(t)]);
    hold on;
    max_y = track_results(1,t); max_x = track_results(2,t);
    if track_results(3,t) >= 0.5
        rectangle('Position', [max_x-b/2, max_y-a/2, b, a], ...
                  'EdgeColor', 'm', 'LineWidth', 2);
    end
    hold off;
    
    subplot(1,2,2);
    imagesc(Corxy_all(:,:,t), [-1, 1]); axis image; axis off;
    title(['Correlation Map Frame ', num2str(t)]);
    colormap(gca, 'jet');
    
    pause(1/fr);
end

fprintf('Template matching complete!\n');