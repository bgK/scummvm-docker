ARG DEFAULT_BASE_IMAGE
ARG DEFAULT_OS_IMAGE
FROM ${DEFAULT_OS_IMAGE} AS compiler
USER root
ARG WORKER_NAME

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		ca-certificates \
		python \
		unzip \
		wget && \
	rm -rf /var/lib/apt/lists/*

ARG SDK_VERSION=9181b082be53c64daa83f36c7093a783fd07b464
WORKDIR /tmp/compile
RUN mkdir -p /opt/steamlink/ && \
	wget --progress=bar:force:noscroll -O sdk.tar.gz \
		https://github.com/ValveSoftware/steamlink-sdk/archive/${SDK_VERSION}.tar.gz && \
	tar --strip-components=1 --directory=/opt/steamlink -xvzf sdk.tar.gz && \
	rm -rf /opt/steamlink/kernel /opt/steamlink/external && \
	rm sdk.tar.gz


# dpkg-dev is required to retrieve sources from apt
RUN sed 's/^deb \(.*\)/deb-src \1/' /etc/apt/sources.list \
		> /etc/apt/sources.list.d/debsrc.list && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		debhelper \
		dpkg-dev \
		libncurses5 \
		pkg-config

ENV PATH=$PATH:/opt/steamlink/toolchain/bin \
	CFLAGS="-isystem /opt/steamlink/rootfs/usr/include" \
	CXXFLAGS="-isystem /opt/steamlink/rootfs/usr/include"

WORKDIR /tmp/compile
COPY common/compile-libraries.sh ${WORKER_NAME}/compile-libraries-steamlink.sh ./

# Use the system version of the following libraries
# - curl
# - freetype
# - libpng
# - ogg
# - sdl2
# - sdl2_net
# - vorbis
# - zlib

COPY common/library-rules/libjpeg-turbo.sh library-rules/
RUN ./compile-libraries-steamlink.sh libjpeg-turbo

COPY common/library-rules/faad2.sh library-rules/
RUN ./compile-libraries-steamlink.sh faad2

COPY common/library-rules/libmad.sh library-rules/
RUN ./compile-libraries-steamlink.sh libmad

COPY common/library-rules/libtheora.sh library-rules/
RUN ./compile-libraries-steamlink.sh libtheora

COPY common/library-rules/flac.sh library-rules/
RUN ./compile-libraries-steamlink.sh flac

COPY common/library-rules/mpeg2dec.sh library-rules/
RUN ./compile-libraries-steamlink.sh mpeg2dec

COPY common/library-rules/a52dec.sh library-rules/
RUN ./compile-libraries-steamlink.sh a52dec

FROM ${DEFAULT_BASE_IMAGE}
USER root
COPY --from=compiler /opt/steamlink /opt/steamlink

ENV PATH=$PATH:/opt/steamlink/bin:/opt/steamlink/toolchain/bin \
	ADDR2LINE=armv7a-cros-linux-gnueabi-addr2line \
	AR=armv7a-cros-linux-gnueabi-ar \
	AS=armv7a-cros-linux-gnueabi-as \
	CXX=armv7a-cros-linux-gnueabi-c++ \
	CXXFILT=armv7a-cros-linux-gnueabi-c++filt \
	CXXFLAGS="--sysroot=/opt/steamlink/rootfs -marm -mfpu=neon -mfloat-abi=hard -DEGL_API_FB=1" \
	LDFLAGS="--sysroot=/opt/steamlink/rootfs" \
	CC=armv7a-cros-linux-gnueabi-gcc \
	CPP=armv7a-cros-linux-gnueabi-cpp \
	DWP=armv7a-cros-linux-gnueabi-dwp \
	ELFEDIT=armv7a-cros-linux-gnueabi-elfedit \
	GXX=armv7a-cros-linux-gnueabi-g++ \
	GCC=armv7a-cros-linux-gnueabi-gcc \
	GCOV=armv7a-cros-linux-gnueabi-gcov \
	GCOV_TOOL=armv7a-cros-linux-gnueabi-gcov-tool \
	GPROF=armv7a-cros-linux-gnueabi-gprof \
	LD=armv7a-cros-linux-gnueabi-ld \
	NM=armv7a-cros-linux-gnueabi-nm \
	OBJCOPY=armv7a-cros-linux-gnueabi-objcopy \
	OBJDUMP=armv7a-cros-linux-gnueabi-objdump \
	RANLIB=armv7a-cros-linux-gnueabi-ranlib \
	READELF=armv7a-cros-linux-gnueabi-readelf \
	SIZE=armv7a-cros-linux-gnueabi-size \
	STRINGS=armv7a-cros-linux-gnueabi-strings \
	STRIP=armv7a-cros-linux-gnueabi-strip

USER buildbot
WORKDIR /buildbot
