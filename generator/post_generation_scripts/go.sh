#!/bin/sh

set -x

sed -i 's/go 1.13/go 1.18/g' "$(find out/qovery-client-go/ -type f)"
cd out/qovery-client-go || exit 
cat model_job_response.go
go get
go mod tidy
gofmt -s -w .
gofmt -s -w .
go build
