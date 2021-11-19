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

use <utils.scad>;
include <config.scad>;

module raspberrypi_holder(part=0) {
    $fn = 50;
    h = 30;
    r = 3.0 / 2;

    stl_blue()
        difference() {
            // bounding box with proud stands
            union() {
                translate([0, 0, h / 2])
                    cube([84, 50, h], center=true);

                translate([0, 0, h - 7 / 2])
                    translate([-84 / 2, -55 / 2, -7 / 2])
                        softcube([84, 55, 7], r=3);

                translate([-85 / 2, -56 / 2, h + 3 / 2])
                    rasp_holes(d=6, h=3);
            }

            // mounting holes for raspberry pi
            translate([-85 / 2, -56 / 2, h - 7 / 2 + 3 / 2])
                rasp_holes(d=2, h=7 + 3 + 0.02);

            // cutouts to reveal legs
            translate([0, 0, h / 2]) {
                translate([-20 / 2, 0, 0])
                    cube([87 - 7.5 * 2 - 20, 56.05, h + 0.02], center=true);

                translate([0, 0, -7 / 2 - 0.01])
                    cube([87 - 7.5 * 2, 56.05, h - 7], center=true);

                translate([0, 0, -3 / 2 - 0.01])
                    cube([87, 50 - 7.5 * 2, h - 3], center=true);

                cube([87 - 7.5 * 2, 50 - 7.5 * 2, h + 0.02], center=true);
            }

            // mounting holes for drone cage
            for(i=[-1, 1])
                for(j=[-1, 1])
                translate([j * 79.14 / 2, i * 42.13 / 2, 0])
                    cylinder(r=r, h * 2, $fn=20);

            // increased clearance for propellor
            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([i * prop_offset, j * prop_offset])
                        cylinder(r=56, h * 2, $fn=400);

            // splitting object into two printable parts
            if(part == 1)
                translate([0, -30, 0])
                    cube([60, 60, 60]);
            else if(part == 2)
                translate([-60, -30, 0])
                    cube([60, 60, 60]);
        }
}

raspberrypi_holder(part=0);
