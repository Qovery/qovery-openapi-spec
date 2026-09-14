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



### Catalog string editors

`ScalarFieldSchemaResponse` optionally exposes `format` and `templates` without changing its
`type: string`. `FieldTemplateResponse` supplies an ID, label and starting text. These optional
properties are omitted on existing responses and add no endpoint or request shape. Consumers
select the editor by format (currently `kubernetes-resource-yaml`), fall back to an ordinary
string editor for unknown formats, and apply a template only after an explicit user choice.
A saved profile remains the source of truth; templates never overwrite it or act as defaults.
