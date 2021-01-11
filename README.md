A collection of Conda recipes used internally at Memfault but shared broadly.

The packages can be found on the [Anaconda Package Repository](https://anaconda.org/Memfault/repo)

## Using

To use any of thesee packages in your own Conda environments, just add `memfault` to the top of the `environment.yml` in your project:

```yaml
channels:
  - memfault
  - conda-forge
  - nodefaults
```

Since all of these packages are built using Conda Forge's package pinnings (https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/master/recipe/conda_build_config.yaml), using Conda Forge as the base is heavily suggested.

## Building

To build any of the following packages (macOS and Linux Ubuntu 18.04 tested):

```
# Create build environment
$ conda create -n build
$ conda activate build
$ conda install conda-build anaconda-client

# Build specific recipe
$ cd <some_recipe_dir>
$ conda build -c conda-forge .

# Successful build prints an upload command
$ anaconda upload ...
```

### Docker for Linux

So you don't want to build on your native machine? That's fine! 

```
$ docker run -ti -v <path_to_conda-recipes>:/conda-recipes condaforge/miniforge3  /bin/bash
$ conda create -n build conda-build anaconda-client
$ conda activate build
$ cd /conda-recipes/<recipe>
$ conda build -c conda-forge .

# Successful build prints an upload command
$ anaconda upload ...
```
