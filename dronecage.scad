// Copyright (C) 2019-2021 Volkswagen Aktiengesellschaft,
// Berliner Ring 2, 38440 Wolfsburg, Germany
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

include <config.scad>
use <laser.scad>;
use <utils.scad>;
use <batteryholder.scad>;

module cage_bottom() {
    plate(false, sheet_thickness, cage_w, cage_r, side_w, side_tab, side_tap_pos, flight_controller_d, prop_r);
}

module cage_top() {
    plate(true,sheet_thickness, cage_w, cage_r, side_w, side_tab, side_tap_pos, flight_controller_d, prop_r);
}

module cage_pillars() {
    side_plate_pillar(side_tab, landing_l, cage_h, cage_r, cage_w, side_w, sheet_thickness);
}

module cage_side() {
    side_plate(side_tab, landing_l, cage_h, cage_r, cage_w, side_w, sheet_thickness);
}

module drone(propellor_size) {
    translate([cage_w * 0.5 + 15, cage_w / 2 + 15])
        cage_bottom();

    translate([cage_w * 1.5 + 30, cage_w / 2 + 15])
        cage_top();

    for(i=[0:3])
        translate([i * (side_w + 5) + side_w / 2 + 15, cage_w + (cage_h + 5)])
            cage_pillars();

    for(i=[0:3])
        translate([i * (side_w * 3.0 + 5) + side_w / 2 + 15, cage_w * 1.0 + 3 * (cage_h + 5)])
            cage_side();
}

module transform_markers() {
    for(p=motion_tracking_marker_pos)
        translate([p[0], p[1]])
            children();
}

module sensor_transform() {
    for(j=[0:7])
        rotate([0, 0, j * 90])
            translate([-cage_w / 2 + 20, ((j > 3)?-20:20)])
                rotate([0, 0, ((j>3)?30:-30)])
                    children();
}

module quadrant_transform(pos) {
    for(j=[0:3])
        rotate([0, 0, j * 90])
            for(index=[-1, 1])
                translate(pos)
                    rotate([0, 0, 90]) {
                        $i = index;
                        children();
                    }
}

module motor_screw_holes() {
    d = 11.5;
    d1 = 16.2;
    d2 = 19.2;

    rotate([0, 0, 45]) {
        for(i=[-1, 1])
            for(j=[-1, 1])
                translate([i * d / 2, j * d / 2])
                    circle(r=3.2 / 2, $fn=20);

        circle(r=10 / 2, $fn=20);

        for(j=[-1, 1])
            rotate([0, 0, j * 90 + 90])
                translate([0, d2 / 2])
                    circle(r=3.2 / 2, $fn=20);

        for(j=[-1, 1])
            rotate([0, 0, j * 90])
                translate([0, d1 / 2])
                    circle(r=3.2 / 2, $fn=20);
    }
}

module base(offset, sheet_thickness, cage_w, cage_r, landing_grooves=true) {
    difference() {
        union() {
            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([i * (cage_w / 2 - cage_r), j * (cage_w / 2 - cage_r)])
                        circle(r=cage_r - offset);

            square([cage_w - offset * 2, prop_offset * 2], center=true);
            square([prop_offset * 2, cage_w - offset * 2], center=true);

            if(landing_grooves)
                for(j=[0:3])
                    rotate([0, 0, j * 90])
                        for(i=[0:3])
                            translate([prop_offset, prop_offset])
                                rotate([0, 0, i * 90 / 3 - 90])
                                    translate([0, cage_r - sheet_thickness / 2 + 5 / 2 - 2.5]) {
                                        translate([-10 / 2 - 4 + 2.5, 0])
                                            circle(4);

                                        translate([10 / 2 + 4 - 2.5, 0])
                                            circle(4);
                                    }
        }

        if(landing_grooves)
            for(j=[0:3])
                rotate([0, 0, j * 90])
                    for(i=[0:3])
                        translate([prop_offset, prop_offset])
                            rotate([0, 0, i * 90 / 3 - 90])
                                translate([0, cage_r - sheet_thickness / 2 + 5 / 2 - 2.5])
                                    square([10, sheet_thickness + 0.01], center=true);
    }
}

module board_computer_screws(r, flight_controller_d, naze=true) {
    for(i=[-1,1])
        for(j=[-1,1])
            translate([j * 79.14 / 2, i * 42.13 / 2])
                circle(r=r, $fn=20);
}


