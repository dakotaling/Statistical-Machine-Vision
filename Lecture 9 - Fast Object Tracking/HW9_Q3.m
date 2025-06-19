% Code inspired by Professor Daniel Rowe
clear all; close all;

filename = 'sidewalk.mp4';
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

% Extract 4 templates at specified locations and times
templates = cell(4,1);
template_info = cell(4,1);

% Template 1: Second 1
templates{1} = I(570:630, 120:150, 1);
template_info{1} = struct('name', 'Template 1 (Sec 1)', 'frame', 1, 'color', 'm');

% Template 2: Second 1
templates{2} = I(570:630, 825:850, 1);
template_info{2} = struct('name', 'Template 2 (Sec 1)', 'frame', 1, 'color', 'c');

% Template 3: Second 3
frame3 = min(round(3 * fr), nt);
templates{3} = I(550:720, 1:70, frame3); % Adjusted to 1:70 since 0:70 would be invalid
template_info{3} = struct('name', 'Template 3 (Sec 3)', 'frame', frame3, 'color', 'y');

% Template 4: Second 9
frame9 = min(round(9 * fr), nt);
templates{4} = I(525:720, 1:70, frame9); % Adjusted to 1:70 since 0:70 would be invalid
template_info{4} = struct('name', 'Template 4 (Sec 9)', 'frame', frame9, 'color', 'g');

% Display all templates
figure;
for i = 1:4
    subplot(2,2,i);
    imagesc(templates{i}); colormap(gray); axis image; axis off;
    title([template_info{i}.name, ' (Frame ', num2str(template_info{i}.frame), ')']);
end

% Initialize tracking arrays
num_templates = 4;
template_sizes = cell(num_templates, 1);
template_stats = cell(num_templates, 1);
centered_templates = cell(num_templates, 1);
centered_kernels = cell(num_templates, 1);
fft_kernels = cell(num_templates, 1);
fft_templates = cell(num_templates, 1);
track_results = cell(num_templates, 1);

for i = 1:num_templates
    [a, b] = size(templates{i});
    template_sizes{i} = [a, b];
    
    Sx = sum(templates{i}(:));
    Sx2 = sum(templates{i}(:).^2);
    nn = a * b;
    Varx = (Sx2 - Sx^2/nn)/(nn-1);
    template_stats{i} = struct('Sx', Sx, 'Sx2', Sx2, 'nn', nn, 'Varx', Varx);
    
    tones = ones(a, b);
    tonesfill = zeros(ny, nx);
    if mod(a,2) == 1
        tonesfill(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1, nx/2-(b-1)/2+1:nx/2+(b-1)/2+1) = tones;
    else
        tonesfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = tones;
    end
    centered_kernels{i} = tonesfill;
    
    tfill = zeros(ny, nx);
    tfill(ny/2-a/2+1:ny/2+a/2, nx/2-b/2+1:nx/2+b/2) = templates{i};
    centered_templates{i} = tfill;
   
    fft_kernels{i} = fftshift(fft2(fftshift(tonesfill)));
    fft_templates{i} = fftshift(fft2(fftshift(tfill)));
    
    track_results{i} = zeros(3, nt); % [y_pos; x_pos; max_correlation]
end

% Display centered templates and kernels for first template as example
figure;
subplot(2,2,1); imagesc(centered_kernels{1}); colormap(gray); axis image; axis off;
title('Centered Kernel (Template 1)');

subplot(2,2,2); imagesc(centered_templates{1}); colormap(gray); axis image; axis off;
title('Centered Template 1');

subplot(2,2,3); imagesc(log(abs(fft_kernels{1})+1)); colormap(gray); axis image; axis off;
title('DFT of Kernel (Template 1)');

subplot(2,2,4); imagesc(log(abs(fft_templates{1})+1)); colormap(gray); axis image; axis off;
title('DFT of Template 1');

% Process sample frame to show intermediate steps (using Template 1)
t_sample = round(nt/2);
I_frame = I(:,:,t_sample);
I2_frame = I_frame.^2;

% Show DFTs for sample frame
ftI = fftshift(fft2(fftshift(I_frame)));
ftI2 = fftshift(fft2(fftshift(I2_frame)));

figure;
subplot(2,2,1); imagesc(I_frame); colormap(gray); axis image; axis off;
title(['Sample Frame ', num2str(t_sample)]);

subplot(2,2,2); imagesc(I2_frame); colormap(gray); axis image; axis off;
title(['Sample Frame^2 ', num2str(t_sample)]);

subplot(2,2,3); imagesc(log(abs(ftI)+1)); colormap(gray); axis image; axis off;
title('DFT of Sample Frame');

