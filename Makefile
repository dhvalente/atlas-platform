.PHONY: install

# Detecta o sistema operacional automaticamente
ifeq ($(OS),Windows_NT)
SHELL := cmd.exe
.SHELLFLAGS := /C
SCRIPT = chcp 65001 >NUL && powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
else
SCRIPT = chmod +x ./install.sh && ./install.sh
endif

install:
	@echo "Starting Atlas CLI installation..."
	@$(SCRIPT)