module prop_diff(holes, prop_r, free=false) {
    edge_r = 5;
    edge_r2 = 15;
    dist_angle = 15;
    bar_l = prop_r * 0.9;

    difference() {
        circle(r=prop_r);

        difference() {
            circle(r=prop_r);

            if(free)
                circle(r=prop_r);

            difference() {
                for(a=[0:3])
                rotate([0, 0, 1200 * a]) {
                    for(i=[-1, 1])
                        rotate([0, 0, -dist_angle * i])
                            translate([prop_r - edge_r, 0])
                                circle(r=edge_r);

                    for(i=[-1, 1])
                        translate([0, -edge_r])
                            rotate([0, 0, -dist_angle * i])
                                translate([prop_r - edge_r, 0])
                                    rotate([0, 0, dist_angle * i])
                                        translate([-bar_l, 0])
                                            translate([0.1 * prop_r, -20 / 2 - 20 / 2 * i])
                                                square([bar_l - 6, edge_r * 2 + 20]);

                    for(i=[-1, 1])
                        translate([0, -edge_r - edge_r * i])
                            rotate([0, 0, -dist_angle * i])
                                translate([prop_r - edge_r, 0])
                                    rotate([0, 0, dist_angle * i])
                                        translate([-bar_l + 0.1 * prop_r, -prop_r / 2 - prop_r / 2 * i])
                                            square([bar_l + 10, edge_r * 2 + prop_r + ((a == 1)?100:0)]);
                }

                if(holes)
                    circle(r=25.3 / 2);
            }
            if(holes)
                rotate([0, 0, 30 + 45])
                    motor_screw_holes();
        }
    }
}

module plate(top=false, sheet_thickness, cage_w, cage_r, side_w, side_tab, side_tap_pos,flight_controller_d, prop_r) {
    difference() {
        // outline of drone plate, surrounded by hooks
        union() {
            base(0, sheet_thickness, cage_w, cage_r);

            quadrant_transform([cage_w / 2 - sheet_thickness / 2, 0])
                translate([$i * (side_w / 2 - side_tab / 2), 0]) {
                    offset = side_tab / 2 + 4 - 1.5;
                    translate([-offset, 0])
                        circle(4);

                    translate([offset, 0])
                        circle(4);
                }
        }

        // cutting lightweight structure in relevent sections
        intersection() {
            difference() {
                // outline of drone plate, shrinked by ligthweight_border
                base(0, sheet_thickness, cage_w - ligthweight_border * 4, cage_r, landing_grooves=false);

                // only put motion tracking mounts on the top plate
                if(top)
                    transform_markers()
                        circle(r=5);

                // internal wall structure
                quadrant_transform([0, side_tap_pos])
                    square([side_w + ligthweight_border * 2, sheet_thickness + ligthweight_border * 2], center=true);

                for(i=[-1, 1])
                   for(j=[-1, 1])
                       translate([i * prop_offset, j * prop_offset])
                           circle(r=prop_r + ligthweight_border);

                square([100 + ligthweight_border * 2, 100 + ligthweight_border * 2], center=true);

                // holes for mounting raspberry pi
                board_computer_screws(3.2 / 2 + ligthweight_border * 2, flight_controller_d);

                // oversized cutouts for keeping border around sensors
                sensor_transform()
                    laser_holder(true, true);
            }
            hex_pattern(300, 400, 1, 14);
        }

        // cutout for propellor holes except for support bars
        for(i=[-1, 1])
            for(j=[-1, 1])
                translate([i * prop_offset, j * prop_offset])
                    rotate([0, 0, i * j * 45 + i * 90 + (top?30:-30)])
                        prop_diff(!top, prop_r - (top?2:0), free=top);

        board_computer_screws(3.2 / 2, flight_controller_d);

        // marker holes
        if(top)
            transform_markers()
                circle(r=1.8);

        // watermark
        quadrant_transform([0, side_tap_pos])
            if($i == 1)
                scale([0.35, 0.35, 1.0])
                    translate([-47, -6.5, 0])
                        import(file="argmax.svg", layer="fan_top");

        // internal wall structure
        quadrant_transform([0, side_tap_pos])
            translate([$i * (side_w / 2 - side_tab / 2), 0])
                square([side_tab, sheet_thickness], center=true);

        quadrant_transform([cage_w / 2 - sheet_thickness / 2, 0])
            translate([$i * (side_w / 2 - side_tab / 2), 0])
                square([side_tab, sheet_thickness], center=true);

        // top and bottom access hole
        difference() {
            square([100, 100], center=true);

            if(!top)
                board_computer_screws(3.2 / 2 + ligthweight_border * 2, flight_controller_d, naze=false);

            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([i * prop_offset, j * prop_offset])
                        rotate([0, 0, i * j * 45 + 90 - i * 30 - 120 + i * 120 + (top?60:0)])
                            circle(r=prop_r + ligthweight_border);
        }

        // sensor cutouts
        sensor_transform()
            laser_holder(true);
    }
}

