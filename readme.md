# Fiber::Local

A module to simplify fiber-local state. This provides a convenient interface for providing a default per-thread instance, while allowing per-fiber overrides (e.g. per-request state handling).

[![Development Status](https://github.com/socketry/fiber-local/workflows/Test/badge.svg)](https://github.com/socketry/fiber-local/actions?workflow=Test)

## Usage

Please see the [project documentation](https://socketry.github.io/fiber-local/) for more details.

  - [Getting Started](https://socketry.github.io/fiber-local/guides/getting-started/index) - This guide will explain how and why to use `Fiber::Local` to simplify fiber-local state.

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.

## See Also

  - [thread-local](https://github.com/socketry/thread-local) — Strictly thread-local variables.
