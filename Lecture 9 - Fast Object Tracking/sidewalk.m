% Display multiple frames with grid to locate objects in 1280x720 video
% Shows frames 1, 3, and 9 with coordinate grids

clear all; close all;

% Video file name - change this to your video
filename = 'sidewalk.mp4'; % Replace with your video filename

% Read video
vidObj = VideoReader(filename);
nx = vidObj.Width;   % Should be 1280
ny = vidObj.Height;  % Should be 720

% Verify video dimensions
fprintf('Video dimensions: %d x %d\n', nx, ny);
if nx ~= 1280 || ny ~= 720
    warning('Video is not 1280x720. Adjusting grid accordingly.');
end

% Times to analyze (in seconds)
times_to_show = [1, 3, 9];
frame_rate = vidObj.FrameRate;
frames_to_show = round(times_to_show * frame_rate);

fprintf('Frame rate: %.2f fps\n', frame_rate);
fprintf('Times: %s seconds\n', mat2str(times_to_show));
fprintf('Corresponding frames: %s\n', mat2str(frames_to_show));

% Create figure with subplots
figure('Position', [50, 50, 1800, 1200]);

for i = 1:length(frames_to_show)
    frame_num = frames_to_show(i);
    
    % Read specific frame
    current_frame = read(vidObj, frame_num);
    if size(current_frame, 3) == 3
        current_frame = rgb2gray(current_frame);
    end
    current_frame = double(current_frame);
    
    % Create subplot
    subplot(2, 2, i);
    imagesc(current_frame, [0, 255]);
    colormap(gray);
    axis image;
    title(sprintf('Frame %d (t=%.1fs)', frame_num, times_to_show(i)), 'FontSize', 12, 'FontWeight', 'bold');
    
    % Add major grid lines every 100 pixels
    hold on;
    % Vertical lines
    for x = 0:100:nx
        line([x, x], [0, ny], 'Color', 'red', 'LineWidth', 0.8, 'LineStyle', '--');
    end
    % Horizontal lines  
    for y = 0:100:ny
        line([0, nx], [y, y], 'Color', 'red', 'LineWidth', 0.8, 'LineStyle', '--');
    end
    
    % Add minor grid lines every 50 pixels
    for x = 50:100:nx
        line([x, x], [0, ny], 'Color', 'yellow', 'LineWidth', 0.4, 'LineStyle', ':');
    end
    for y = 50:100:ny
        line([0, nx], [y, y], 'Color', 'yellow', 'LineWidth', 0.4, 'LineStyle', ':');
    end
    
    % Set tick marks every 100 pixels (less crowded for subplots)
    set(gca, 'XTick', 0:100:nx);
    set(gca, 'YTick', 0:100:ny);
    set(gca, 'XTickLabel', 0:100:nx);
    set(gca, 'YTickLabel', 0:100:ny);
    
    % Smaller font for subplot labels
    set(gca, 'FontSize', 8);
    
    % Add fine grid
    grid on;
    set(gca, 'GridColor', 'blue', 'GridLineStyle', '-', 'GridAlpha', 0.2);
    
    hold off;
end

% Enable data cursor for all subplots
datacursormode on;

% Add instructions as text in the 4th subplot area
subplot(2, 2, 4);
axis off;
instructions = {
    'COORDINATE LOCATOR INSTRUCTIONS:'
    ''
    'Video Dimensions: 1280 x 720'
    ''
    'Grid Legend:'
    '• Red dashed lines: Every 100 pixels'
    '• Yellow dotted lines: Every 50 pixels' 
    '• Blue grid: Fine grid for precision'
    '• Tick marks: Every 100 pixels'
    ''
    'Usage:'
    '1. Click the data cursor tool (crosshair icon)'
    '2. Click on any object in any frame'
    '3. Read coordinates from cursor display'
    ''
    'For 100x100 template at center (x,y):'
    'template = I(y-50:y+49, x-50:x+49, frame_num);'
    ''
    'Example: If center at (200,300)'
    'template = I(250:349, 150:249, frame_num);'
};

text(0.05, 0.95, instructions, 'Units', 'normalized', 'VerticalAlignment', 'top', ...
     'FontSize', 10, 'FontWeight', 'normal');

% Create detailed view figures for each frame
for i = 1:length(frames_to_show)
    frame_num = frames_to_show(i);
    
    % Read frame again
    current_frame = read(vidObj, frame_num);
    if size(current_frame, 3) == 3
        current_frame = rgb2gray(current_frame);
    end
    current_frame = double(current_frame);
    
    % Create detailed figure
    figure('Position', [100 + i*200, 100, 900, 700]);
    imagesc(current_frame, [0, 255]);
    colormap(gray);
    axis image;
    title(sprintf('Detailed View - Frame %d at t=%.1fs (1280x720)', frame_num, times_to_show(i)), 'FontSize', 14);
    
    % Add detailed grid
    hold on;
    % Major grid every 100 pixels
    for x = 0:100:nx
        line([x, x], [0, ny], 'Color', 'red', 'LineWidth', 1, 'LineStyle', '--');
    end
    for y = 0:100:ny
        line([0, nx], [y, y], 'Color', 'red', 'LineWidth', 1, 'LineStyle', '--');
    end
    
    % Minor grid every 50 pixels
    for x = 50:100:nx
        line([x, x], [0, ny], 'Color', 'yellow', 'LineWidth', 0.5, 'LineStyle', ':');
    end
    for y = 50:100:ny
        line([0, nx], [y, y], 'Color', 'yellow', 'LineWidth', 0.5, 'LineStyle', ':');
    end
    
    % Set detailed tick marks every 50 pixels
    set(gca, 'XTick', 0:50:nx);
    set(gca, 'YTick', 0:50:ny);
    set(gca, 'XTickLabel', 0:50:nx);
    set(gca, 'YTickLabel', 0:50:ny);
    
    % Rotate x-labels for readability
    xtickangle(45);
    
    % Add fine grid
    grid on;
    set(gca, 'GridColor', 'blue', 'GridLineStyle', '-', 'GridAlpha', 0.3);
    
    % Enable data cursor
    datacursormode on;
    
    hold off;
    
    fprintf('=== FRAME %d (t=%.1fs) ANALYSIS ===\n', frame_num, times_to_show(i));
    fprintf('Use data cursor to click on objects for precise coordinates\n');
    fprintf('Grid: Red (100px), Yellow (50px), Blue (fine)\n\n');
end

fprintf('\n=== SUMMARY ===\n');
fprintf('Created %d overview subplots and %d detailed figures\n', length(frames_to_show), length(frames_to_show));
fprintf('Times analyzed: %s seconds\n', mat2str(times_to_show));
fprintf('Frames analyzed: %s\n', mat2str(frames_to_show));
fprintf('Use data cursor tool to get precise object coordinates\n');