module round_square(s, r) {
    for(i=[-1, 1])
        for(j=[-1, 1])
            translate([i * (s[0] - r * 2) / 2, j * (s[1] - r * 2) / 2])
                circle(r=r);

    square([s[0], s[1] - r * 2], center=true);
    square([s[0] - r * 2, s[1]], center=true);
}

module hooksquare(d, center, hood_d, hook_r, dual) {
    if(dual)
        for(i=[-1, 1])
            translate([i * (d[0] - hook_r * 2 + hood_d * 2) / 2, -d[1] / 2])
                difference() {
                    circle(r=hook_r);
                    translate([0, hook_r])
                        square([hook_r * 2, hook_r * 2], center=true);
                }

    for(i=[-1, 1])
        translate([i * (d[0] - hook_r * 2 + hood_d * 2) / 2, d[1] / 2])
            difference() {
                circle(r=hook_r);
                translate([0, -hook_r])
                    square([hook_r * 2, hook_r * 2], center=true);
            }

    square(d, center=center);

    translate([0, (dual?0:hook_r) / 2])
        square([d[0] - hook_r * 2 + hood_d * 2, d[1] + hook_r + (dual?hook_r:0)], center=center);
}

module side_plate_pillar(side_tab, landing_l, cage_h, cage_r, cage_w, side_w, sheet_thickness) {
    difference() {
        union() {
            for(i=[-1, 1])
                translate([i * (side_w / 2 - side_tab / 2), 0])
                    hooksquare([side_tab, cage_h], true, 1, 3, true);

            square([side_w, cage_h - sheet_thickness * 2], center=true);
        }

        translate([-10, 0])
            round_square([side_w + 10, cage_h - sheet_thickness * 2 - 10], r=10);
    }
}

module side_plate(side_tab, landing_l, cage_h, cage_r, cage_w, side_w, sheet_thickness) {
    radius_extra_w = bend_perimeter + prop_offset - side_w / 2;
    gap_wall_radius = prop_offset - side_w / 2;
    bottom_band_h = 5;
    bottom_band_r = 10;
    slot_d = 17;
    band_ds = [[23.6, 0.0], [24, 30.6], [23.5, 61.7]];
    feet_corner_r = 25;
    min_hook_gap = 8;

