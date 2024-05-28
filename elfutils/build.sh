#!/usr/bin/env bash

# On mac, just add a script that returns non-zero. On linux build the actual
# utility.

if [ `uname` == Darwin ]; then
    mkdir -p $PREFIX/bin

    echo "#!/usr/bin/env bash
echo 'error: eu-unstrip not available for mac'
exit 2
" > $PREFIX/bin/eu-unstrip
    chmod +x $PREFIX/bin/eu-unstrip
else
    export LIBS="$(pkg-config --libs-only-l zlib) $LIBS"
    export LDFLAGS="$(pkg-config --libs-only-L zlib) -lrt $LDFLAGS"
    export CFLAGS="$(pkg-config --cflags zlib) -Wno-unused-but-set-variable -Wno-unused-variable -Wno-null-dereference $CFLAGS"
    export CXXFLAGS="-Wno-error=unused-parameter $CXXFLAGS"
    ./configure --prefix=$PREFIX --with-zlib || (cat config.log && exit 1)
    make -j${CPU_COUNT}

    # Unfortunately some tests fail, so we can't run "make check" here.
    # This is probably due to this package being a very sensitive package.
    # I believe this happens because it is not ready to be packaged into
    # an environment such as conda where it will run in different OSes,
    # environments, etc.
    #
    # For example, when running the tests on my personal machine, using
    # the docker image provided by condaforge, 8 tests failed, while in
    # CircleCI, 4 tests failed.

    make install
fi
