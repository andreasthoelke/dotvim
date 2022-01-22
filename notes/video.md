

The html interface:
https://developer.mozilla.org/en-US/docs/Web/API/HTMLVideoElement
The corresponding html element:
https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video

Some background docs:
https://web.dev/webcodecs/



Video cutter:
https://github.com/mifi/lossless-cut
https://mifi.github.io/lossless-cut/



#t=15.5,20.4


https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8#t=15.5,20.4


Download options (should I preserve (a lower resolution) mpeg dash format?
Will this allow precise seeking? And end of timeslice.

https://github.com/ytdl-org/youtube-dl#options


Text subtitles:
https://www.w3.org/TR/webvtt1/

https://developer.mozilla.org/en-US/docs/Web/API/WebVTT_API

<video controls src="https://s3.eu-central-1.amazonaws.com/pipe.public.content/short.mp4#t=15,20" preload="metadata"> </video>

https://developer.mozilla.org/en-US/docs/Web/HTML/Element/video

https://web.dev/media/

https://github.com/Dash-Industry-Forum/dash.js

Events:
http://reference.dashif.org/dash.js/latest/samples/getting-started/listening-to-events.html

http://reference.dashif.org/dash.js/latest/samples/

Thumbnails!
http://reference.dashif.org/dash.js/latest/samples/thumbnails/thumbnails.html




# MPV / VLC Media player


mpv --help
vlc --help
mpv myvideo.mp4

mpv W86cTIoMv2U.mp4

### System player / quicktime
use 'glb' on this path to open it in quicktime player
file:///Users/at/Documents/Temp/YT-dls/W86cTIoMv2U.mp4
file:////Users/at/Documents/Temp/YT-dls/mw2g_bismark.mp4

### Time ranges
https://s3.eu-central-1.amazonaws.com/pipe.public.content/short.mp4#t=15.5,20.4
file:///Users/at/Documents/Temp/YT-dls/mw2g_bismark.mp4#t=15.3,20.3

## Scripts
~/.config/mpv/
~/.config/mpv/mpv.conf

git clone https://github.com/zxhzxhz/mpv-chapters  ~/.config/mpv/mpv-chapters

## Chapers


# ytdl

next:
- edit divish buffer to execute shell commands with path
- ytdl write info json
- view json in vscode - not blocking vim

Test paths: /Users/at/Documents/tests/YT-dls/myvideo.mp4
            /Users/at/Documents/tests/YT-dls/test.json

/Users/at/Documents/
/Users/at/Documents/Temp/YT-dls/W86cTIoMv2U.mp4


ls
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" | mpv -
ytdl W86cTIoMv2U | mpv -

ytdl mb59CQQvxd4 | mpv -
ytdl mb59CQQvxd4 > mw2g_bismark.mp4
mpv mw2g_bismark.mp4
mpv mw2g_bismark.mp4 --script=~/.config/mpv/scripts/mpv_chapters.js

ytdl W86cTIoMv2U | vlc -
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" | vlc -
ytdl "http://www.youtube.com/watch?v=_HSylqgVYQI" > myvideo.mp4

ytdl W86cTIoMv2U --info
ytdl W86cTIoMv2U --info-json

ytdl mb59CQQvxd4 --info-json > mw2g_bismark-info.json

ls
mpv help
mpv -h
vlc myvideo.mp4

youtube-dl W86cTIoMv2U --skip-download --write-sub
youtube-dl W86cTIoMv2U -s --write-sub

mpv W86cTIoMv2U.mp4
mpv World\'s\ smallest\ cat\ ð¿°¨-\ BBC-W86cTIoMv2U.mp4

mpv mpv-shot0001.jpg

youtube-dl W86cTIoMv2U -e --get-title
youtube-dl W86cTIoMv2U -e --write-sub
youtube-dl W86cTIoMv2U --list-subs
youtube-dl W86cTIoMv2U -e --get-title --get-description
youtube-dl W86cTIoMv2U -e --get-description --get-thumbnail
youtube-dl W86cTIoMv2U -e --get-thumbnail
youtube-dl W86cTIoMv2U --get-format
-j --dump-json
-j
youtube-dl W86cTIoMv2U -j
youtube-dl W86cTIoMv2U -j > W86cTIoMv2U_infos.json

## Thumbnails
https://i.ytimg.com/sb/mb59CQQvxd4/storyboard3_L0/default.jpg?sqp=-oaymwENSDfyq4qpAwVwAcABBqLzl_8DBgiZ9duOBg%3D%3D&sigh=rs%24AOn4CLCpl6q6hCwUJ1i-otAjGXJ3P8VY6A

## Subtitle
--convert-subs FORMAT
Convert the subtitles to other format (currently supported: srt|ass|vtt|lrc)

youtube-dl W86cTIoMv2U --skip-download --write-sub --sub-lang en-GB

youtube-dl y3mazk5j8Sg --skip-download --write-sub
youtube-dl 6OMzvvJHYxU --skip-download --write-sub
youtube-dl wkPR4Rcf4ww --skip-download --write-sub
youtube-dl z-IR48Mb3W0 --skip-download --write-sub
youtube-dl GU87SH5e0eI --skip-download --write-sub









