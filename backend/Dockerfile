FROM python:3.12-alpine

WORKDIR /app

ENV PATH=/root/.local/bin:$PATH
ENV POETRY_VERSION=1.8.2

RUN pip install --upgrade pip && pip install pipx
RUN pipx install poetry==$POETRY_VERSION
RUN poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock /app/

RUN poetry install --no-dev --no-interaction --no-ansi

COPY . /app/

EXPOSE 8000

CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]