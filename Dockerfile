FROM registry.astralinux.ru/astra/ubi18:1.8.1uu2-mg15.2.0

ENV DEBIAN_FRONTEND=noninteractive
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=true

RUN apt-get update && apt-get install -y \
    ca-certificates \
    libicu72 \
    && rm -rf /var/lib/apt/lists/*

ARG PROJECT_NAME
ENV PROJECT_NAME=${PROJECT_NAME}

WORKDIR /app

COPY ./publish/${PROJECT_NAME}/. .

CMD ["sh", "-c", "./${PROJECT_NAME}"]
