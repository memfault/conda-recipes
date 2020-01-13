A collection of Conda recipes used internally at Memfault but shared broadly.


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
