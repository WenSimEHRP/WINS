ASEPRITE_FILES := $(shell find . -type f -name '*.aseprite')

ASEPRITE_8BPP_FILES := $(filter %_8bpp.aseprite,$(ASEPRITE_FILES))
ASEPRITE_RGB_FILES := $(filter-out %_8bpp.aseprite,$(ASEPRITE_FILES))

PNG_8BPP_FILES := $(ASEPRITE_8BPP_FILES:.aseprite=.png)
PNG_RGB_FILES := $(ASEPRITE_RGB_FILES:.aseprite=.png)
PNG_FILES := $(PNG_8BPP_FILES) $(PNG_RGB_FILES)

.PHONY: all clean debug

%_8bpp.png: %_8bpp.aseprite
	@echo "Processing 8BPP file: $<"
	@aseprite --batch $< --all-layers \
		--palette palette_8bpp.ase \
		--ignore-layer grid \
		--color-mode indexed --save-as $@

%.png: %.aseprite
	@echo "Processing RGB file: $<"
	@aseprite --batch $< --all-layers \
		--ignore-layer grid \
		--color-mode rgb --save-as $@

all: $(PNG_FILES)
	@echo "All PNG files generated"

clean:
	rm -f $(PNG_FILES)
