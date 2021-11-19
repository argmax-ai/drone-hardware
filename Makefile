OS := $(shell uname -s)
ifeq ($(OS),Linux)
	OPENSCAD := openscad
endif
ifeq ($(OS),Darwin)
	OPENSCAD := /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
endif
OUT_DIR := build
MKDIR := mkdir -p

STL_PARTS := laser batteryholder raspberryholder motorholder
DXF_PARTS := cagetop cagebottom cageside cagepillar

STL := $(patsubst %,$(OUT_DIR)/%.stl,$(STL_PARTS))
DXF := $(patsubst %,$(OUT_DIR)/%.dxf,$(DXF_PARTS))
IMG := $(patsubst %,$(OUT_DIR)/%.png,$(STL_PARTS) main)
DXFIMG := $(patsubst %,$(OUT_DIR)/%.png,$(DXF_PARTS))

all:	$(STL) $(DXF) $(IMG) $(DXFIMG)

clean:
	rm -rf $(OUT_DIR)

$(OUT_DIR):
	${MKDIR} $(OUT_DIR)

$(STL): $(OUT_DIR)/%.stl : %.scad | $(OUT_DIR)
	$(OPENSCAD) -q -o $@ $<

$(DXF): $(OUT_DIR)/%.dxf : %.scad | $(OUT_DIR)
	$(OPENSCAD) -q -o $@ $<

$(IMG): $(OUT_DIR)/%.png : %.scad | $(OUT_DIR)
	$(OPENSCAD) -q -projection=o --imgsize=2048,2048 -o $@ $<

$(DXFIMG): $(OUT_DIR)/%.png : %.scad | $(OUT_DIR)
	$(OPENSCAD) -q -projection=o --imgsize=2048,2048 --camera=0,0,1,0,0,-100 --viewall --autocenter --render -o $@ $<

