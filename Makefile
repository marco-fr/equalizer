HDL_DIR = hdl
SIM_DIR = simulation
BUILD_DIR = obj_dir

SV_FILES = $(wildcard $(HDL_DIR)/*.sv)
CPP_FILES = $(wildcard $(SIM_DIR)/*.cpp)

VERILATOR = verilator
VERILATOR_FLAGS = \
    --cc \
    --exe \
    --trace \
    -Wall \
    -Wno-lint \
	--timing \
    --build

OUTPUT_EXE = $(BUILD_DIR)/Vaudio_equalizer

all: simulate

$(OUTPUT_EXE): $(SV_FILES) $(CPP_FILES)
	$(VERILATOR) $(VERILATOR_FLAGS) $(SV_FILES) $(CPP_FILES)

simulate: $(OUTPUT_EXE)
	$(OUTPUT_EXE)

clean:
	rm -rf $(BUILD_DIR) *.vcd

rebuild: clean all

.PHONY: all simulate clean rebuild help
