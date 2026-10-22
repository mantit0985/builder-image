# Changelog

All notable changes to this project will be documented in this file.

## v0.1.0

### Added

- Shared toolchain base image targets (runtime, runtime-slim, runtime-alpine, runtime-distroless) published to GHCR via the hub CD workflow.
- CI quality gate: image deploys block until CI is green on the tagged commit.
