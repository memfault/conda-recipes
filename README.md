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

## Building Locally

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
$ apt update && apt install build-essential
$ conda create -n build conda-build anaconda-client python=3.8
$ conda activate build
$ cd /conda-recipes/<recipe>
$ conda build -c conda-forge .

# Successful build prints an upload command
$ anaconda upload ...
```

### Building on macOS

We follow [Conda Build's (and Conda Forge's) strategy](https://docs.conda.io/projects/conda-build/en/latest/resources/compiler-tools.html#macos-sdk) for building macOS packages.

As noted in the `conda_build_config.yaml` of each recipe, we use the MacOS 10.9 SDK.

```
CONDA_BUILD_SYSROOT:
  - /opt/MacOSX10.9.sdk        # [osx]
```

To download and install this SDK, you can find the package here: https://github.com/phracker/MacOSX-SDKs/releases

```
$ sudo mv <10.9 SDK> /opt/MacOSX10.9.sdk
```

## Building via GitHub Action

Not heavily tested, but it's possible to build packages from github actions, see
[`.github/workflows/build.yml`](.github/workflows/build.yml).

To trigger it, set the appropriate `PACKAGE_DIR` when making a pull request.

Note that this may not work if the above `CONDA_BUILD_SYSROOT` is set; you'll
have to add a step to install the appropriate tools into that location if you
want to go that route.

From the Github UI, you can [trigger the build by going here](https://github.com/memfault/conda-recipes/actions/workflows/build.yml), then:

- Click "Run Workflow".
- Enter the package directory in the designated input field.
- Hit "Run".

Once the Github action has built the packages, they still need to be uploaded to
anaconda.org manually. Go to the [detail page of your workflow run](https://github.com/memfault/conda-recipes/actions)
and download the "packages" artifact.

Unzip the packages.zip and then run:

```shell
PACKAGE=<package_name> anaconda upload **/$PACKAGE*.tar.bz2 --user memfault
```

> Note: [Github actions cannot be run on Apple ARM VMs](https://github.com/actions/virtual-environments/issues/2187)
> so building the package for darwin-aarch64 still needs to be done "manually"...
