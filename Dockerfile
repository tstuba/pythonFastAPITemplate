FROM python:3.13-alpine

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV UV_PROJECT_ENVIRONMENT=/usr/local/

# Change the workdir directory to the 'app' directory 
WORKDIR /app
ARG UV_SYNC_ARGS=--no-dev

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \ 
    uv sync --locked --no-install-project $UV_SYNC_ARGS

# Copy the project into the image
ADD . /app

# Sync the project
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked $UV_SYNC_ARGS

# Run server
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

# ENV PATH=/root/.local/bin:$PATH
# ENV POETRY_VERSION=1.8.2

# RUN pip install --upgrade pip && pip install pipx
# RUN pipx install poetry==$POETRY_VERSION
# RUN poetry config virtualenvs.create false

# COPY pyproject.toml poetry.lock /app/

# RUN poetry install --no-dev --no-interaction --no-ansi

# COPY . /app/

# EXPOSE 8000

# CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]