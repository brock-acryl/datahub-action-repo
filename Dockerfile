FROM python:3.12-slim-bookworm

WORKDIR /app

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

COPY pyproject.toml .
COPY src ./src
RUN pip install --upgrade pip setuptools wheel \
    && pip install .

COPY my-datahub-cloud-action.yaml .

# Required at runtime: server and token (DataHub config ${server} / ${token})
# Example:
#   docker run --rm -e server="https://your-org.acryl.io/gms" -e token="..." custom-action-example

CMD ["datahub", "actions", "run", "-c", "my-datahub-cloud-action.yaml"]
