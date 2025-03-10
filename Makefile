.PHONY: mocks test build dist

PACKAGES := $(shell go list ./... | grep -v /mock)

build:
	go build -o bin/fargate main.go

mocks:
	go get github.com/golang/mock/mockgen
	go generate $(PACKAGES)

test:
	go test -race -cover $(PACKAGES)

dist:
	GOOS=darwin GOARCH=amd64 go build -o dist/build/fargate-darwin-amd64/fargate main.go
	GOOS=linux GOARCH=amd64 go build -o dist/build/fargate-linux-amd64/fargate main.go
	GOOS=linux GOARCH=386 go build -o dist/build/fargate-linux-386/fargate main.go
	GOOS=linux GOARCH=arm go build -o dist/build/fargate-linux-arm/fargate main.go
	GOOS=windows go get -u github.com/spf13/cobra
	GOOS=windows GOARCH=amd64 go build -o dist/build/fargate-windows-amd64/fargate.exe main.go
	GOOS=windows GOARCH=386 go build -o dist/build/fargate-windows-386/fargate.exe main.go

	cd dist/build/fargate-darwin-amd64 && zip fargate-${FARGATE_VERSION}-darwin-amd64.zip fargate
	cd dist/build/fargate-linux-amd64 && zip fargate-${FARGATE_VERSION}-linux-amd64.zip fargate
	cd dist/build/fargate-linux-386  && zip fargate-${FARGATE_VERSION}-linux-386.zip fargate
	cd dist/build/fargate-linux-arm  && zip fargate-${FARGATE_VERSION}-linux-arm.zip fargate
	cd dist/build/fargate-windows-amd64 && zip fargate-${FARGATE_VERSION}-windows-amd64.zip fargate.exe
	cd dist/build/fargate-windows-386  && zip fargate-${FARGATE_VERSION}-windows-386.zip fargate.exe

	find dist/build -name *.zip -exec mv {} dist \;

	rm -rf dist/build

clean:
	rm -f bin/fargate
	rm -rf dist
