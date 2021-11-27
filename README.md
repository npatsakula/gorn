# Gorn - Multithreaded File Hash Calculator

## Usage

You can calculate hash from single file:

```sh
gorn --path src/main.rs
```

Or you can calculate it for directory:

```sh
gorn --path ./target
```

If you want to inspect hashes for all files in
directory you can use `--print_tree` flag:

```sh
gorn --path ./target --print_tree
```

## Install

### From crates.io

1. Get rust build tools from [rustup](rustup.rs).
2. Install via:

```sh
cargo install gorn
```

### From Source

1. Get rust build tools from [rustup](rustup.rs).
2. Install from sources:
```sh
cd gorn; cargo install --path .
```

### Using NIX

1. Add `nix-command` and `flakes` support (optional):

```sh
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

2. Build and install:

```sh
nix build; nix shell
```

3. Run:

```sh
gorn --path src
```