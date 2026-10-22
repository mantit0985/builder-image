# Builder — Shared Toolchain Base Images

![CI](https://github.com/mantit0985/builder-image/actions/workflows/ci.yml/badge.svg) ![CD](https://github.com/mantit0985/builder-image/actions/workflows/cd.yml/badge.svg) ![Version](https://img.shields.io/github/v/tag/mantit0985/builder-image) ![License](https://img.shields.io/github/license/mantit0985/builder-image)

The **mantit0985/builder** repository hosts the shared toolchain base Docker images used across the mantit0985 fleet. Templates and services pull them in as thin layers with `FROM ghcr.io/mantit0985/builder:<tag>`, so each project Dockerfile only adds what makes it different. Builds benefit from Actions caching.

## Published Images

Images are published to `ghcr.io/mantit0985/builder` under three base targets, defined in `Dockerfile`:

| Target | Base | Use |
|--------|------|-----|
| `slim` | `debian:bookworm-slim` | Debian-based builds needing apt tooling |
| `alpine` | `alpine:3.20` | Minimal musl-based images |
| `distroless` | aliases the `slim` runtime | For images without a shell or package manager; matches the runner-repo Dockerfile pattern |

Every base target ships the common utility set: `ca-certificates`, `curl`, `git`, `jq`, `unzip`, and Node.js with npm. Distroless cannot host a shell or package manager, so it aliases the `slim` runtime rather than building its own layer stack. Additional per-language toolchain stages are planned but not yet published.

## How CI/CD Work

- **CI** (`.github/workflows/ci.yml`): on every push to `main` and every pull request, CI verifies a build of the image (verify-only; nothing is pushed).
- **CD** (`.github/workflows/cd.yml`): gated by CI success on `main` and delegated to the hub contract (`mantit0985/.github/.github/workflows/cd.yml@main`), which publishes the image to GHCR. CD can also run on demand via `workflow_dispatch`.
- **Release**: the operator pushes the annotated, GPG-signed `v*` tag for the version in `VERSION` (tag push is the only operator release act). CD publishes the image, then the hub's embedded publish-release step validates the tag — rejecting lightweight or unsigned tags and requiring a CHANGELOG section matching `VERSION` — and creates the release object.

## Project Structure

- `Dockerfile` — the three base target definitions; all package installs are pinned distro versions with caches purged in-layer.
- `.github/workflows/ci.yml` — build verification on every push and pull request.
- `.github/workflows/cd.yml` — publishes the image to GHCR on merges to `main`, via the hub CD contract.
- `VERSION` / `CHANGELOG.md` — release version source of truth; tag matches VERSION at publish time.
