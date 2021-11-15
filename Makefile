CC=$(GOROOT)/bin/go
MOD=${GOPATH}/pkg/mod
PWD=$(shell pwd)
TARGET=fbs
env GO111MODULE=on


proto:
	@echo "### Start building FBS protocol ###"
	@go get github.com/googleapis/googleapis@v0.0.0-20200819230600-65097bb8a184

	protoc \
	-I$(PWD) \
	-I$(MOD)/github.com/googleapis/googleapis@v0.0.0-20200819230600-65097bb8a184 \
	-I$(MOD)/github.com/grpc-ecosystem/grpc-gateway/v2@v2.3.0 \
	--include_imports=. \
	--include_source_info=. \
	--go_out=./go \
	--go_opt=paths=source_relative \
	--go-grpc_out=./go \
	--go-grpc_opt=paths=source_relative \
	--go-grpc_opt=require_unimplemented_servers=false \
	--java_out=./java \
	--java-grpc_out=./java \
	--java-grpc_opt=paths=source_relative \
	--java-grpc_opt=require_unimplemented_servers=false \
	--grpc-gateway_out=./go \
	--grpc-gateway_opt=paths=source_relative \
	--grpc-gateway_opt=logtostderr=true \
	--grpc-gateway_opt=allow_delete_body=true \
	--grpc-gateway_opt=generate_unbound_methods=true \
	--openapiv2_opt=logtostderr=true \
	--openapiv2_out=. \
	--descriptor_set_out=./$(TARGET).pb \
	$(TARGET).proto;

	@echo "### Building FBS protocol is done ###"

install-linux: install-base
	curl -o ./protoc-gen-java-grpc https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.37.0/protoc-gen-grpc-java-1.37.0-linux-x86_64.exe
	chmod 0755 ./protoc-gen-java-grpc
	mv ./protoc-gen-java-grpc /usr/local/bin/protoc-gen-java-grpc

install-osx: install-base
	curl -o ./protoc-gen-java-grpc https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.37.0/protoc-gen-grpc-java-1.37.0-osx-x86_64.exe
	chmod 0755 ./protoc-gen-java-grpc
	mv ./protoc-gen-java-grpc /usr/local/bin/protoc-gen-java-grpc

install-base:
	GO111MODULE=on \
	go install \
        github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway \
        github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 \
        google.golang.org/protobuf/cmd/protoc-gen-go \
        google.golang.org/grpc/cmd/protoc-gen-go-grpc

.PHONY: all \
	proto \
	install-linux \
	install-osx \
	install-base
