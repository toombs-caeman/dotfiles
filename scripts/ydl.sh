m=~/Music
dl() {
    yt-dlp --yes-playlist --extract-audio \
        -f bestaudio/best --audio-format mp3 --audio-quality 0 \
        --restrict-filenames -o "$m/%(title)s.%(ext)s" \
        -iw --download-archive "$m/download-archive.txt" \
        -- "$@"
}

dl "https://www.youtube.com/playlist?list=PLxDIiiSm-a3At4CdKRAVc884mrKA5p4Oz" # music
dl "https://www.youtube.com/playlist?list=PLxDIiiSm-a3AtUoK-z0ggkx0N7kmqBCEc" # albums
mp3gain $m/*.mp3
