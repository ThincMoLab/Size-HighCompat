%% ========================================================================
%  CREATE 8-SQUARE BACKGROUND IMAGE FOR PSYCHOJS EXPERIMENT
%  ========================================================================
%  Easy adjustment: Change parameters in Section 1
%  Author: [Your name]
%  Date: [Today's date]
%% ========================================================================

clear; close all; clc;

%% ========================================================================
%  SECTION 1: ADJUSTABLE PARAMETERS
%% ========================================================================

% --- Square Properties ---
square_size = 0.025;          % Width/height of each square (height units)
line_width = 6;              % Border thickness (pixels)
square_color = [1, 1, 1];    % RGB: white borders
fill_color = 'none';         % 'none' for transparent, or [0,0,0] for black

% --- Hand Layout Positions (height units) ---
% Format: [x_position, y_position]
% Left hand: A, W, E, F
% Right hand: H, U, I, L

positions = [
    -0.18,  0.00;   % A - Left pinky (index finger on keyboard)
    -0.14,  0.02;   % W - Left ring (raised)
    -0.10,  0.02;   % E - Left middle (raised)
    -0.06,  0.00;   % F - Left index
     0.06,  0.00;   % H - Right index
     0.10,  0.02;   % U - Right middle (raised)
     0.14,  0.02;   % I - Right ring (raised)
     0.18,  0.00;   % L - Right pinky
];

% --- Spacing Adjustments (added to base positions) ---
horizontal_spacing = 0.00;   % Add/subtract from all x-positions
vertical_spacing = 0.00;     % Add/subtract from all y-positions
raise_amount = 0.00;         % Additional raise for W, E, U, I (default 0.02)

% --- Canvas Properties ---
canvas_width = 0.5;         % Total width (matches your HandShape)
canvas_height = 0.35;        % Total height
dpi = 600;                   % Resolution (higher = better quality)

% --- Output ---
output_file = 'shape_background.png';
output_folder = './media/';  % Change to your path


%% ========================================================================
%  SECTION 2: APPLY ADJUSTMENTS (Don't modify unless you know what you're doing)
%% ========================================================================

% Apply global spacing adjustments
positions(:, 1) = positions(:, 1) + horizontal_spacing;
positions(:, 2) = positions(:, 2) + vertical_spacing;

% Apply additional raise to W, E, U, I (indices 2, 3, 6, 7)
raised_indices = [2, 3, 6, 7];
positions(raised_indices, 2) = positions(raised_indices, 2) + raise_amount;


%% ========================================================================
%  SECTION 3: CREATE FIGURE
%% ========================================================================

% Create figure with transparent background
fig = figure('Color', 'none', 'Units', 'inches', 'InvertHardcopy', 'off');
fig.Position(3:4) = [canvas_width * 10, canvas_height * 10];  % Scale for visibility

% Create axes
ax = axes('Parent', fig, 'Color', 'none', 'XColor', 'none', 'YColor', 'none');
axis equal;
hold on;

% Set axis limits (centered at origin)
xlim([-canvas_width/2, canvas_width/2]);
ylim([-canvas_height/2, canvas_height/2]);


%% ========================================================================
%  SECTION 4: DRAW SQUARES
%% ========================================================================

num_squares = size(positions, 1);

for i = 1:num_squares
    x_center = positions(i, 1);
    y_center = positions(i, 2);
    
    % Bottom-left corner of square
    x_corner = x_center - square_size/2;
    y_corner = y_center - square_size/2;
    
    % Draw rectangle
    rectangle('Position', [x_corner, y_corner, square_size, square_size], ...
              'EdgeColor', square_color, ...
              'LineWidth', line_width, ...
              'FaceColor', fill_color);
end


%% ========================================================================
%  SECTION 5: SAVE IMAGE
%% ========================================================================

% Create output folder if it doesn't exist
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Full output path
output_path = fullfile(output_folder, output_file);

% Export with transparent background
set(fig, 'InvertHardcopy', 'off');
print(fig, output_path, '-dpng', sprintf('-r%d', dpi), '-painters');

fprintf('✅ Image saved to: %s\n', output_path);
fprintf('   Size: %.2f x %.2f (height units)\n', canvas_width, canvas_height);
fprintf('   Squares: %d\n', num_squares);
fprintf('   Resolution: %d DPI\n', dpi);

% Display preview
fprintf('\n🔍 Preview window opened. Close it to continue.\n');


%% ========================================================================
%  SECTION 6: OPTIONAL - DISPLAY POSITION INFO
%% ========================================================================

% fprintf('\n📊 Square positions (height units):\n');
% fprintf('   Index |  Key  |    X     |    Y    \n');
% fprintf('   ------|-------|----------|----------\n');
% 
% keys = {'A', 'W', 'E', 'F', 'H', 'U', 'I', 'L'};
% for i = 1:num_squares
%     fprintf('     %d   |   %s   | %+.4f | %+.4f\n', ...
%             i-1, keys{i}, positions(i, 1), positions(i, 2));
% end


%% ========================================================================
%  SECTION 7: OPTIONAL - CREATE GRID REFERENCE IMAGE
%% ========================================================================

% Uncomment this section if you want a version with grid lines for alignment

% figure('Color', 'white');
% ax_grid = axes('Color', 'white');
% axis equal; hold on;
% xlim([-canvas_width/2, canvas_width/2]);
% ylim([-canvas_height/2, canvas_height/2]);
% grid on; grid minor;
% 
% % Draw squares
% for i = 1:num_squares
%     x_center = positions(i, 1);
%     y_center = positions(i, 2);
%     x_corner = x_center - square_size/2;
%     y_corner = y_center - square_size/2;
%     
%     rectangle('Position', [x_corner, y_corner, square_size, square_size], ...
%               'EdgeColor', 'blue', 'LineWidth', 2, 'FaceColor', 'none');
%     
%     % Add labels
%     text(x_center, y_center, keys{i}, ...
%          'HorizontalAlignment', 'center', ...
%          'FontSize', 12, 'FontWeight', 'bold', 'Color', 'red');
% end
% 
% title('Square Positions (with grid for adjustment)');
% xlabel('X position (height units)');
% ylabel('Y position (height units)');
% 
% exportgraphics(ax_grid, fullfile(output_folder, 'shape_background_grid.png'), ...
%                'Resolution', 150);
% fprintf('✅ Grid reference saved to: %s\n', ...
%         fullfile(output_folder, 'shape_background_grid.png'));
