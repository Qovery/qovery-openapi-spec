# API Documentation

link: https://api-doc.qovery.com

## Generated Clients Repositories:
- [Go](https://github.com/Qovery/qovery-client-go)
- [Python](https://github.com/Qovery/qovery-client-python)
- [Typescript](https://github.com/Qovery/qovery-client-typescript-axios)

## Run locally

### Install dependencies

`npm install`

### Run locally

`npm run preview`

## Design draft document

[DESIGN_DRAFT.md](DESIGN_DRAFT.md)

## Generate API client

`QOVERY_CLIENT_LANGUAGE=go npm run generate`

## Generate the template for Go

`npm run generate_go_template`

To customize the OpenAPI generator for Go, we need to make some modifications to the Go template.
First, we download the Go template locally using the command: `openapi-generator-cli author template -g go --library webclient -o go_template`
Then, we apply the patch located in the go_template_patch directory.
And, we update the go.yaml config file to add the template directory using the templateDir option.

see: https://openapi-generator.tech/docs/customization/


© 2022 GitHub, Inc.
Terms
Privacy
Security
Status

