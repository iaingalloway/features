# Devcontainer Features

A collection of [devcontainer features](https://containers.dev/implementors/features/) for installing CLI tools.

## Available Features

| Feature | Description |
| --- | --- |
| [gitversion](src/gitversion/README.md) | Installs the [GitVersion](https://github.com/GitTools/GitVersion) CLI |
| [markdownlint-cli2](src/markdownlint-cli2/README.md) | Installs the [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) CLI. Requires Node.js >= 20 and npm (e.g. via the [Node.js feature](https://github.com/devcontainers/features/tree/main/src/node)) |
| [sval](src/sval/README.md) | Installs the [sval](https://github.com/iaingalloway/sval) CLI |
| [vale](src/vale/README.md) | Installs the [Vale](https://github.com/vale-cli/vale) CLI |

## Usage

Add a feature to the `features` property in your `devcontainer.json`:

```json
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/iaingalloway/features/gitversion:1.0.0": {},
    "ghcr.io/iaingalloway/features/sval:1.0.0": {
      "version": "1.0.0"
    },
  }
}
```

Each feature accepts an optional `version` option. Set it to `"latest"` (the default) or a specific release tag (e.g. `"v3.14.1"` or `"3.14.1"`).
