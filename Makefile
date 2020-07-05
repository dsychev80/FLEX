.PHONY: build

build:
	./scripts/build_fmwk.sh FLEX $(mach_o)

build_dylib:
	@make build mach_o=mh_dylib

archive:
	cd Product && zip -rq FLEX.framework.zip FLEX.framework