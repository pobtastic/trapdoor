# Copyright 2026 Paul Maddern (paul@arcadegeek.co.uk)
MK = $(SKOOLKIT_HOME)/tools/disassembly.mk
ifeq ($(wildcard $(MK)),)
	$(error $(MK): file not found)
endif
include $(MK)

.PHONY: map
map: html TrapDoor.z80
	python3 utils/render_trapdoor_map.py TrapDoor.z80 \
	  $(BUILD)/html/trapdoor/images \
	  $(BUILD)/html/trapdoor/dec/images
