clear all;
close all;

% Display first frame with grid to locate dog coordinates
% For 1280x720 video "dog.mp4"

clear all; close all;

% Read video
filename = 'dog.mp4';
vidObj = VideoReader(filename);
nx = vidObj.Width;   % 1280
ny = vidObj.Height;  % 720

% Read first frame
firstFrame = read(vidObj, 1);
if size(firstFrame, 3) == 3
    firstFrame = rgb2gray(firstFrame);
end
firstFrame = double(firstFrame);

% Display first frame with detailed grid
figure('Position', [100, 100, 1200, 800]);
imagesc(firstFrame, [0, 255]);
colormap(gray);
axis image;
title('First Frame - Locate the Dog', 'FontSize', 14);

% Add major grid lines every 100 pixels
hold on;
% Vertical lines
for x = 0:100:nx
    line([x, x], [0, ny], 'Color', 'red', 'LineWidth', 1, 'LineStyle', '--');
end
% Horizontal lines  
for y = 0:100:ny
    line([0, nx], [y, y], 'Color', 'red', 'LineWidth', 1, 'LineStyle', '--');
end

% Add minor grid lines every 50 pixels
for x = 50:100:nx
    line([x, x], [0, ny], 'Color', 'yellow', 'LineWidth', 0.5, 'LineStyle', ':');
end
for y = 50:100:ny
    line([0, nx], [y, y], 'Color', 'yellow', 'LineWidth', 0.5, 'LineStyle', ':');
end

% Set tick marks every 50 pixels for precision
set(gca, 'XTick', 0:50:nx);
set(gca, 'YTick', 0:50:ny);
set(gca, 'XTickLabel', 0:50:nx);
set(gca, 'YTickLabel', 0:50:ny);

% Rotate x-axis labels for better readability
xtickangle(45);

% Add grid
grid on;
set(gca, 'GridColor', 'blue', 'GridLineStyle', '-', 'GridAlpha', 0.3);

% Enable data cursor for precise coordinate reading
datacursormode on;

hold off;

% Print instructions
fprintf('=== DOG LOCATION INSTRUCTIONS ===\n');
fprintf('Video dimensions: %d x %d\n', nx, ny);
fprintf('Red dashed lines: Major grid (every 100 pixels)\n');
fprintf('Yellow dotted lines: Minor grid (every 50 pixels)\n');
fprintf('Blue grid: Fine grid for precise reading\n');
fprintf('Tick marks: Every 50 pixels\n\n');
fprintf('Use the data cursor tool to click on the dog and read coordinates.\n');
fprintf('For a 100x100 template centered on the dog:\n');
fprintf('If dog center is at (x, y), use coordinates:\n');
fprintf('template = I(y-50:y+49, x-50:x+49, 1);\n\n');

% Also create a zoomed view of likely dog area (lower left)
figure('Position', [1350, 100, 800, 600]);
% Show region where dog is likely located (lower left quadrant)
dog_region = firstFrame(400:720, 1:400); % Bottom left area
imagesc(dog_region, [0, 255]);
colormap(gray);
axis image;
title('Zoomed View - Lower Left (Likely Dog Area)', 'FontSize', 14);

% Add grid to zoomed view
hold on;
[zoom_ny, zoom_nx] = size(dog_region);
% Grid every 25 pixels in zoomed view
for x = 0:25:zoom_nx
    line([x, x], [0, zoom_ny], 'Color', 'red', 'LineWidth', 0.8, 'LineStyle', '--');
end
for y = 0:25:zoom_ny
    line([0, zoom_nx], [y, y], 'Color', 'red', 'LineWidth', 0.8, 'LineStyle', '--');
end

% Set ticks for zoomed view (offset by 400 in y, 0 in x for actual coordinates)
x_ticks = 0:25:zoom_nx;
y_ticks = 0:25:zoom_ny;
set(gca, 'XTick', x_ticks);
set(gca, 'YTick', y_ticks);
set(gca, 'XTickLabel', x_ticks); % Actual x coordinates
set(gca, 'YTickLabel', y_ticks + 400); % Actual y coordinates (offset)

grid on;
datacursormode on;
hold off;

fprintf('=== ZOOMED VIEW INFO ===\n');
fprintf('Zoomed region: y=400-720, x=1-400\n');
fprintf('Y-axis labels show actual coordinates in full image\n');
fprintf('Click on the dog in either view to get precise coordinates\n');