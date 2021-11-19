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
include <raspberryholder.scad>
use <dronecage.scad>
use <laser.scad>
use <batteryholder.scad>
use <motorholder.scad>

module bending_segment(start, offset, angle, n, h, round_start=false, round_end=false) {
    translate([start, 0, sheet_thickness / 2])
        rotate([0, angle, 0]) {
            difference() {
                translate([0, 0, -sheet_thickness / 2])
                    laser_cut_color()
                        intersection() {
                            translate([0, -h/2, 0])
                                square([offset, h]);
                            translate([-start, 0, 0])
                                children();
                        }
            }

            if(n > 1)
                translate([-start, 0, -sheet_thickness / 2])
                    bending_segment(start + offset, offset, angle, n-1, h)
                        children();

            if(n == 1)
                translate([-start, 0, -sheet_thickness / 2])
                    bending_segment(start + offset, 1000, angle, 0, h)
                        children();
        }
}

module bent_laser_cut_color(start, r, angle, h=1000) {
    r = r - 5.5;
    n = 20;
    perimeter = 2 * 3.14 * r / 360 * angle;

    bending_segment(0, start, 0, 0, h, round_end=true)
        children();

    bending_segment(start, perimeter / n, angle / (n + 1), n, h, round_end=true)
        children();
}

module transform_marker_spheres() {
    pos = motion_tracking_marker_pos;

    // drone 1 configuration
    //mask = [0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 1, 0];

    // drone 2 configuration
    mask = [1, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0];

    for(p=[0:len(pos) - 1])
        if(mask[p])
            translate([pos[p][0], pos[p][1], 0])
                children();
}

module laser_cut_color() {
    color([0.3, 0.3, 0.3, 1.0])
        linear_extrude(sheet_thickness)
            children();
}

module main() {
    // drone cage
    laser_cut_color()
        cage_bottom();

    translate([0, 0, cage_h - sheet_thickness])
        laser_cut_color()
            cage_top();

    for(i=[0:3])
        rotate([0, 0, i * 90])
            translate([side_tap_pos, 0, cage_h / 2])
                rotate([90, 0, 0])
                    translate([0, 0, -sheet_thickness / 2])
                        laser_cut_color()
                            cage_pillars();

    for(i=[0:3])
        rotate([0, 0, i * 90])
            translate([cage_w / 2 - sheet_thickness / 2, 0, cage_h / 2])
                rotate([0, 0, 90])
                    rotate([90, 0, 0])
                        translate([0, 0, -sheet_thickness / 2])
                            translate([-side_w / 2 + side_tab / 2, 0, 0])
                                bent_laser_cut_color(bend_offset + side_w / 2, cage_r, 90)
                                    translate([side_w / 2 - side_tab / 2, 0, 0])
                                        cage_side();

    // vertical lidar sensors
    for(n=[0, 2])
        for(j=[0:7])
            translate([0, 0, cage_h * ((n == 2)?1:0)])
                rotate([180 * ((n == 2)?1:0), 0, j * 90])
                    mirror([0, (j > 3)?1:0, 0])
                        translate([-cage_w / 2 + 20, 20, cage_h])
                            rotate([0, 0, -30])
                                laser_holder();

    // horizontal lidar sensors
    translate([0, 0, cage_h / 2])
        for(j=[0:7])
            rotate([0, 0, j * 90])
                translate([cage_w / 2, 0, 0])
                    rotate([0, 90, 0])
                        rotate([0, 0, 90 * ((j>3)?1:-1)])
                            translate([-22, 0, 0])
                                laser_holder();

    // motion capture markers
    translate([0, 0, cage_h - sheet_thickness + 8])
        transform_marker_spheres() {
            color([0.9, 0.9, 0.9])
                sphere(r=8 / 2);

            color([0.3, 0.3, 0.3])
                translate([0, 0, -8])
                    cylinder(r=3, h=8);
        }

    // carbon fiber beams
    translate([0, 0, -15 / 2 - 0.1]) {
        rotate([0, 0, 45]) {
            color([0.1, 0.1, 0.1, 1.0])
                cube([220, 3, 15], center=true);

            rotate([0, 0, 90])
                color([0.1, 0.1, 0.1, 1.0])
                    cube([220, 3, 15], center=true);
        }
    }

    // battery holder
    translate([0, 0, 0.1])
        rotate([180, 0, 45])
            batteryholder();

    // motor holder
    for(i=[0:3])
        rotate([0, 0, i * 90])
            translate([prop_offset, prop_offset, 0])
                translate([0, 0, -15 / 2])
                    rotate([180, 0, 0])
                        motorholder();

    // raspberrypi holder
    raspberrypi_holder();
}

main();
