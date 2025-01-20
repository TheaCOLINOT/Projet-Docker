FROM minio/minio:latest

ENV MINIO_ROOT_USER=admin \
    MINIO_ROOT_PASSWORD=password

CMD ["server", "/data", "--console-address", ":9003"]