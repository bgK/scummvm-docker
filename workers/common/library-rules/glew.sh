do_fetch
if [ "$host" == "i686-w64-mingw32" ]; then
	sed -i 's/i586-mingw32msvc/i686-w64-mingw32/' config/Makefile.linux-mingw32
	SYSTEM="linux-mingw32" GLEW_DEST="/usr/i686-w64-mingw32" do_make
elif [ "$host" == "x86_64-w64-mingw32" ]; then
	SYSTEM="linux-mingw64" GLEW_DEST="/usr/x86_64-w64-mingw32" do_make
else
	do_make
fi
