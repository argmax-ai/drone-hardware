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

include <config.scad>;
use <utils.scad>;

$fn=50;

module laser_negative() {
    pcb_w = 18.3;
    pcb_l = 22.3;
    pcb_hole_dist = 0.6 * 25.4;
    hole_d = 2.0;

    translate([0.3 * 25.4 - (1.5 + 2.3 / 2), 0, -5])
    hull() {
        translate([-1.5, 0, 0])
            anglecone(30, 400);

        translate([1.5, 0, 0])
            anglecone(30, 400);
    }

    union() {
        translate([-2.3, -pcb_l / 2, -20])
            cube([pcb_w, pcb_l, 20]);

        difference() {
            union() {
                translate([0.5, -pcb_l / 2, -20 + 1.5])
                    cube([pcb_w-2.5,pcb_l,20]);

                translate([0.5 - 2.9, -pcb_l / 2 + 6, -20 + 1.5 - 0.4])
                    cube([3, 7, 20]);
            }

            for(i=[-1,1])
                translate([0, pcb_hole_dist / 2 * i, 0])
                cylinder(r=hole_d / 2 + 0.8, h=10 * 2, center=true, $fn=50);
        }

    for(i=[-1, 1])
        translate([0, pcb_hole_dist / 2 * i, 0])
            cylinder(r=hole_d / 2, h=20, center=true, $fn=50);
}
}

module laser_holder(cutout=false, keep_out=false) {
    hole_d = 2.0;
    angle = -15;
    offset = -5;
    w = 20;
    h = 8;
    l = 35;

    stl_green()
    difference() {
        if(keep_out && cutout) {
            difference() {
                union() {
                    translate([-(w + 3.3) / 2, -(l - 13 + 3.3) / 2, 0])
                        softcube([w + 3.3, l - 13 + 3.3, h], 3, true);

                    translate([-13, 0, 0])
                        circle(r=4, $fn=50);
                }

                laser_holder(cutout=cutout, keep_out=false);
            }
        } else {
            if(cutout) {
                translate([-w / 2 - 0.15, -l / 2 + 13 / 2 - 0.15, 0])
                    softcube([w + 0.3, l - 13 + 0.3, h], 3, true);

                translate([-13, 0, 0])
                    circle(r=hole_d / 2 + 0.3, $fn=50);
            } else {
                difference() {
                    union() {
                        translate([-17, -5, -h])
                            softcube([20, 10, h - sheet_thickness], 3);

                        translate([-w / 2, -l / 2 + 13 / 2, -h])
                            softcube([w, l - 13, h], 3);
                    }

                    translate([offset, 0, -7])
                        rotate([0, angle, 0])
                            laser_negative();

                    translate([-13, 0, 0])
                        cylinder(r=hole_d / 2, h=h * 2, center=true, $fn=50);
                }
            }
        }

        translate([7.5, 0, -0.99])
            scale([0.2, 0.2, 1.0])
                translate([0, -47, 0])
                    rotate([0, 0, 90])
                        linear_extrude(height = 1, center = false, convexity = 10)
                            import(file="argmax.svg", layer="fan_top");
    }
}

laser_holder(false, true);
