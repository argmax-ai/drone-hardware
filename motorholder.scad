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

$fn = 80;

beam_d = 3.2;
beam_w = 15.1;

screw_l = 7.4 - 2.1 + 0.2;
screw_head_d = 6.5;

body_t = 10;
body_r = 13.5;

module holder_body(r, t) {
    translate([0, 0, -t / 2 + beam_w / 2 - 0.01]) {
        cylinder(r=r, h=t, center=true);

        translate([0, 0, -t / 2])
            difference() {
                sphere(r=r);
                translate([-r, -r, 0])
                    cube([2 * r, 2 * r, 2 * r]);
            }
    }
}

module holder_motor_screws() {
    d1 = 13.7 + 2.5;
    d2 = 16.7 + 2.5;

    translate([0, 0, -screw_l / 2 + beam_w / 2])
        rotate([0, 0, 45]) {
            d = 11.5;
            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([i * d / 2, j * d / 2]) {
                        cylinder(r=3.6 / 2, h=screw_l, center=true, $fn=20);

                        translate([0, 0, -50 / 2 - screw_l / 2])
                            cylinder(r=screw_head_d / 2, h=50, center=true, $fn=20);
                    }

            cylinder(r=7 / 2, h=100, center=true, $fn=20);

            for(j=[-1, 1])
                rotate([0, 0, j * 90 + 90])
                    translate([0, d2 / 2, 0]) {
                        cylinder(r=3.2 / 2, h=screw_l, center=true, $fn=20);

                        translate([0, 0, -50 / 2 - screw_l / 2])
                            cylinder(r=screw_head_d / 2, h=50, center=true, $fn=20);
                    }
        }
}

module motorholder() {
    stl_red()
        rotate([180, 0, 0]) {
            difference() {
                holder_body(body_r, body_t);

                rotate([0, 0, 45])
                    cube([50, beam_d, beam_w], center=true);

                holder_motor_screws();
            }
        }
}

motorholder();
