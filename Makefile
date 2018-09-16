
project.bin: top.v project.pcf
	yosys -q -p "synth_ice40 -blif project.blif" top.v
	arachne-pnr -p project.pcf project.blif -o project.txt
	icebox_explain project.txt > project.ex
	icepack project.txt project.bin

.PHONY: flash
flash: project.bin
	iceprog project.bin

.PHONY: clean
clean:
	rm -f project.blif project.txt project.ex project.bin
