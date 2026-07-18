# Atlas Platform CLI

> Uma CLI local para acelerar o setup de infraestrutura de desenvolvimento.
>
> Inspirado na experiência de plataforma de serviços (como o Fury do Mercado Livre), começando por um primeiro módulo focado em serviços Docker.

## Visão

O Atlas nasce para reduzir o atrito no desenvolvimento local: escolher os serviços que você precisa e subir tudo com um único fluxo.

Hoje, o foco é **infraestrutura base** para aplicações:
- bancos de dados
- cache
- filas/mensageria

## Estado atual (MVP)

No momento, o comando disponível é:

```bash
atlas services configure
```

Esse comando:
1. Lista os serviços disponíveis com versão.
2. Permite seleção interativa.
3. Sobe os containers escolhidos com Docker Compose.

## Serviços disponíveis

| Categoria | Serviço | Versão | Imagem |
|---|---|---|---|
| Database | PostgreSQL | `16-alpine` | `postgres:16-alpine` |
| Database | MySQL | `8.4` | `mysql:8.4` |
| Database | Oracle XE | `21-slim` | `gvenzl/oracle-xe:21-slim` |
| Cache | Redis | `7-alpine` | `redis:7-alpine` |
| Queue | RabbitMQ | `3-management` | `rabbitmq:3-management` |
| Queue | Kafka | `3.8` | `bitnami/kafka:3.8` |
| Queue | Kafka Connect | `3.8` | `bitnami/kafka-connect:3.8` |
| Queue | AKHQ | `0.24.0` | `tchiotludo/akhq:0.24.0` |

## Instalação

```bash
make install
```

Destino do binário:
- **Windows:** `%USERPROFILE%\atlas-bin`
- **Linux/macOS:** `/usr/local/bin`

O catálogo Docker é instalado em:
- **Windows:** `%USERPROFILE%\.atlas\services\docker\docker-compose.yml`
- **Linux/macOS:** `~/.atlas/services/docker/docker-compose.yml`

## Exemplo de uso

```bash
atlas
atlas services
atlas services configure
```

## Próximos passos

- Catálogo de serviços versionável por perfil/projeto.
- Configuração persistida por aplicação.
- Workflows de bootstrap para novos sistemas.
- Evolução para experiência de plataforma local completa.
