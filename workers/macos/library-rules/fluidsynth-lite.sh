get_dependencies ca-certificates cmake wget
wget -O - --progress=bar:force:noscroll \
	https://github.com/Doom64/fluidsynth-lite/archive/a9a3d6b9b1247d143024e092d8607de8c16fdd8a.tar.gz | tar -xzf -
cd fluidsynth-lite*/
cmake -DCMAKE_INSTALL_PREFIX=$prefix \
	-DCMAKE_SYSTEM_NAME=Darwin \
	-DBUILD_SHARED_LIBS=no .
do_make
