.PHONY: all build run serve

release ?=

all: build

build:
	TT_THEMES=gruvbox,gruvbox-light SIXTEEN_THEMES=default-dark shards build -Dnothemes $(if $(release),--release,)

run:
	./bin/geopjr

serve:
	./bin/geopjr serve
