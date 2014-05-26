flicker.run:
flicker.obx: image.asm

#palette := flickerpal.png 
palette := pal.png

%.jpg.xex: %.jpg $(palette) img2flicker flicker.asm.pp
	./img2flicker $< $(palette) > image.asm
	make flicker.xex
	mv flicker.xex $@

%.png.xex: %.png $(palette) img2flicker flicker.asm.pp
	./img2flicker $< $(palette) > image.asm
	make flicker.xex
	mv flicker.xex $@

%.gif.xex: %.gif $(palette) img2flicker flicker.asm.pp
	./img2flicker $< $(palette) > image.asm
	make flicker.xex
	mv flicker.xex $@

out = > $@~ && mv $@~ $@

atari = altirra


%.run: %.xex
	$(atari) $<

%.xex: %.obx
	cp $< $@

%.boot: %.atr
	$(atari) $<

%.atr: %.obx obx2atr
	./obx2atr $< $(out)

%.asm.pl: %.asm.pp
	echo 'sub interp {($$_=$$_[0])=~s/<<<(.*?)>>>/eval $$1/ge;print}' > $@
	perl -pe 's/^\s*>>>// or s/(.*)/interp <<'\''EOF'\'';\n$$1\nEOF/;' $< >> $@

%.asm: %.asm.pl
	perl $< $(out)
	
%.obx: %.asm
	#mads -t:$*.lst -l:$*.listing $<
	xasm /t:$*.lab /l:$*.lst $<
	perl -pi -e 's/^n /  /' $*.lab

.PRECIOUS: %.obx %.atr %.xex %.asm %.jpg.xex %.png.xex %.gif.xex
