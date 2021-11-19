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

$fn = 50;
ligthweight_border = 3;
propellor_size = 4.1;
sheet_thickness = 2;
cage_h = 70;
cage_r = 14 * propellor_size + 2;
cage_w = cage_r * 4 + 25;
side_tab = 15;
side_w = cage_w / 2 - 100 / 2 - sheet_thickness;
side_tap_pos = cage_w / 2 - side_w / 2 - sheet_thickness;
prop_r = propellor_size * 25.4 / 2;
flight_controller_d = 30.5;
landing_l = 60;
prop_offset = cage_w / 2 - cage_r;
bend_perimeter = cage_r * 3.14 * 2.0 / 4.0;
bend_offset = prop_offset + bend_perimeter / 2 - (bend_perimeter + 7) / 2;

motion_tracking_marker_pos = [
      [100.0, 5.0], [70.0, -5.0], [85.0, -16.0], [55.0, 16.0],
      [-95.0, 10.0], [-80.0, -15.0], [-60.0, 15.0], [-80.0, 15.0],
      [5.0, 100.0], [-5.0, 70.0], [-16.0, 85.0], [16.0, 55.0],
      [5.0, -95.0], [-17.0, -80.0], [10.0, -60.0], [123.0, -40.0],
      [-123.0, -50.0], [120.0, 40.0], [-118.0, 40.0], [-50.0, 123.0],
      [-45.0, -123.0], [45.0, 123.0], [50.0, -123.0]
];

module stl_yellow() {
    color([200, 203, 119] / 255)
        children();
}

module stl_red() {
    color([203, 122, 119] / 255)
        children();
}

module stl_blue() {
    color([119, 158, 203] / 255)
        children();
}

module stl_green() {
    color([119, 221, 119] / 255)
        children();
}
