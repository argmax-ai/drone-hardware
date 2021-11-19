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

beam_d = 3.2;
beam_w = 15;

module batteryholder() {
    $fn = 50;
    cell_dist = 15 + 2;
    main_cube_d = 38;
    h = 25;
    wall_d = 10.4;

    stl_yellow()
        difference() {
            union() {
                translate([-main_cube_d / 2, -main_cube_d / 2, 0])
                    softcube([main_cube_d, main_cube_d, h], 5);

                rotate([0, 0, 45])
                    translate([-50 / 2, -30 / 2, 0])
                        softcube([50, 30, h], 5);
            }

            translate([-(main_cube_d - wall_d) / 2, -(main_cube_d - wall_d) / 2, -0.05])
                softcube([main_cube_d - wall_d, main_cube_d - wall_d, h], 5);

            rotate([0, 0, 45]) {
                translate([0, 0, h / 2 + cell_dist])
                    cube([35, 100, h], center=true);

                rotate([0, 0, -90])
                    translate([5.5 - 5, 0, 3 / 2 + cell_dist])
                        cube([6 + 12, 100, 3], center=true);
            }

            // mounts for flight-controller
            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([j * flight_controller_d / 2, i * flight_controller_d / 2, -0.01])
                        cylinder(r=3 / 2, h=h - 10, $fn=20);

            // cutout for carbon fiber beams
            translate([0, 0, beam_w / 2 - 0.01]) {
                cube([100, beam_d, beam_w], center=true);
                rotate([0, 0, 90])
                    cube([100, beam_d, beam_w], center=true);
            }

            for(i=[0, 1])
                rotate([0, 0, i * 180 + 45])
                    translate([22.5, 0, 25-0.99])
                        scale([0.2, 0.2, 1.0])
                            translate([0, -47, 0])
                                rotate([0, 0, 90])
                                    linear_extrude(height = 1, center = false, convexity = 10)
                                        import(file="argmax.svg", layer="fan_top");
        }
}

batteryholder();
