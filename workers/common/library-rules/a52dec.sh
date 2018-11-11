get_dependencies automake libtool
do_fetch

do_configure
do_make -C liba52
do_make -C include
