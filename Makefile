## Presentation makefile

# Directory for reveal.js
REVEAL_JS_DIR := reveal.js

# File name of the reveal.js tarball
REVEAL_JS_TAR := 2.6.1.tar.gz

# Download URL
REVEAL_JS_URL := https://github.com/hakimel/reveal.js/archive/$(REVEAL_JS_TAR)

## Presentation
index.html: vagrant-tutorial.md reveal.js
	pandoc -t revealjs -s -o $@ $<

## Download and install reveal.js locally
$(REVEAL_JS_DIR):
	wget $(REVEAL_JS_URL)
	tar xzf $(REVEAL_JS_TAR)
	rm $(REVEAL_JS_TAR)
	mv -T reveal.js* $(REVEAL_JS_DIR)

## Cleanup
clean:
	rm -f *.html
	rm -f *.pdf

## Thorough cleanup (also removes reveal.js)
mrproper: clean
	rm -rf $(REVEAL_JS_DIR)

all: index.html

vagrant-tutorial-handouts.pdf: vagrant-tutorial.md
	pandoc --variable mainfont="DejaVu Sans" \
		--variable monofont="DejaVu Sans Mono" \
		--variable fontsize=11pt \
		--variable geometry:margin=1.5cm \
		-f markdown  $< \
		--latex-engine=lualatex \
		-o $@

