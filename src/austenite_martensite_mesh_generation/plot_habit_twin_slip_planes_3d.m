function fighandle = plot_habit_twin_slip_planes_3d(austenite_color_ip, CV1_color_ip, CV2_color_ip, ...
                                                    habit_plane_normal_ip, twin_plane_normal_ip, CV_volume_ratio_ip, ...
                                                    slip_plane_normal, slip_direction, slip_plane_color_ip, slip_plane_opacity, ...
                                                    bbox_half_width)
% 3D plot showing habit and twin interafces for CV 1-9.
% CHESS June 2015 SC data
%
% Specify colors for the phases
austenite_color    = austenite_color_ip;
CV1_color          = CV1_color_ip;
CV2_color          = CV2_color_ip;
habit_plane_normal = habit_plane_normal_ip;
twin_plane_normal  = twin_plane_normal_ip;
CV_volume_ratio    = CV_volume_ratio_ip;
slip_direction     = slip_direction / norm(slip_direction);
%
fighandle = figure('Position', [200 200 600 600]);
% Hack to force 3D view. Not sure if needed in 2015a.
plot3(0, 0, 0);
% Various planes are defined by their normal. a variable ending in 'p'
% means that the normal is +ve. 'm' at the end means that the normal is -ve
% So planem and planep define the same plane but with the normal pointing
% in the opposite direction.
%
% Foil plane
foil = createPlane([0 0 0], [0 0 1]);
% Invariant/habit plane
i = createPlane([0 0 0], -habit_plane_normal);
im = createPlane([0 0 0], habit_plane_normal);
% Twin plane
t = createPlane([0 0 0], twin_plane_normal);
tm = createPlane([0 0 0], -twin_plane_normal);
% It's neat to show multiple twin planes separated by the right distance.
% This distance is taken as proportional to the volume fraction ratio of
% CV1 and CV2.
CV_volume_ratio_prime = 1.0 - CV_volume_ratio;
% Larger multiplier means fewer twin pairs will be plotted.
twin_spacing_multiplier = 1;
twin_offset = 0;
%
t1 = parallelPlane(t, twin_offset + twin_spacing_multiplier*CV_volume_ratio);
t2 = parallelPlane(t, twin_offset + twin_spacing_multiplier*(-CV_volume_ratio_prime));
t3 = parallelPlane(t, twin_offset + twin_spacing_multiplier*(-1));
t4 = parallelPlane(t, twin_offset + twin_spacing_multiplier*1);
t5 = parallelPlane(t, twin_offset + twin_spacing_multiplier*(-1 - CV_volume_ratio_prime));
t6 = parallelPlane(t, twin_offset + twin_spacing_multiplier*(-2));
t1m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*(-CV_volume_ratio));
t2m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*(CV_volume_ratio_prime));
t3m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*1);
t4m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*(-1));
t5m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*(1 + CV_volume_ratio_prime));
t6m = parallelPlane(tm, twin_offset + twin_spacing_multiplier*2);
% Slip plane
s1 = createPlane([0 0 0],  slip_plane_normal);
s2 = createPlane([0.35 0.35 0.35],  slip_plane_normal);
s3 = createPlane([-0.35 -0.35 -0.35],  slip_plane_normal);
s4 = createPlane([0.7 0.7 0.7],  slip_plane_normal);
s5 = createPlane([-0.7 -0.7 -0.7],  slip_plane_normal);
s1m = createPlane([0 0 0],  -slip_plane_normal);
s2m = createPlane([0.35 0.35 0.35],  -slip_plane_normal);
s3m = createPlane([-0.35 -0.35 -0.35],  -slip_plane_normal);
% Planes along X, Y, Z faces
xp = createPlane([ bbox_half_width 0  0], -[1 0 0]);
xm = createPlane([-bbox_half_width 0  0],  [1 0 0]);
yp = createPlane([0  bbox_half_width  0], -[0 1 0]);
ym = createPlane([0 -bbox_half_width  0],  [0 1 0]);
zp = createPlane([0  0  bbox_half_width], -[0 0 1]);
zm = createPlane([0  0 -bbox_half_width],  [0 0 1]);
% Plot stuff
% Invariant plane  = green
% Twin planes = magenta
hold on;
% plane_extent is a terrible hack. plane_extent specifies the "width" of a
% plane. This is set to a very large number compared to our plot bounding
% box. That way, any two reasonably non-parallel parallel planes are
% guaranteed to intersect and geom3d does not throw an exception. This hack
% pretty much prevents exporting the model to VRML, U3D etc, unless we come
% up with an easy way of trimming the planes outside the bounding box
% (2x2x2 for now)
plane_extent = 1800;
% Foil plane
try
    patch_foil = fillPolygon3d(clipPolygonByBBox(foil, plane_extent, bbox_half_width), 'w');
