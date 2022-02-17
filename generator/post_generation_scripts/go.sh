#!/bin/sh
sed -i 's/AnyOfstringboolean/interface{}/g' $(find out/qovery-client-go/ -type f)
gofmt -s -w -l out/qovery-client-go/