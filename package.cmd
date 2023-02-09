del foxfire.love
7z a -tzip foxfire.love @files.txt

del foxfire.exe
copy /b love.exe+foxfire.love foxfire.exe

del foxfire.zip
7z a -tzip foxfire.zip ./dlls/* foxfire.exe

rmdir /s /q output
7z x foxfire.zip -ooutput
