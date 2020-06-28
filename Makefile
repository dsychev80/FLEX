.PHONY: build

build:
	./build_fmwk.sh FLEX $(mach_o)

build_dylib:
	@make build mach_o=mh_dylib