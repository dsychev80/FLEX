.PHONY: build

build:
	./scripts/build_fmwk.sh FLEX $(mach_o)

build_dylib:
	@make build mach_o=mh_dylib

archive:
	zip -rq Product/FLEX.framework.zip Product/FLEX.framework