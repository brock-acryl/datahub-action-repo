# DataHub Cloud action (sample)

Minimal [DataHub Actions](https://docs.datahub.com/docs/actions/guides/developing-an-action) pipeline: `datahub-cloud` source and a custom `sample_cloud_action` that prints incoming events.

## Prerequisites

- Python 3.10 or newer
- A DataHub Cloud **GMS** URL and **personal access token** (PAT)

## Configure credentials

1. Copy the example env file and edit the values:

   ```bash
   cp .env.example .env
   ```

2. Set `server` to your Cloud GMS base URL (often `https://<org>.acryl.io` or `https://<org>.acryl.io/gms`) and `token` to your PAT.

The pipeline file [`my-datahub-cloud-action.yaml`](my-datahub-cloud-action.yaml) expects `${server}` and `${token}` in the environment (see the `datahub` block).

## Run locally

Install the package in editable mode, export variables from `.env`, then start the pipeline:

```bash
pip install -e .
set -a && source .env && set +a
datahub actions run -c my-datahub-cloud-action.yaml
```

Stop with `Ctrl+C`. You should see logging from the DataHub Cloud source, `{}` from the action’s `create()` (empty config), then `EventEnvelope(...)` lines as events arrive.

## Quick test (short run)

To confirm startup and a few events without leaving the process running:

```bash
pip install -e .
set -a && source .env && set +a
timeout 20 datahub actions run -c my-datahub-cloud-action.yaml
```

Adjust the timeout as needed. Exit code `124` means the timeout stopped the process; that is expected.

## Docker

Build the image from the repository root:

```bash
docker build -t custom-action-example .
```

Run the same pipeline inside a container. Pass credentials with `--env-file` (recommended) or `-e server=... -e token=...`:

```bash
docker run --rm --env-file .env custom-action-example
```

The image default command is `datahub actions run -c my-datahub-cloud-action.yaml`. For a short smoke test:

```bash
docker run --rm --env-file .env custom-action-example timeout 20 datahub actions run -c my-datahub-cloud-action.yaml
```

If your shell does not support `timeout`, omit it and stop the container manually.

## Project layout

| Path | Purpose |
|------|---------|
| [`src/custom_action_example/custom_action.py`](src/custom_action_example/custom_action.py) | `CustomAction` implementation |
| [`my-datahub-cloud-action.yaml`](my-datahub-cloud-action.yaml) | Pipeline config (DataHub Cloud source + `sample_cloud_action`) |
| [`Dockerfile`](Dockerfile) | Container image for running the pipeline |
| [`pyproject.toml`](pyproject.toml) | Package metadata and `sample_cloud_action` entry point |
