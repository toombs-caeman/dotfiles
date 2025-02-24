#!/usr/bin/env nu

let dir = '~/Music' | expand

def main [] {
    download "https://www.youtube.com/playlist?list=PLxDIiiSm-a3At4CdKRAVc884mrKA5p4Oz" # music
    download "https://www.youtube.com/playlist?list=PLxDIiiSm-a3AtUoK-z0ggkx0N7kmqBCEc" # albums
}

def download [playlist] {
    let output = $dir | path join '%(title)s.%(ext)s'
    let archive = $dir | path join 'download-archive.txt'
    yt-dlp --yes-playlist --extract-audio --embed-metadata -f bestaudio/best --audio-format mp3 --audio-quality 0 --restrict-filenames -o $output -iw --download-archive $archive -- $playlist
}

