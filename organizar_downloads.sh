#!/bin/bash

DOWNLOADS_DIR="$HOME/Downloads"
cd "$DOWNLOADS_DIR" || exit 0

shopt -s nocaseglob

for arquivo in *; do
    # Ignora arquivos em download (.crdownload, .part, .tmp) e pastas
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
