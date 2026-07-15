#!/bin/bash
set -e

EXE_NAME="atlas"
ATLAS_SERVICES_DIR="$HOME/.atlas/services/docker"

echo "🔨 Compilando o projeto Atlas..."
go build -o $EXE_NAME

echo "🚚 Movendo executável para /usr/local/bin (pode pedir senha de sudo)..."
sudo mv ./$EXE_NAME /usr/local/bin/$EXE_NAME

echo "✅ Permissões de execução aplicadas."
sudo chmod +x /usr/local/bin/$EXE_NAME

echo "🧩 Instalando catálogo de serviços Docker em $ATLAS_SERVICES_DIR..."
mkdir -p "$ATLAS_SERVICES_DIR"
cp ./services/docker/docker-compose.yml "$ATLAS_SERVICES_DIR/docker-compose.yml"

echo "🎉 Instalação concluída! Você já pode usar o comando 'atlas' no terminal."