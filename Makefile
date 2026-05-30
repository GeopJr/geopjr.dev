.PHONY: all build run serve

release ?=
no_zip ?=
no_vips ?=

all: build

build:
	TT_THEMES=gruvbox,gruvbox-light SIXTEEN_THEMES=default-dark shards build -Dnothemes $(if $(no_vips),-Dnovips,) $(if $(release),--release,)

run:
	./bin/geopjr $(if $(no_zip),--no-zip,)

serve:
	./bin/geopjr serve

purgecss:
	pnpx purgecss --css dist/**/*.css --content dist/**/*.html dist/**/*.js --rejected --rejected-css --variables --font-face --keyframes 

