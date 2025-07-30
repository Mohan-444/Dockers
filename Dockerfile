ARG PYTHON_VERSION=3.10-slim
FROM python:${PYTHON_VERSION} as builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

LABEL maintainer="mohan" \ 
        version="1.0"
COPY app.py ./app

ENV ENVIRONMENT=production

EXPOSE 8000

VOLUME ["/app/logs"]

RUN useradd -m appuser
USER appuser

HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:8000/ || exit 1

STOPSIGNAL SIGINT

ENTRYPOINT ["uvicorn"]

CMD ["app:app", "--host", "0.0.0.0", "--port", "8000"]

ONBUILD RUN echo "App base image prepared."
