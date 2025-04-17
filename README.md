# Dotfiles

This config based on usage of the 'ln' to link config files to the needed places.

## How to clone

```sh
git clone -b link https://github.com/MrRTi/dotfiles.git
cd dotfiles
```

```sh
git clone -b link git@github.com:MrRTi/dotfiles.git
cd dotfiles
```

## Required

- [brew](https://brew.sh/)

## Brew

### Requirements

- [brew](https://brew.sh/)

### Usage

#### Install brew (use command from original site)

```sh
./brew.sh -i
```

#### Install all packages listed in Brewfile (restore)

```sh
./brew.sh -r
```

#### Save list of installed packages in Brewfile

```sh
./brew.sh -d
```

#### Help

To see all possible options

```sh
./brew.sh -h
```
## Link

### Usage

#### Link

For specific package

```sh
./link.sh -a -p nvim
```

For all configs

```sh
./link.sh -a
```

#### Unlink

For specific package

```sh
./link.sh -d -p nvim
```

For all configs

```sh
./link.sh -d
```

#### Help

To see all possible options

```sh
./link.sh -h
```


