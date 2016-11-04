% Generate a 3D mesh consisting of an Austenite zone and an adjacent zone
% with twinned martensite consisting of two CVs
austenite_color_ip    = 'g';                                               % Austenite color in visualization
CV1_color_ip          = 'r';                                               % CV1 color in visualization
CV2_color_ip          = 'b';                                               % CV2 color in visualization
habit_plane_normal_ip = [-0.7682 -0.4306 -0.4737];                         % Normal to the habit plane (m) in global coordinates
twin_plane_normal_ip  = [0.9736 -0.2281 0];                                % Twin plane normal (n) in the global coordinates
CV_volume_ratio_ip    = 0.72;                                              % CV1:CV2 volume ratio
slip_plane_normal     = [];                                                % Slip plane normal in global coordinates (Optional, leave empty to not draw)
slip_direction        = [];                                                % Slip direction in global coordinates (Optional, leave empty to not draw)
slip_plane_color_ip   = [0.6 0.6 0.6];                                     % Slip plane color
slip_plane_opacity    = 0.4;                                               % Slip plane opacity
foil_plane            = [];
bbox_half_width       = 2;                                                 % Half width of the bounding box. The box will span -width to +width in X, Y, Z
number_of_twins       = 5;                                                 % Number of twin pairs in the martensite region
%
[h, elems, elems_phase] = generate_habit_twin_mesh_3d(austenite_color_ip, CV1_color_ip, CV2_color_ip, ...
                                                      habit_plane_normal_ip, twin_plane_normal_ip, ...
                                                      CV_volume_ratio_ip, slip_plane_normal, slip_direction, ...
                                                      slip_plane_color_ip, slip_plane_opacity, foil_plane, ...
                                                      bbox_half_width, number_of_twins);
%
% Visualize an Asutenite-twinned martensite microstructure
austenite_color_ip    = 'g';                                               % Austenite color in visualization
CV1_color_ip          = 'r';                                               % CV1 color in visualization
CV2_color_ip          = 'b';                                               % CV2 color in visualization
habit_plane_normal_ip = [-0.7682 -0.4306 -0.4737];                         % Normal to the habit plane (m) in global coordinates
twin_plane_normal_ip  = [0.9736 -0.2281 0];                                % Twin plane normal (n) in the global coordinates
CV_volume_ratio_ip    = 0.72;                                              % CV1:CV2 volume ratio
slip_plane_normal     = [1 1 0];                                           % Slip plane normal in global coordinates (Optional, leave empty to not draw)
slip_direction        = [0 0 1];                                           % Slip direction in global coordinates (Optional, leave empty to not draw)
slip_plane_color_ip   = [0.6 0.6 0.6];                                     % Slip plane color
slip_plane_opacity    = 0.4;                                               % Slip plane opacity
foil_plane            = [0 0 1];                                           % TEM foil plane (Optional, leave empty to not draw)
bbox_half_width       = 2;                                                 % Half width of the bounding box. The box will span -width to +width in X, Y, Z
number_of_twins       = 5;                                                 % Number of twin pairs in the martensite region
%
[~, ~, ~] = generate_habit_twin_mesh_3d(austenite_color_ip, CV1_color_ip, CV2_color_ip, ...
                                        habit_plane_normal_ip, twin_plane_normal_ip, ...
                                        CV_volume_ratio_ip, slip_plane_normal, slip_direction, ...
                                        slip_plane_color_ip, slip_plane_opacity, foil_plane, ...
                                        bbox_half_width, number_of_twins);
