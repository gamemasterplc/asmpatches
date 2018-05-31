ren *.nds sm64.nds
ndstool -x sm64.nds -9 arm9.bin -7 arm7.bin -y9 y9.bin -y7 y7.bin -d data -y overlay -t banner.bin -h header.bin
del *.nds
blz -d .\overlay\overlay*.bin
makearm9 -x arm9.bin arm9_decompressed.bin arm9_header.bin
blz -d arm9_decompressed.bin
armips sm64ds60.asm
makearm9 -c arm9_decompressed.bin arm9_header.bin arm9.bin
blz -eo .\overlay\overlay*.bin
pushd %CD%
copy fixy9.exe .\overlay\
copy y9.bin .\overlay\
cd .\overlay
SET "i=0"
:fixy9loop
set "Value=000%i%
fixy9.exe y9.bin "overlay_%Value:~-4%.bin"
set /A i+=1
if not %i% == 103 goto fixy9loop
popd
copy .\overlay\y9.bin y9.bin
ndstool -c "Super Mario 64 DS 60FPS.nds" -9 arm9.bin -7 arm7.bin -y9 y9.bin -y7 y7.bin -d data -y overlay -t banner.bin -h header.bin
rmdir /s /q data
rmdir /s /q overlay
del *.bin
exit