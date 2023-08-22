A collection of Conda recipes used internally at Memfault but shared broadly.

The packages can be found on the [Anaconda Package Repository](https://anaconda.org/Memfault/repo)

## Using

To use any of these packages in your own Conda environments, just add `memfault` to the top of the `environment.yml` in your project:

```yaml
channels:
  - memfault
  - conda-forge
  - nodefaults
```

Since all of these packages are built using Conda Forge's package pinnings (https://github.com/conda-forge/conda-forge-pinning-feedstock/blob/master/recipe/conda_build_config.yaml), using Conda Forge as the base is heavily suggested.

## Building Locally

To build any of the following packages (macOS and Linux Ubuntu 18.04 tested):

```bash
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

You can optionally install + use the `mambabuild` build command, see here:

https://boa-build.readthedocs.io/en/latest/mambabuild.html

It can significantly speed up package dependency resolution during the build.

### Docker for Linux

So you don't want to build on your native machine? That's fine!

```bash
$ docker run -ti -v $(pwd):/conda-recipes condaforge/miniforge3  /bin/bash
# force an architecture, e.g. building linux amd64 on macOS Apple Silicon
$ docker run --platform=linux/amd64 -ti -v $(pwd):/conda-recipes condaforge/miniforge3  /bin/bash

$ apt update && apt install -y build-essential
$ conda create -n build conda-build anaconda-client
$ conda activate build
$ cd /conda-recipes/<recipe>
$ conda build -c conda-forge .

# Successful build prints an upload command
$ anaconda upload ...
```

### Building on macOS

We follow [Conda Build's (and Conda Forge's) strategy](https://docs.conda.io/projects/conda-build/en/latest/resources/compiler-tools.html#macos-sdk) for building macOS packages.

As noted in the `conda_build_config.yaml` of each recipe, we use the MacOS 10.9 SDK.

```yaml
CONDA_BUILD_SYSROOT:
  - /opt/MacOSX10.9.sdk # [osx]
```

To download and install this SDK, you can find the package here: https://github.com/phracker/MacOSX-SDKs/releases

```bash
$ sudo mv <10.9 SDK> /opt/MacOSX10.9.sdk
```

#### Apple Silicon

If you're on Apple Silicon, you can build for both ARM64 and X86_64 via Rosetta. The default environment is `osx-arm64`, but you can explicitly create them with `CONDA_SUBDIR`:

```sh
# create an Apple Silicon environment
CONDA_SUBDIR=osx-arm64 conda create -n build-silicon conda-build anaconda-client
conda activate build-silicon
conda config --env --set subdir osx-arm64

# create a Rosetta environment
CONDA_SUBDIR=osx-64 conda create -n build-rosetta conda-build anaconda-client
conda activate build-rosetta
conda config --env --set subdir osx-64
```

Then follow the *Building Locally* instructions at the top.

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

## Uploading Packages

It's nice to convert packages to the new `.conda` archive format, see here for
details:

https://docs.anaconda.com/free/anacondaorg/user-guide/tasks/work-with-packages/#conda-compression-format

Only the `.conda` package needs to be uploaded (conda clients 4.7 (2019-05-17)
and later support the `.conda` package format).

## Useful Resources

- Creating patch files for fixing builds: https://www.anaconda.com/blog/patching-source-code-to-conda-build-recipes
