%% ========================================================================
%  CREATE 8-SQUARE BACKGROUND - SIZE CORRECTED
%% ========================================================================

clear; close all; clc;

%% PARAMETERS
square_size = 0.03;
line_width = 4;

positions = [
    -0.16,  0.00;
    -0.12,  0.02;
    -0.08,  0.02;
    -0.04,  0.00;
     0.04,  0.00;
     0.08,  0.02;
     0.12,  0.02;
     0.16,  0.00;
];

canvas_width = 0.60;
canvas_height = 0.35;
screen_height_px = 1080;  % ← FIXED: was using DPI calculation

output_file = 'shape_background.png';
output_folder = './media/';

%% CREATE IMAGE ARRAY DIRECTLY

width_px = round(canvas_width * screen_height_px);
height_px = round(canvas_height * screen_height_px);

fprintf('Creating image: %dx%d pixels\n', width_px, height_px);

% Create RGBA image
img = zeros(height_px, width_px, 4, 'uint8');

% Helper functions
pos_to_px_x = @(x) round((x + canvas_width/2) / canvas_width * width_px);
pos_to_px_y = @(y) round((canvas_height/2 - y) / canvas_height * height_px);

square_px = round(square_size / canvas_width * width_px);

%% DRAW SQUARES (same as before)

for i = 1:size(positions, 1)
    cx = pos_to_px_x(positions(i, 1));
    cy = pos_to_px_y(positions(i, 2));
    
    half_size = floor(square_px / 2);
    x1 = max(1, cx - half_size);
    x2 = min(width_px, cx + half_size);
    y1 = max(1, cy - half_size);
    y2 = min(height_px, cy + half_size);
    
    % Top border
    y_top_start = y1;
    y_top_end = min(y1 + line_width - 1, y2);
    img(y_top_start:y_top_end, x1:x2, 1:3) = 255;
    img(y_top_start:y_top_end, x1:x2, 4) = 255;
    
    % Bottom border
    y_bot_start = max(y2 - line_width + 1, y1);
    y_bot_end = y2;
    img(y_bot_start:y_bot_end, x1:x2, 1:3) = 255;
    img(y_bot_start:y_bot_end, x1:x2, 4) = 255;
    
    % Left border
    x_left_start = x1;
    x_left_end = min(x1 + line_width - 1, x2);
    img(y1:y2, x_left_start:x_left_end, 1:3) = 255;
    img(y1:y2, x_left_start:x_left_end, 4) = 255;
    
    % Right border
    x_right_start = max(x2 - line_width + 1, x1);
    x_right_end = x2;
    img(y1:y2, x_right_start:x_right_end, 1:3) = 255;
    img(y1:y2, x_right_start:x_right_end, 4) = 255;
end

%% SAVE IMAGE

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

output_path = fullfile(output_folder, output_file);
imwrite(img(:,:,1:3), output_path, 'png', 'Alpha', img(:,:,4));

fprintf('✅ Image created successfully!\n');
fprintf('   Path: %s\n', output_path);
fprintf('   Size: %dx%d pixels\n', width_px, height_px);
fprintf('   Squares: %d\n', size(positions, 1));

%% PREVIEW

fprintf('\n✅ Image created successfully!\n');
fprintf('   Path: %s\n', output_path);
fprintf('   Size: %dx%d pixels\n', width_px, height_px);
fprintf('   Squares: %d\n', size(positions, 1));
fprintf('   White pixels: %d\n', sum(img(:,:,4) > 0, 'all'));

% Show preview on black background
figure('Color', [0, 0, 0], 'Name', 'Shape Background Preview');

% Method 1: Simple RGB display
subplot(1,2,1);
imshow(img(:,:,1:3));  % Just RGB, ignore alpha
title('RGB channels only');
axis on;

% Method 2: Composited with alpha on black
subplot(1,2,2);
rgb = double(img(:,:,1:3)) / 255;
alpha_ch = double(img(:,:,4)) / 255;
alpha_3d = repmat(alpha_ch, [1, 1, 3]);  % Expand alpha to 3 channels
composited = rgb .* alpha_3d;  % Multiply with black (0) background
imshow(composited);
title('With transparency (as PsychoJS sees it)');
axis on;

fprintf('\n🔍 Right panel shows how it looks in PsychoJS!\n');
fprintf('   If you see white squares there, it will work!\n');