# Copyright 2026 Paul Maddern (paul@arcadegeek.co.uk)
SNAPSHOT = TrapDoor.z80
T2S = trapdoor.t2s

MK = $(SKOOLKIT_HOME)/tools/disassembly.mk
ifeq ($(wildcard $(MK)),)
	$(error $(MK): file not found)
endif
include $(MK)

# Prerequisite-only: make merges this with disassembly.mk's html recipe
# without an override warning. map runs first and leaves tiles in place.
# skool2html does not delete existing files under images/.
html: map

.PHONY: map
map: snapshot
	mkdir -p $(BUILD)/html/trapdoor/images \
	  $(BUILD)/html/trapdoor/dec/images
	python3 utils/render_trapdoor_map.py $(SNAPSHOT) \
	  $(BUILD)/html/trapdoor/images \
	  $(BUILD)/html/trapdoor/dec/images
