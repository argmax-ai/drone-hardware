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

module softcube(size, r, flat=false, soft=true) {
    if(!flat) {
        translate([size[0] / 2.0, size[1] / 2.0, size[2] / 2.0]) {
            cube([size[0], size[1] - r * 2.0, size[2]], center=true);
            cube([size[0] - r * 2.0, size[1], size[2]], center=true);

            for(i=[-1, 1])
                for(j=[-1, 1])
                    translate([i * (size[0] / 2.0 - r), j * (size[1] / 2.0 - r), 0])
                        cylinder(r=r, h=size[2], center=true);
        }
    } else {
        union() {
            translate([size[0] / 2.0, size[1] / 2.0]) {
                if(soft) {
                    difference() {
                        square([size[0], size[1]], center=true);

                        for(i=[-1, 1])
                            for(j=[-1, 1])
                                translate([i * (-size[0] / 2 + r / 2), j * (-size[1] / 2 + r / 2), 0])
                                    square([r, r], center=true);
                    }

                    for(i=[-1, 1])
                        for(j=[-1, 1])
                            translate([i * (size[0] / 2.0 - r), j * (size[1] / 2.0 - r), 0])
                                circle(r=r);
                } else {
                    square([size[0], size[1]], center=true);
                }
            }
        }
    }
}

module anglecone(angle, l) {
    cylinder(h=l, r2=tan(angle / 2.0) * l, r1=0);
}

module hex_pattern(w, h, d, r) {
    for(i=[-w / (d + r) * 0.5:w / (d + r) * 0.5])
        for(j=[-h / (d + r) * 0.5:h / (d + r) * 0.5])
            translate([(d / sqrt(3) * 2 + r) * 3 / 2 * j, (d + r * sqrt(3) / 2)  * (i + (j % 2) / 2) * 2, 0])
                circle(r=r, $fn=6);
}

module rasp_holes(d=2.75, h=2) {
    $fn=50;

    translate([58 / 2 + 3.5, 56 / 2, 0])
        for(i=[-1, 1])
            for(j=[-1, 1])
                translate([i * 58 / 2, j * 49 / 2, 0])
                    cylinder(r=d / 2, h=h, center=true);
}
