# cmake.memfault

This is a copy-paste of the recipe from here:

https://github.com/conda-forge/cmake-feedstock/tree/284e91676110b5d52130bd6fb04e91f099194fcf/recipe

The conda-forge versions of `cmake` (https://anaconda.org/conda-forge/cmake/)
specify a more recent `expat` dependency than what we used in some of our
in-house packages:

```bash
❯ rg 'expat:\s+- 2\.2' --multiline
gdb-xtensa-esp32-elf/conda_build_config.yaml
367:expat:
368:  - 2.2

gdb-multi-arch/conda_build_config.yaml
367:expat:
368:  - 2.2

gdb-arm-elf-linux/conda_build_config.yaml
20:expat:
21:  - 2.2

redis/conda_build_config.yaml
367:expat:
368:  - 2.2

gdb-xtensa-lx106-elf/conda_build_config.yaml
367:expat:
368:  - 2.2

cpputest/conda_build_config.yaml
367:expat:
368:  - 2.2
```

Those were using a particular version of the pinning file from here:

https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/master/recipe/conda_build_config.yaml

Which over-specified expat to `'2.2'` at the time. Now (as of 2022-03-08) it's
been updated to `'2'`, which would be OK if the `max_pin` setting was set to `x`
for expat, but it's not specified, and ends up over-constrained to the max
`'2'`-compatible version at the time (`2.4.6` right now, up to 3).

This causes incompatible packages between our in-house built ones and the
conda-forge `cmake` versions, starting around `cmake=3.20` or so.

This folder forks the recipe and sets the `expat` dep to `2.2` so it's
compatible with our other packages, rather than correcting those packages.
