sed -i 's/AnyOfstringboolean/interface{}/g' $(find out/client/ -type f)
gofmt -s -w -l out/client/