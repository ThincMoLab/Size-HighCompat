%% ========================================================================
%  CREATE 8-SQUARE BACKGROUND PNG (hi-res + thicker strokes)
%  - Transparent background (RGBA)
%  - White outlines only (opaque alpha)
%  - Robust to PsychoJS scaling
%  - Saves to experiment root:  ./shape_background.png
%% ========================================================================

clear; close all; clc;

%% -------------------------- Parameters -----------------------------------
% Layout positions in "height units" style (centered, left/right clusters)
positions = [
    -0.16,  0.00;   % A
    -0.12,  0.02;   % W (raised)
    -0.08,  0.02;   % E (raised)
    -0.04,  0.00;   % F
     0.04,  0.00;   % H
     0.08,  0.02;   % U (raised)
     0.12,  0.02;   % I (raised)
     0.16,  0.00;   % L
];

% Square size relative to canvas width
square_size = 0.03;       % try 0.03–0.05 depending on desired visual size in PNG

% Export scale (increase to make outlines survive downscaling in PsychoJS)
export_scale = 2;         % 1=1080x540, 2=2160x1080, 4=4320x2160

% Stroke thickness in pixels (base * export_scale)
base_line_px = 8;         % good base; increase if you still see faint lines
line_width   = max(2, round(base_line_px * export_scale));

% Logical canvas (normalized) → final pixel size
canvas_width  = 1.0;
canvas_height = 0.5;

% Final pixel dimensions (height based on 1080 * export_scale)
screen_height_px = 1080 * export_scale;
width_px  = round(canvas_width  * screen_height_px);  % 1080, 2160, 4320, ...
height_px = round(canvas_height * screen_height_px);  %  540, 1080, 2160, ...

% Output filename (saved to experiment root)
output_path = fullfile('./', 'shape_background.png');

%% ------------------------ Create RGBA image -------------------------------
% RGBA image: initialize fully transparent
img = zeros(height_px, width_px, 4, 'uint8');

% Helpers: map normalized pos → pixel (snap to integer pixels)
pos_to_px_x = @(x) round((x + canvas_width/2)  / canvas_width  * width_px);
pos_to_px_y = @(y) round((canvas_height/2 - y) / canvas_height * height_px);

% Square size in pixels (relative to canvas width)
square_px = round(square_size / canvas_width * width_px);
half_size = floor(square_px/2);

%% ------------------------ Draw 8 square borders ---------------------------
for i = 1:size(positions, 1)
    cx = pos_to_px_x(positions(i, 1));
    cy = pos_to_px_y(positions(i, 2));

    % Bounding box (clamped to image bounds)
    x1 = max(1, cx - half_size);
    x2 = min(width_px, cx + half_size);
    y1 = max(1, cy - half_size);
    y2 = min(height_px, cy + half_size);

    % --- TOP border ---
    y_top_end = min(y1 + line_width - 1, y2);
    img(y1:y_top_end, x1:x2, 1:3) = 255;   % RGB = white
    img(y1:y_top_end, x1:x2, 4)   = 255;   % Alpha = opaque

    % --- BOTTOM border ---
    y_bot_start = max(y2 - line_width + 1, y1);
    img(y_bot_start:y2, x1:x2, 1:3) = 255;
    img(y_bot_start:y2, x1:x2, 4)   = 255;

    % --- LEFT border ---
    x_left_end = min(x1 + line_width - 1, x2);
    img(y1:y2, x1:x_left_end, 1:3) = 255;
    img(y1:y2, x1:x_left_end, 4)   = 255;

    % --- RIGHT border ---
    x_right_start = max(x2 - line_width + 1, x1);
    img(y1:y2, x_right_start:x2, 1:3) = 255;
    img(y1:y2, x_right_start:x2, 4)   = 255;
end

%% ---------------------------- Save PNG -----------------------------------
imwrite(img(:,:,1:3), output_path, 'png', 'Alpha', img(:,:,4));

fprintf('✅ Image created: %s\n', output_path);
fprintf('   Size: %d x %d px\n', width_px, height_px);
fprintf('   Line width: %d px (export_scale=%d)\n', line_width, export_scale);
fprintf('   Squares: %d\n', size(positions, 1));