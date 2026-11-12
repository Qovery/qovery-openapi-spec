# Agent instructions

This repo holds the hand-maintained OpenAPI 3.0 spec of the Qovery public API:

- `openapi.yaml` (about 34k lines): the REST API, rendered at <https://api-doc.qovery.com>.
- `websocket/websocket-openapi.yaml`: the websocket API. It covers every live stream:
  logs, status, metrics, pods, nodes, shell, build analysis and blueprint previews.

## A change here reaches other repos

`.github/workflows/generate-clients.yaml` ("Generate API Clients") runs on every pull
request to `main` and on every push to `main`:

- **On a pull request** it generates and builds every client (Go, TypeScript axios,
  Rust, and their websocket variants) without publishing. This check is the one that
  proves a spec change compiles in every client. A red check on your PR is your problem,
  not noise.
- **On a push to `main`** it also publishes the clients to their repos.

| Client repo | Built from | Consumers |
|---|---|---|
| `qovery-client-go` | `openapi.yaml` | qovery-cli, terraform-provider-qovery |
| `qovery-client-typescript-axios` (npm `qovery-typescript-axios`) | `openapi.yaml` | console |
| `qovery-client-rust` | `openapi.yaml` | rust-backend (mcp-server, websocket-gateway) |
| `qovery-client-ws-go`, `qovery-client-ws-typescript-axios` (npm `qovery-ws-typescript-axios`), `qovery-client-ws-rust` | `websocket/websocket-openapi.yaml` | console uses the TypeScript one; check the others before changing a stream |

`update_documentation.yaml` also copies `openapi.yaml` into the public documentation.

q-core implements the endpoints by hand. A spec change needs the matching q-core
change, and the other way round. Consumers can only use a new field once this repo is
merged and the client is published, so client changes always come after the merge.

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
5. **Follow the neighbours.** `operationId` is lowerCamelCase and starts with a verb
   (`listOrganization`, `createOrganization`). Request and response bodies are named
   `<Thing>Request` and `<Thing>Response`; enums and shared types use plain names
   (`PlatformCloudVendor`). Nullable fields use `nullable: true` (OpenAPI 3.0, not 3.1
   type arrays).
6. **Keep the diff small.** Edit only the region you need. Never reformat, re-indent or
   reorder the file.
7. **Live streams** go in `websocket/websocket-openapi.yaml`, not in `openapi.yaml`.

## Check before pushing

- `npm test` runs Spectral on `openapi.yaml`. It fetches its ruleset from Stoplight, so
  it needs network access: a failure to fetch the ruleset is not a spec error. CI does
  not run it, so run it yourself.
- Rely on the "Generate API Clients" check of your pull request to prove the clients
  build. Don't use `npm run generate` for that: it uses an old generator wrapper (0.0.6,
  not the 7.x generators CI uses) and skips the build step. The post-generation scripts
  in `generator/post_generation_scripts/` use GNU tools and fail on macOS.

## Commits and pull requests

- Title: `type(scope): purpose`, with the component as scope
  (`feat(keda): expose the scaler id in KedaScalerRequest`). Some older commits put the
  Jira key in the scope; prefer the component and put the ticket in the body.
- The body says which consumers need a follow-up once the clients are published.
- `CHANGELOG.md` is no longer maintained (last entry 2021): don't add to it.
- Never push to `main`; merging is a human decision.

## Qovery Factory

For any public API change, the Qovery Factory builds this repo first, then q-core.
Each consumer that must expose the change (console, qovery-cli,
terraform-provider-qovery, rust-backend) is a separate follow-up run, started once this
repo is merged and its client is published.