subplot(2,2,4); imagesc(log(abs(ftI2)+1)); colormap(gray); axis image; axis off;
title('DFT of Sample Frame^2');

% Track all objects through all frames
fprintf('Processing frames for multi-object tracking...\n');
correlation_maps = cell(num_templates, 1);

for t = 1:nt
    % Compute DFTs for current frame
    ftI = fftshift(fft2(fftshift(I(:,:,t))));
    ftI2 = fftshift(fft2(fftshift((I(:,:,t)).^2)));
    
    % Track each template
    for i = 1:num_templates
        % Get template parameters
        a = template_sizes{i}(1); b = template_sizes{i}(2);
        Sx = template_stats{i}.Sx; nn = template_stats{i}.nn;
        Varx = template_stats{i}.Varx;
        
        % Compute sums via DFT
        Sy = real(fftshift(ifft2(fftshift(ftI .* fft_kernels{i}))));
        Sy2 = real(fftshift(ifft2(fftshift(ftI2 .* fft_kernels{i}))));
        Sxy = real(fftshift(ifft2(fftshift(ftI .* conj(fft_templates{i})))));
        
        % Compute correlation
        Vary = (Sy2 - (Sy.^2)/nn)/(nn-1);
        Covxy = (Sxy - (Sx*Sy)/nn)/(nn-1);
        Corxy = Covxy ./ sqrt(Varx * Vary);
        
        % Store correlation map for visualization
        if t == t_sample && i <= 2 % Store sample correlations for display
            correlation_maps{i} = Corxy;
        end
        
        % Find best match
        [maxval, maxidx] = max(Corxy, [], 'all');
        [max_y, max_x] = ind2sub([ny, nx], maxidx);
        track_results{i}(:,t) = [max_y; max_x; maxval];
    end
    
    if mod(t, 10) == 0
        fprintf('Processed frame %d/%d\n', t, nt);
    end
end

% Display correlation maps for sample frame
figure;
for i = 1:min(2, num_templates)
    if ~isempty(correlation_maps{i})
        subplot(1,2,i);
        imagesc(correlation_maps{i}, [-1, 1]); axis image; axis off;
        title(['Correlation Map - ', template_info{i}.name]);
        colormap(jet);
    end
end

% Display tracking results with all objects
figure;
colors = {'m', 'c', 'y', 'g'};
for t = 1:nt
    imagesc(I(:,:,t)); colormap(gray); axis image; axis off;
    title(['Multi-Object Tracking - Frame ', num2str(t)]);
    hold on;
    
    % Draw bounding boxes for all templates
    for i = 1:num_templates
        max_y = track_results{i}(1,t);
        max_x = track_results{i}(2,t);
        maxval = track_results{i}(3,t);
        a = template_sizes{i}(1); b = template_sizes{i}(2);
        
        if maxval >= 0.4 % Lower threshold for multiple objects
            rectangle('Position', [max_x-b/2, max_y-a/2, b, a], ...
                      'EdgeColor', template_info{i}.color, 'LineWidth', 2);
            text(max_x, max_y-a/2-10, sprintf('T%d:%.2f', i, maxval), ...
                 'Color', template_info{i}.color, 'FontSize', 8, 'FontWeight', 'bold');
        end
    end
    hold off;
    pause(0.1);
end

% Display individual tracking trajectories
figure;
for i = 1:num_templates
    subplot(2,2,i);
    plot(track_results{i}(2,:), track_results{i}(1,:), ...
         'Color', template_info{i}.color, 'LineWidth', 2, 'Marker', 'o');
    xlabel('X Position'); ylabel('Y Position');
    title([template_info{i}.name, ' Trajectory']);
    axis ij; grid on;
end

% Display correlation scores over time
figure;
for i = 1:num_templates
    subplot(2,2,i);
    plot(1:nt, track_results{i}(3,:), 'Color', template_info{i}.color, 'LineWidth', 2);
    xlabel('Frame Number'); ylabel('Max Correlation');
    title([template_info{i}.name, ' Correlation']);
    grid on; ylim([0 1]);
end

% Combined trajectory plot
figure;
hold on;
for i = 1:num_templates
    plot(track_results{i}(2,:), track_results{i}(1,:), ...
         'Color', template_info{i}.color, 'LineWidth', 2, 'DisplayName', template_info{i}.name);
end
xlabel('X Position'); ylabel('Y Position');
title('All Object Trajectories');
legend('Location', 'best');
axis ij; grid on;
hold off;

fprintf('Multi-object tracking complete!\n');
fprintf('Tracked %d objects across %d frames\n', num_templates, nt);