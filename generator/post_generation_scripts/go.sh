#!/bin/sh
sed -i 's/OneOfstringboolean/interface{}/g' $(find out/qovery-client-go/ -type f)
sed -i 's/go 1.13/go 1.17/g' $(find out/qovery-client-go/ -type f)
cd out/qovery-client-go ; go get ; go mod tidy ; gofmt -s -w .
