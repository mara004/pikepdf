#!/bin/bash
set -ex

if [ ! -f /usr/local/lib/libz.a ]; then
    pushd zlib
    patch --ignore-whitespace --unified << 'EOF'
--- zlib-1.2.11/configure	2016-12-31 10:06:40.000000000 -0800
+++ zlib/configure	2021-05-31 01:13:39.000000000 -0700
@@ -186,6 +186,7 @@
   SFLAGS="${CFLAGS--O3} -fPIC"
   if test "$ARCHS"; then
     CFLAGS="${CFLAGS} ${ARCHS}"
+    SFLAGS="${SFLAGS} ${ARCHS}"
     LDFLAGS="${LDFLAGS} ${ARCHS}"
   fi
   if test $build64 -eq 1; then
EOF
    ./configure --archs="-arch x86_64 -arch arm64" && make -j install
    popd
fi

if [ ! -f  /usr/local/lib/libjpeg.a ]; then
    pushd jpeg
    ./configure CFLAGS="-arch x86_64 -arch arm64" LDFLAGS="-arch x86_64 -arch arm64"
    make -j install
    popd
fi

if [ ! -f /usr/local/lib/libqpdf.a ]; then
    pushd qpdf
    ./configure CFLAGS="-arch x86_64 -arch arm64" LDFLAGS="-arch x86_64 -arch arm64" --disable-oss-fuzz && make -j install
    find /usr/local/lib -name 'libqpdf.so*' -type f -exec strip --strip-debug {} \+
    popd
fi
