# Agent instructions

This repo holds the specs of the Qovery public API:

- `openapi.yaml` (OpenAPI 3.0, about 34k lines): the REST API, **maintained by hand**,
  rendered at <https://api-doc.qovery.com>.
- `websocket/websocket-openapi.yaml` (OpenAPI 3.1): the websocket API, **generated**.
  It comes from rust-backend's websocket-gateway with utoipa
  (`websocket-gateway/src/generate_api.rs`). Never edit it by hand: change the gateway,
  then run `just generate_websocket_openapi` in rust-backend, which commits the new
  file here. Hand edits are lost at the next regeneration.

## A change here reaches other repos

`.github/workflows/generate-clients.yaml` ("Generate API Clients") runs on every pull
request to `main` and on every push to `main`. On a pull request it generates every
client without publishing and runs the post-generation scripts in
`generator/post_generation_scripts/`. On a push to `main` it also publishes the
clients to their repos.

| Client repo | Built from | Consumers |
|---|---|---|
| `qovery-client-go` | `openapi.yaml` | qovery-cli, terraform-provider-qovery |
| `qovery-client-typescript-axios` (npm `qovery-typescript-axios`) | `openapi.yaml` | console |
| `qovery-client-rust` | `openapi.yaml` | rust-backend (mcp-server, websocket-gateway) |
| `qovery-client-ws-go`, `qovery-client-ws-typescript-axios` (npm `qovery-ws-typescript-axios`), `qovery-client-ws-rust` | `websocket/websocket-openapi.yaml` | console uses the TypeScript one; check the others before changing a stream |

`update_documentation.yaml` also copies `openapi.yaml` into the public documentation.

**A green check does not prove every client compiles.** What the post-generation
scripts actually cover:

| Client | Built on a PR? |
|---|---|
| Go | Yes |
| TypeScript axios, REST and websocket | Yes (`npm run build`) |
| Rust REST | Built, but `rust.sh` ends with `cargo fmt` and doesn't stop on errors, so a failed `cargo build` still passes. Read the step's log. |
| Go websocket | No: `go-ws.sh` builds the REST output folder instead |
| Rust websocket | No: `rust-ws.sh` is empty |

Fixing these scripts belongs in its own pull request, not in a spec change.

q-core implements the REST endpoints by hand. A change to `openapi.yaml` needs the
matching q-core change, and the other way round. Consumers can only use a new field
once this repo is merged and the client is published, so client changes always come
after the merge.

## Rules

1. **Backward compatible by default.** Older CLI and Terraform provider versions stay
   in use for months. All of these break them:
   - removing or renaming a path, a field or an enum value;
   - changing a field's type or format;
   - adding a required request field, or making an optional one required;
   - narrowing an existing field: removing `nullable`, tightening validation
     (pattern, min/max, enum), changing a default.

   Adding optional fields and new endpoints is safe.
2. **Breaking changes go in two steps.** First mark the old shape `deprecated: true`
   with a description naming its replacement. Remove it in a later change, with `!` in
   the title (`feat(api)!: …`).
3. **New enum values** can break consumers that decode enums strictly. List the
   consumers in the PR and say whether you checked them.
4. **Describe behaviour, not just shape.** Every new field gets a `description`
   covering meaning, units, defaults and what `null` or absence means. The README's
   "Catalog" sections show the expected level of detail.
5. **Follow the neighbours in `openapi.yaml`.** `operationId` is lowerCamelCase and
   starts with a verb (`listOrganization`, `createOrganization`); a few older
   operations use PascalCase, don't copy them. Request and response bodies are named
   `<Thing>Request` and `<Thing>Response`; enums and shared types use plain names
   (`PlatformCloudVendor`). Nullable fields use `nullable: true`. Names and nullable
   forms in the websocket spec come from the Rust code; don't use them as a model here.
6. **Keep the diff small.** Edit only the region you need. Never reformat, re-indent or
   reorder the file.
7. **Live streams** are added in rust-backend's websocket-gateway, never in
   `openapi.yaml`. The websocket spec here follows by regeneration.

## Check before pushing

- `npm test` runs Spectral on `openapi.yaml`. It fetches its ruleset from Stoplight, so
  it needs network access: a failure to fetch the ruleset is not a spec error. CI does
  not run it, so run it yourself.
- Use the "Generate API Clients" check of your pull request, with the gaps above in
  mind. Don't use `npm run generate` locally: it uses an old generator wrapper (0.0.6,
  not the 7.x generators CI uses) and skips the build step. The post-generation
  scripts use GNU tools and fail on macOS.

## Commits and pull requests

- Title: `type(scope): purpose`, with the component as scope
  (`feat(keda): expose the scaler id in KedaScalerRequest`). Some older commits put the
  Jira key in the scope; prefer the component and put the ticket in the body.
- The body says which consumers need a follow-up once the clients are published.
- `CHANGELOG.md` is no longer maintained (last entry 2021): don't add to it.
- Never push to `main`; merging is a human decision.

## Qovery Factory

- REST change: the Qovery Factory builds this repo first, then q-core.
- Websocket change: rust-backend's websocket-gateway first, then the regenerated spec
  lands here.
- Each consumer that must expose the change (console, qovery-cli,
  terraform-provider-qovery, rust-backend) is a separate follow-up run, started once
  this repo is merged and its client is published.
