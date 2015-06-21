We're using a (very slightly) modified WMA Pro decoder to handle XMA packets.
The diff used is included.

## Updating

### Windows

1. Install [MSYS2 x64](https://msys2.github.io/)
1. pacman -Sy
1. pacman -S patch yasm
1. mv /usr/bin/link /usr/bin/link-bak
1. Launch msys shell
1. "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\amd64\vcvars64.bat"
1. 'which links.exe' must return the x64 linker
1. ./build.sh

## Credits

Original XMA patch: https://github.com/koolkdev/libertyv/tree/master/ffmpeg

Original build/implementation: @DrChat
