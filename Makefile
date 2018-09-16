PROJ = project

PIN_DEF = icestick.pcf
DEVICE = hx1k

BLIF_FILES = top.blif led.blif pwm.blif breath.blif

.PHONY: all
all: top.rpt top.bin

%.blif: %.v
	yosys -p 'synth_ice40 -top top -blif $@' $<

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

%.bin: %.asc
	icepack $< $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_tb: %_tb.v $(BLIF_FILES:%.blif=%.v)
	iverilog -o $@ $^

%_tb.vcd: %_tb
	vvp -N $< -vcd

%_tb.lxt: %_tb
	vvp -N $< -lxt2

%_syn.v: %.blif
	yosys -p 'read_blif -wideports $^; write_verilog $@'

.PHONY: prog
prog: top.bin
	iceprog $<

.PHONY: clean
clean:
	$(RM) $(BLIF_FILES) *.asc *.rpt *.bin $(BLIF_FILES:%.blif=%.blif.d) *.vcd *.lxt *_tb

# Dependency generation, based on
# https://stackoverflow.com/questions/47719172/how-to-output-dependency-files-in-yosys-gcc-mmd-equivalent
-include $(BLIF_FILES:%.blif=%.blif.d)

$(BLIF_FILES): $(BLIF_FILES:%.blif=%.v)
	yosys -q -E $@.d -p 'read_verilog $(BLIF_FILES:%.blif=%.v)' -p 'synth_ice40 -blif $@'

