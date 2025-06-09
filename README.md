# API Documentation

link: https://api-doc.qovery.com

## Generated Clients Repositories:
- [Go](https://github.com/Qovery/qovery-client-go)
- [Python](https://github.com/Qovery/qovery-client-python)
- [Typescript](https://github.com/Qovery/qovery-client-typescript-axios)

## Run locally

To run the openapi generator locally, you can do i.e for Rust
You will have the sdk in the path `out/qovery-client-rust`

```
 openapi-generator-cli generate -g rust \
       -i openapi.yaml \
       -o out/qovery-client-rust \
       -c generator/configs/rust.yaml
./generator/post_generation_scripts/rust.sh
```

