#!/bin/bash
set -euo pipefail

BIN_DIR="$HOME/atlas-bin"
ATLAS_SERVICES_DIR="$HOME/.atlas/services/docker"
EXE_NAME="atlas"

echo "Starting Atlas project..."
cat <<'EOF'
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⢀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣾⠟⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡷⠛⠛⠛⠛⢀⠀⠠⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⢢⣶⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣶⣤⣤⠀⠀⠀⢈⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⡇⠀⠀⣸⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣶⣶⡿⠟⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠛⠛⢉⣉⠁⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡆⢈⣉⣁⣰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠈⠉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣯⣤⣤⣤⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡙⠛⠛⠛⢹⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡶⣤⣤⣽⣿⡆⠀⣼⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠐⠊⠀⠀⠉⠙⠛⠃⠐⠛⠛⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
EOF

go build -o "$EXE_NAME"

if [ ! -d "$BIN_DIR" ]; then
    echo "Creating directory $BIN_DIR..."
    mkdir -p "$BIN_DIR"
fi

echo "Moving executable to $BIN_DIR..."
mv -f "./$EXE_NAME" "$BIN_DIR/$EXE_NAME"
chmod +x "$BIN_DIR/$EXE_NAME"

echo "Installing Docker services catalog at $ATLAS_SERVICES_DIR..."
mkdir -p "$ATLAS_SERVICES_DIR"
cp "./services/docker/docker-compose.yml" "$ATLAS_SERVICES_DIR/docker-compose.yml"

SHELL_NAME="$(basename "${SHELL:-bash}")"
if [ "$SHELL_NAME" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
else
    RC_FILE="$HOME/.bashrc"
fi

PATH_EXPORT_LINE="export PATH=\"\$PATH:$BIN_DIR\""
if [ -f "$RC_FILE" ] && grep -Fq "$BIN_DIR" "$RC_FILE"; then
    echo "Directory is already in PATH."
else
    echo "Adding $BIN_DIR to user PATH..."
    touch "$RC_FILE"
    printf '\n%s\n' "$PATH_EXPORT_LINE" >> "$RC_FILE"
    echo "PATH updated. Open a NEW terminal to use atlas."
fi

echo "Install complete. Open a NEW terminal and run: atlas services configure"