.PHONY: all get_minify build_geopjr run_geopjr get_sass sass minify clean

release ?=

all: get_minify build_geopjr get_sass sass minify

get_minify:
ifeq (,$(wildcard ./minify))
	wget https://github.com/tdewolff/minify/releases/download/v2.20.37/minify_linux_amd64.tar.gz
	mkdir minify_temp
	tar -xvf minify_linux_amd64.tar.gz -C minify_temp
	mv ./minify_temp/minify .
	chmod +x ./minify
endif


minify:
	./minify -r -o ./dist/ ./dist/

build_geopjr:
	TT_THEMES=gruvbox,gruvbox-light SIXTEEN_THEMES=default-dark shards build -Dnothemes $(if $(release),--release,)
	./bin/geopjr

run_geopjr:
	./bin/geopjr

get_sass:
ifeq (,$(wildcard ./dart-sass/sass))
	wget https://github.com/sass/dart-sass/releases/download/1.79.1/dart-sass-1.79.1-linux-x64.tar.gz -O sass.tar.gz
	tar -xvf sass.tar.gz
	chmod +x ./dart-sass/sass
endif

sass:
	./dart-sass/sass ./src/scss/:./dist/assets/css/ --no-source-map --style compressed

clean:
	rm -rf ./minify ./dart-sass/ ./sass.tar.gz ./minify_temp ./minify_linux_amd64.tar.gz

zip:
	cd dist && zip -r9q ../dist.zip . && cd ..