    difference() {
        union() {
            for(i=[-1, 1])
                translate([i * (side_w / 2 - side_tab / 2), 0])
                    hooksquare([side_tab, cage_h], true, 1, 3, true);

            translate([side_w / 2 + radius_extra_w + gap_wall_radius + side_tab / 2, 0])
                hooksquare([side_tab, cage_h], true, 1, 3, true);

            for(i=[0:3])
                translate([i * (bend_perimeter / 3.0) + prop_offset, 0])
                    hooksquare([7, cage_h], true, 1, 3, false);

                translate([bend_offset, -cage_h / 2.0 - landing_l])
                    softcube([bend_perimeter + 7, landing_l * 2], r=20, flat=true);

            translate([-feet_corner_r + bend_offset, -cage_h / 2 + sheet_thickness - feet_corner_r])
                difference() {
                    square([feet_corner_r, feet_corner_r]);
                    circle(r=feet_corner_r);
                    translate([feet_corner_r - min_hook_gap, feet_corner_r - sheet_thickness])
                        square([min_hook_gap, sheet_thickness]);
                }

            translate([bend_perimeter + 7 + bend_offset, -cage_h / 2 + sheet_thickness - feet_corner_r])
                difference() {
                    square([feet_corner_r, feet_corner_r]);
                    translate([feet_corner_r, 0])
                        circle(r=feet_corner_r);
                    translate([0, feet_corner_r - sheet_thickness])
                        square([min_hook_gap, sheet_thickness]);
                }

            translate([radius_extra_w / 2 + gap_wall_radius / 2, 0])
                square([side_w + radius_extra_w + gap_wall_radius, cage_h - sheet_thickness * 2], center=true);
        }

        translate([40, -(cage_h - 10) / 2])
            softcube([30, cage_h - 10], r=10, flat=true);

        translate([40 + 128, -(cage_h - 10) / 2])
            softcube([30, cage_h - 10], r=10, flat=true);

        translate([-side_tab / 2 + side_w + radius_extra_w + gap_wall_radius + side_tab / 2, 0]) {
            translate([-22, 0])
                laser_holder(true);

            translate([22, 0])
                rotate([0, 0, 180])
                    laser_holder(true);
        }

        translate([-side_w / 2, 0])
            square([side_tab, cage_h + 10], true);

        translate([side_w / 2 + radius_extra_w + gap_wall_radius + side_tab, 0])
            square([side_tab, cage_h + 10], true);

        difference() {
            translate([0, -cage_h / 2.0])
                union() {
                    translate([side_tab / 2 + bend_offset, 0])
                    difference() {
                        translate([0, -landing_l + 10 / 2])
                            softcube([bend_perimeter + 7 - side_tab, landing_l + 57], r=15, flat=true);

                        translate([0, sheet_thickness])
                            difference() {
                                square([bend_perimeter + 7 - side_tab, bottom_band_h + bottom_band_r]);

                                for(band=band_ds) {
                                    band_d = band[0];
                                    band_x = band[1];
                                    translate([band_x + bottom_band_r, bottom_band_h]) {
                                        translate([0, bottom_band_r])
                                            circle(r=bottom_band_r);
                                        translate([band_d - bottom_band_r * 2, bottom_band_r])
                                            circle(r=bottom_band_r);
                                        square([band_d - bottom_band_r * 2, bottom_band_r + 0.1]);
                                    }
                                }
                            }

                        translate([0, -bottom_band_h - bottom_band_r])
                        difference() {
                            square([bend_perimeter + 7 - side_tab, bottom_band_h + bottom_band_r]);

                            for(band=band_ds) {
                                band_d = band[0];
                                band_x = band[1];
                                translate([band_x + bottom_band_r, 0]) {
                                    circle(r=bottom_band_r);
                                    translate([band_d - bottom_band_r * 2, 0])
                                        circle(r=bottom_band_r);
                                    translate([0, -0.1])
                                        square([band_d - bottom_band_r * 2, bottom_band_r + 0.1]);
                                }
                            }
                        }
                }

                translate([prop_offset + bend_perimeter / 2, sheet_thickness / 2])
                    square([bend_perimeter, sheet_thickness], center=true);
            }

            translate([side_tab / 2 + bend_offset, sheet_thickness - cage_h / 2.0])
                for(band=band_ds) {
                    band_d = band[0];
                    band_x = band[1];
                    translate([band_x + slot_d / 2, -3])
                        square([band_d - slot_d, bottom_band_h]);
                }

            for(i=[0:3])
                translate([i * (bend_perimeter / 3.0) + prop_offset, -landing_l / 2]) {
                    hooksquare([7, cage_h + landing_l], true, 1, 3, false);
                        for(j=[-1, 1])
                            translate([0, -sheet_thickness * 2])
                                rotate([0, 0, 90 + 90 * j])
                                    hooksquare([7, sheet_thickness], true, 1, 3, false);
                }
        }

        translate([-22, 0])
            laser_holder(true);

        translate([22, 0])
            rotate([0, 0, 180])
                laser_holder(true);

        intersection() {
            hex_pattern(56, 200, 1, 14);

            difference() {
                union() {
                    softcube_h = cage_h - sheet_thickness * 2 - 10;
                    translate([-side_w / 2 + 17, -softcube_h / 2])
                        softcube([side_w - 22, softcube_h], 5, flat=true);
                }

                translate([-22, 0])
                    laser_holder(true, true);

                translate([22, 0])
                    rotate([0, 0, 180])
                        laser_holder(true, true);
            }
        }
    }
}

drone(propellor_size);
