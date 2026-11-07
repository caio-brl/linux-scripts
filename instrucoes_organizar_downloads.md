# 🚀 Automação Nativa de Organização da Pasta Downloads no Debian/Linux

Este guia detalha o passo a passo completo para criar um script de organização de arquivos por tipo e configurá-lo no `systemd` como um serviço de usuário. Dessa forma, a pasta `Downloads` será organizada automaticamente em tempo real, inclusive após o reinício do sistema.

---

## Passo 1: Criar o Script de Organização

1. Abra o terminal e crie o arquivo do script utilizando o editor `nano`:

```bash
nano ~/organizar_downloads.sh
```

2. Cole o seguinte código Shell Script dentro do arquivo:

```bash
#!/bin/bash

# Diretório a ser organizado
DOWNLOADS_DIR="$HOME/Downloads"
cd "$DOWNLOADS_DIR" || exit 0

# Habilita insensibilidade a maiúsculas/minúsculas nas extensões
shopt -s nocaseglob

for arquivo in *; do
    # Ignora arquivos temporários de download em andamento e pastas
    if [[ "$arquivo" =~ \.(crdownload|part|tmp)$ ]]; then
        continue
    fi

    if [ -f "$arquivo" ]; then
        case "$arquivo" in
            *.jpg|*.jpeg|*.png|*.gif|*.webp|*.svg|*.bmp)
                mkdir -p "Imagens" && mv "$arquivo" "Imagens/" ;;
            *.pdf|*.docx|*.doc|*.txt|*.xlsx|*.csv|*.pptx|*.odt)
                mkdir -p "Documentos" && mv "$arquivo" "Documentos/" ;;
            *.mp4|*.mkv|*.avi|*.mov|*.webm|*.flv)
                mkdir -p "Videos" && mv "$arquivo" "Videos/" ;;
            *.mp3|*.wav|*.flac|*.m4a|*.ogg)
                mkdir -p "Musicas" && mv "$arquivo" "Musicas/" ;;
            *.zip|*.tar.gz|*.rar|*.7z|*.gz)
                mkdir -p "Compactados" && mv "$arquivo" "Compactados/" ;;
            *.deb|*.exe|*.AppImage|*.sh|*.msi)
                mkdir -p "Programas" && mv "$arquivo" "Programas/" ;;
        esac
    fi
done

shopt -u nocaseglob
```

3. Para salvar o arquivo no `nano`:
   - Pressione **`Ctrl + O`**, em seguida **`Enter`**.
   - Para sair, pressione **`Ctrl + X`**.

---

## Passo 2: Tornar o Script Executável

Dê permissão de execução ao arquivo recém-criado:

```bash
chmod +x ~/organizar_downloads.sh
```

*(Opcional)* Teste a execução manual para garantir que não há erros de sintaxe:

```bash
~/organizar_downloads.sh
```

---

## Passo 3: Configurar a Automação no Systemd

O `systemd.path` funciona através de um par de arquivos: o `.path` (que monitora o diretório) e o `.service` (que executa a ação).

### 1. Criar o diretório de serviços do usuário

```bash
mkdir -p ~/.config/systemd/user
```

### 2. Criar o arquivo de Serviço (`.service`)

Execute o comando para abrir o arquivo:

```bash
nano ~/.config/systemd/user/organizar-downloads.service
```

Cole o conteúdo abaixo:

```ini
[Unit]
Description=Servico de organizacao da pasta Downloads

[Service]
Type=oneshot
ExecStart=%h/organizar_downloads.sh
```

Salve e feche (`Ctrl + O`, `Enter`, `Ctrl + X`).

### 3. Criar o arquivo de Monitoramento (`.path`)

Execute o comando para criar a unidade de monitoramento:

```bash
nano ~/.config/systemd/user/organizar-downloads.path
```

Cole o conteúdo abaixo:

```ini
[Unit]
Description=Monitora a pasta Downloads para organizacao automatica

[Path]
PathChanged=%h/Downloads
Unit=organizar-downloads.service

[Install]
WantedBy=default.target
```

Salve e feche (`Ctrl + O`, `Enter`, `Ctrl + X`).

---

## Passo 4: Ativar e Iniciar o Serviço Automático

1. Recarregue as configurações do `systemd` de usuário para reconhecer as novas unidades:

```bash
systemctl --user daemon-reload
```

2. Habilite e inicie o monitoramento `.path`:

```bash
systemctl --user enable --now organizar-downloads.path
```

3. Verifique se o monitoramento está rodando corretamente:

```bash
systemctl --user status organizar-downloads.path
```

> **Saída esperada:** O status deve indicar `Active: active (waiting)`.

---

## Passo 5: Persistência após o Reboot

Para garantir que o serviço de usuário continue rodando no boot do computador sem depender do login manual via interface gráfica (útil para servidores ou inicialização limpa):

```bash
sudo loginctl enable-linger $USER
```

---

## 🧪 Como Testar

Baixe ou crie qualquer arquivo na pasta `~/Downloads` (exemplo: `touch ~/Downloads/documento_teste.pdf`). 

O `systemd.path` detectará a alteração e executará o script instantaneamente, movendo o arquivo para `~/Downloads/Documentos/`.