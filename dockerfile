# ---- Stage 1: builder (install deps) ----
FROM python:3.12-slim AS builder

WORKDIR /app

# Install dependencies into a dedicated folder so we can copy them cleanly
COPY requirements.txt .
RUN pip install --no-cache-dir --target /install -r requirements.txt

# Copy your source
COPY app.py .


# ---- Stage 2: final (runtime image) ----
FROM python:3.12-slim

WORKDIR /app

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local/lib/python3.12/site-packages

# Copy your app
COPY --from=builder /app/app.py ./app.py

CMD ["python", "app.py"]