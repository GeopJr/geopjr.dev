.PHONY: all build run serve

release ?=
no_zip ?=

all: build

build:
	TT_THEMES=gruvbox,gruvbox-light SIXTEEN_THEMES=default-dark shards build -Dnothemes $(if $(release),--release,)

run:
	./bin/geopjr $(if $(no_zip),--no-zip,)

serve:
	./bin/geopjr serve
