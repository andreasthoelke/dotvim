
## MPV / VLC Media player
mpv --help
vlc --help


## ytdl

next:
- edit divish buffer to execute shell commands with path
- ytdl write info json
- view json in vscode - not blocking vim


Test paths: /Users/at/Documents/tests/YT-dls/myvideo.mp4
            /Users/at/Documents/tests/YT-dls/test.json


ls
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" | mpv -
ytdl "W86cTIoMv2U" | mpv -
ytdl W86cTIoMv2U | mpv -
ytdl W86cTIoMv2U | vlc -
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" | vlc -
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" > myvideo.mp4

ytdl W86cTIoMv2U --info
ytdl W86cTIoMv2U --info-json

ls
mpv myvideo.mp4
mpv help
mpv -h
vlc myvideo.mp4

youtube-dl W86cTIoMv2U --skip-download --write-sub
youtube-dl W86cTIoMv2U -s --write-sub

mpv World\'s\ smallest\ cat\ ð¿°¨-\ BBC-W86cTIoMv2U.mp4

youtube-dl W86cTIoMv2U -e --get-title
youtube-dl W86cTIoMv2U -e --get-title --get-description
youtube-dl W86cTIoMv2U -e -get-description
youtube-dl W86cTIoMv2U -e --get-description
youtube-dl W86cTIoMv2U -e --get-thummbnail
youtube-dl W86cTIoMv2U -e --get-thumbnail
youtube-dl W86cTIoMv2U --get-format
-j --dump-json
-j
youtube-dl W86cTIoMv2U -j
youtube-dl W86cTIoMv2U -j > test.json