catch
end
% Habit plane
patch_a = fillPolygon3d(clipPolygonByBBox(i, plane_extent, bbox_half_width), austenite_color);
% Clipped bounding box for the habit plane
try
%     fillPolygon3d(clipPolygonByOnePlanes(xp, plane_extent, bbox_half_width, im), austenite_color);
%     fillPolygon3d(clipPolygonByOnePlanes(xm, plane_extent, bbox_half_width, im), austenite_color);
%     fillPolygon3d(clipPolygonByOnePlanes(yp, plane_extent, bbox_half_width, im), austenite_color);
%     fillPolygon3d(clipPolygonByOnePlanes(ym, plane_extent, bbox_half_width, im), austenite_color);
%     fillPolygon3d(clipPolygonByOnePlanes(zp, plane_extent, bbox_half_width, im), austenite_color);
%     fillPolygon3d(clipPolygonByOnePlanes(zm, plane_extent, bbox_half_width, im), austenite_color);
catch
end
% Clipped slip planes
try
    patch_slip_1 = fillPolygon3d(clipPolygonByOnePlanes(s1, plane_extent, bbox_half_width, im), slip_plane_color_ip);
    patch_slip_2 = fillPolygon3d(clipPolygonByOnePlanes(s2, plane_extent, bbox_half_width, im), slip_plane_color_ip);
    patch_slip_3 = fillPolygon3d(clipPolygonByOnePlanes(s3, plane_extent, bbox_half_width, im), slip_plane_color_ip);
    patch_slip_4 = fillPolygon3d(clipPolygonByOnePlanes(s4, plane_extent, bbox_half_width, im), slip_plane_color_ip);
    patch_slip_5 = fillPolygon3d(clipPolygonByOnePlanes(s5, plane_extent, bbox_half_width, im), slip_plane_color_ip);
    set(patch_slip_1, 'FaceAlpha', slip_plane_opacity);
    set(patch_slip_2, 'FaceAlpha', slip_plane_opacity);
    set(patch_slip_3, 'FaceAlpha', slip_plane_opacity);
    set(patch_slip_4, 'FaceAlpha', slip_plane_opacity);
    set(patch_slip_5, 'FaceAlpha', slip_plane_opacity);
catch
end
% Clipped twin planes
try
    fillPolygon3d(clipPolygonByOnePlanes(t, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t1, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t2, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t3, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t4, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t5, plane_extent, bbox_half_width, i), 'm');
    fillPolygon3d(clipPolygonByOnePlanes(t6, plane_extent, bbox_half_width, i), 'm');
catch
end
% Clipped bounding box for the twins
% +ve X face
try
    patch_cv2 = fillPolygon3d(clipPolygonByTwoPlanes(xp, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    patch_cv1 = fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xp, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(xp, plane_extent, bbox_half_width, i, t6), CV1_color);
    % -ve X face
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(xm, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(xm, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(xm, plane_extent, bbox_half_width, i, t6), CV1_color);
    % Y faces
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(yp, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(yp, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(yp, plane_extent, bbox_half_width, i, t6), CV1_color);
    %
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(ym, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(ym, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(ym, plane_extent, bbox_half_width, i, t6), CV1_color);
    % Z faces
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(zp, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zp, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try 
    fillPolygon3d(clipPolygonByTwoPlanes(zp, plane_extent, bbox_half_width, i, t6), CV1_color);
    %
catch
end
try
    fillPolygon3d(clipPolygonByTwoPlanes(zm, plane_extent, bbox_half_width, i, t4m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, t1m, t4), CV1_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, tm, t1), CV2_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, t, t2m), CV1_color);
catch
end
try 
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, t2, t3m), CV2_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, t3, t5m), CV1_color);
catch
end
try
    fillPolygon3d(clipPolygonByThreePlanes(zm, plane_extent, bbox_half_width, i, t5, t6m), CV2_color);
catch
end
try 
    fillPolygon3d(clipPolygonByTwoPlanes(zm, plane_extent, bbox_half_width, i, t6), CV1_color);
catch
end
% Slip direction
% line([0 0 + slip_direction(1)], [1.5 1.5 + slip_direction(2)], [0 0 + slip_direction(3)], 'LineWidth', 3, 'Color', 'k');
% X, Y, Z axes
line([-2 -1],   [-2 -2],   [-2 -2],   'Color', 'r', 'LineWidth', 3)
line([-2 -2],   [-2 -1],   [-2 -2],   'Color', 'g', 'LineWidth', 3)
line([-2 -2],   [-2 -2],   [-2 -1],   'Color', 'b', 'LineWidth', 3)
% line([1 2],   [1 1],   [1 1],   'Color', 'r', 'LineWidth', 3)
% line([1 1],   [1 2],   [1 1],   'Color', 'g', 'LineWidth', 3)
% line([1 1],   [1 1],   [1 2],   'Color', 'b', 'LineWidth', 3)
hold off;
% Set axis etc
alpha(0.8);
xlim([-bbox_half_width-1 bbox_half_width+1]); ylim([-bbox_half_width-1 bbox_half_width+1]); zlim([-bbox_half_width-1 bbox_half_width+1]);
grid off; box on; axis vis3d;
set(gca, 'XTick', []); set(gca, 'XTickLabel', []);
set(gca, 'YTick', []); set(gca, 'YTickLabel', []);
set(gca, 'ZTick', []); set(gca, 'ZTickLabel', []);
camproj('perspective')
camtarget([-1 1 1]);
camup([0 1 0]);
campos([10 30 30]);
% Lighting
camlight;
set(findall(gcf, 'Type', 'patch'), 'DiffuseStrength', 0.8)
set(findall(gcf, 'Type', 'patch'), 'AmbientStrength', 0.6)
% Legend
try
    l = legend([patch_a, patch_cv1, patch_cv2], 'Austenite', 'CV 1', 'CV 2');
    set(l, 'FontSize', 14);
catch
end
%
% Some of the clipped patches are still going to be out of the bounding
% box. Here we prune those.
p = findall(gcf, 'Type', 'patch');
for i = 1:size(p(:))
    p_centroid = mean(p(i).Vertices, 1);
    if(p_centroid(1) > 2*bbox_half_width || p_centroid(2) > 2*bbox_half_width || ...
            p_centroid(3) > 2*bbox_half_width || p_centroid(1) < -2*bbox_half_width || ...
            p_centroid(2) < -2*bbox_half_width || p_centroid(3) < -2*bbox_half_width)
        delete(p(i));
    end
end
%
set(patch_foil, 'FaceAlpha', 0.3);
end
