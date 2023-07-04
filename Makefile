# Source: https://github.com/adnanh/webhook/blob/f187592147f3a691bc1dc872728f8d6662595ea4/Makefile

OS = darwin freebsd linux openbsd
ARCHS = 386 arm amd64 arm64


.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

all: build release release-windows

build: deps ## Build the project
	go build

release: clean deps ## Generate releases for unix systems
	@for arch in $(ARCHS);\
	do \
		for os in $(OS);\
		do \
			echo "Building $$os-$$arch"; \
			mkdir -p build/go-wol-$$os-$$arch/; \
			GOOS=$$os GOARCH=$$arch go build -o build/go-wol-$$os-$$arch/go-wol  ./cmd/wol; \
			tar cz -C build -f build/go-wol-$$os-$$arch.tar.gz go-wol-$$os-$$arch; \
		done \
	done

release-windows: clean deps ## Generate release for windows
	@for arch in $(ARCHS);\
	do \
		echo "Building windows-$$arch"; \
		mkdir -p build/go-wol-windows-$$arch/; \
		GOOS=windows GOARCH=$$arch go build -o build/go-wol-windows-$$arch/go-wol.exe  ./cmd/wol; \
		tar cz -C build -f build/go-wol-windows-$$arch.tar.gz go-wol-windows-$$arch; \
	done

test: deps ## Execute tests
	go test ./...

deps: ## Install dependencies using go get
	go get -d -v -t ./...

clean: ## Remove building artifacts
	rm -rf build
	rm -f go-wol