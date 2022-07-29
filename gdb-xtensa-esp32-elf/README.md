# gdb-xtensa-esp32-elf

This builds the `xtensa-esp32-elf-gdb` package.

Originally this built the packages from source to enable specific python
versions (the pre-compiled versions from espressif were python2 only).

As of
https://github.com/espressif/binutils-gdb/releases/tag/esp-gdb-v11.1_20220318 ,
espressif ships pre-compiled versions for all current python3 versions,
including python3.8 (and nominally python3.10).

So this package switched to using the pre-compiled release, instead of building
from source. To build from source and provide the same convenience, we'd require
access to a private espressif repo with the multi-overlay support:

https://github.com/espressif/esp-idf/issues/9459
