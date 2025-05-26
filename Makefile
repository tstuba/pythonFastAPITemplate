help:
	@echo "Available commands:"
	@echo "  build                      - Build the Docker container"
	@echo "  build-no-cache             - Build the Docker container without cache"
	@echo "  start                      - Start the Docker containers"
	@echo "  stop-backend               - Stop the backend container"
	@echo "  start-dev-backend          - Start the database, and backend in development mode"
	@echo "  stop                       - Stop the Docker containers"
	@echo "  help                       - Show this help message"
	@echo "  migration                  - Create a new Alembic migration with a message (message=\"Your message\")"
	@echo "  migrate                    - Run Alembic migrations in the backend container"
	@echo "  downgrade                  - Downgrade to a specific Alembic migration (revision=\"specific revision\" or revision=\"head-1\" to downgrade one step or more)"


build:
	@echo "Building Docker container..."
	docker compose build

build-no-cache:
	@echo "Building Docker container without ache..."
	docker compose build --no-cache

start:
	@echo "Starting Docker container..."
	docker compose up

stop-backend:
	@echo "Stopping Backend container..."
	docker compose stop backend

start-dev-backend:
	@echo "Starting Database..."
	docker compose up -d db
	@echo "Runing Backend in development mode..."
	docker compose run --rm --service-ports backend uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

stop:
	@echo "Stopping Docker containers..."
	docker compose stop

migration:
	@echo "Creating new migration..."
	docker compose exec backend alembic revision --autogenerate -m "$(message)"
	@echo "Migration created successfully."

migrate:
	@echo "Running Alembic migrations..."
	docker compose exec backend alembic upgrade head

downgrade:
	@echo "Running Alembic downgrade..."
	docker compose exec backend alembic downgrade $(revision)
	@echo "Downgrade completed."