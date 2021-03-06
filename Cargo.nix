# This file was @generated by cargo2nix 0.10.0.
# It is not intended to be manually edited.

args@{
  release ? true,
  rootFeatures ? [
    "gorn/default"
  ],
  rustPackages,
  buildRustPackages,
  hostPlatform,
  hostPlatformCpu ? null,
  hostPlatformFeatures ? [],
  codegenOpts ? null,
  profileOpts ? null,
  mkRustCrate,
  rustLib,
  lib,
  workspaceSrc,
}:
let
  workspaceSrc = if args.workspaceSrc == null then ./. else args.workspaceSrc;
in let
  inherit (rustLib) fetchCratesIo fetchCrateLocal fetchCrateGit fetchCrateAlternativeRegistry expandFeatures decideProfile genDrvsByProfile;
  profilesByName = {
    release = builtins.fromTOML "lto = \"thin\"\n";
  };
  rootFeatures' = expandFeatures rootFeatures;
  overridableMkRustCrate = f:
    let
      drvs = genDrvsByProfile profilesByName ({ profile, profileName }: mkRustCrate ({ inherit release profile hostPlatformCpu hostPlatformFeatures profileOpts codegenOpts; } // (f profileName)));
    in { compileMode ? null, profileName ? decideProfile compileMode release }:
      let drv = drvs.${profileName}; in if compileMode == null then drv else drv.override { inherit compileMode; };
in
{
  cargo2nixVersion = "0.10.0";
  workspace = {
    gorn = rustPackages.unknown.gorn."0.1.0";
  };
  "registry+https://github.com/rust-lang/crates.io-index".atty."0.2.14" = overridableMkRustCrate (profileName: rec {
    name = "atty";
    version = "0.2.14";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d9b39be18770d11421cdb1b9947a45dd3f37e93092cbf377614828a319d5fee8"; };
    dependencies = {
      ${ if hostPlatform.parsed.kernel.name == "hermit" then "hermit_abi" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".hermit-abi."0.1.19" { inherit profileName; };
      ${ if hostPlatform.isUnix then "libc" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.108" { inherit profileName; };
      ${ if hostPlatform.isWindows then "winapi" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi."0.3.9" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".autocfg."1.0.1" = overridableMkRustCrate (profileName: rec {
    name = "autocfg";
    version = "1.0.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "cdb031dd78e28731d87d56cc8ffef4a8f36ca26c38fe2de700543e627f8a464a"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".bitflags."1.3.2" = overridableMkRustCrate (profileName: rec {
    name = "bitflags";
    version = "1.3.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "bef38d45163c2f1dde094a7dfd33ccf595c92905c8f8f4fdc18d06fb1037718a"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".blake2."0.9.2" = overridableMkRustCrate (profileName: rec {
    name = "blake2";
    version = "0.9.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0a4e37d16930f5459780f5621038b6382b9bb37c19016f39fb6b5808d831f174"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      crypto_mac = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crypto-mac."0.8.0" { inherit profileName; };
      digest = rustPackages."registry+https://github.com/rust-lang/crates.io-index".digest."0.9.0" { inherit profileName; };
      opaque_debug = rustPackages."registry+https://github.com/rust-lang/crates.io-index".opaque-debug."0.3.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" = overridableMkRustCrate (profileName: rec {
    name = "cfg-if";
    version = "1.0.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".clap."3.0.0-beta.5" = overridableMkRustCrate (profileName: rec {
    name = "clap";
    version = "3.0.0-beta.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "feff3878564edb93745d58cf63e17b63f24142506e7a20c87a5521ed7bfb1d63"; };
    features = builtins.concatLists [
      [ "atty" ]
      [ "cargo" ]
      [ "clap_derive" ]
      [ "color" ]
      [ "default" ]
      [ "derive" ]
      [ "env" ]
      [ "lazy_static" ]
      [ "std" ]
      [ "strsim" ]
      [ "suggestions" ]
      [ "termcolor" ]
      [ "unicase" ]
      [ "unicode" ]
    ];
    dependencies = {
      atty = rustPackages."registry+https://github.com/rust-lang/crates.io-index".atty."0.2.14" { inherit profileName; };
      bitflags = rustPackages."registry+https://github.com/rust-lang/crates.io-index".bitflags."1.3.2" { inherit profileName; };
      clap_derive = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".clap_derive."3.0.0-beta.5" { profileName = "__noProfile"; };
      indexmap = rustPackages."registry+https://github.com/rust-lang/crates.io-index".indexmap."1.7.0" { inherit profileName; };
      lazy_static = rustPackages."registry+https://github.com/rust-lang/crates.io-index".lazy_static."1.4.0" { inherit profileName; };
      os_str_bytes = rustPackages."registry+https://github.com/rust-lang/crates.io-index".os_str_bytes."4.2.0" { inherit profileName; };
      strsim = rustPackages."registry+https://github.com/rust-lang/crates.io-index".strsim."0.10.0" { inherit profileName; };
      termcolor = rustPackages."registry+https://github.com/rust-lang/crates.io-index".termcolor."1.1.2" { inherit profileName; };
      textwrap = rustPackages."registry+https://github.com/rust-lang/crates.io-index".textwrap."0.14.2" { inherit profileName; };
      unicase = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicase."2.6.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".clap_derive."3.0.0-beta.5" = overridableMkRustCrate (profileName: rec {
    name = "clap_derive";
    version = "3.0.0-beta.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8b15c6b4f786ffb6192ffe65a36855bc1fc2444bcd0945ae16748dcd6ed7d0d3"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    dependencies = {
      heck = rustPackages."registry+https://github.com/rust-lang/crates.io-index".heck."0.3.3" { inherit profileName; };
      proc_macro_error = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro-error."1.0.4" { inherit profileName; };
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.10" { inherit profileName; };
      syn = rustPackages."registry+https://github.com/rust-lang/crates.io-index".syn."1.0.82" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".crossbeam-channel."0.5.1" = overridableMkRustCrate (profileName: rec {
    name = "crossbeam-channel";
    version = "0.5.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "06ed27e177f16d65f0f0c22a213e17c696ace5dd64b14258b52f9417ccb52db4"; };
    features = builtins.concatLists [
      [ "crossbeam-utils" ]
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      crossbeam_utils = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-utils."0.8.5" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".crossbeam-deque."0.8.1" = overridableMkRustCrate (profileName: rec {
    name = "crossbeam-deque";
    version = "0.8.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "6455c0ca19f0d2fbf751b908d5c55c1f5cbc65e03c4225427254b46890bdde1e"; };
    features = builtins.concatLists [
      [ "crossbeam-epoch" ]
      [ "crossbeam-utils" ]
      [ "default" ]
      [ "std" ]
    ];
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      crossbeam_epoch = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-epoch."0.9.5" { inherit profileName; };
      crossbeam_utils = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-utils."0.8.5" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".crossbeam-epoch."0.9.5" = overridableMkRustCrate (profileName: rec {
    name = "crossbeam-epoch";
    version = "0.9.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "4ec02e091aa634e2c3ada4a392989e7c3116673ef0ac5b72232439094d73b7fd"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "lazy_static" ]
      [ "std" ]
    ];
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      crossbeam_utils = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-utils."0.8.5" { inherit profileName; };
      lazy_static = rustPackages."registry+https://github.com/rust-lang/crates.io-index".lazy_static."1.4.0" { inherit profileName; };
      memoffset = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memoffset."0.6.4" { inherit profileName; };
      scopeguard = rustPackages."registry+https://github.com/rust-lang/crates.io-index".scopeguard."1.1.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".crossbeam-utils."0.8.5" = overridableMkRustCrate (profileName: rec {
    name = "crossbeam-utils";
    version = "0.8.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d82cfc11ce7f2c3faef78d8a684447b40d503d9681acebed6cb728d45940c4db"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "lazy_static" ]
      [ "std" ]
    ];
    dependencies = {
      cfg_if = rustPackages."registry+https://github.com/rust-lang/crates.io-index".cfg-if."1.0.0" { inherit profileName; };
      lazy_static = rustPackages."registry+https://github.com/rust-lang/crates.io-index".lazy_static."1.4.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".crypto-mac."0.8.0" = overridableMkRustCrate (profileName: rec {
    name = "crypto-mac";
    version = "0.8.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "b584a330336237c1eecd3e94266efb216c56ed91225d634cb2991c5f3fd1aeab"; };
    features = builtins.concatLists [
      [ "std" ]
    ];
    dependencies = {
      generic_array = rustPackages."registry+https://github.com/rust-lang/crates.io-index".generic-array."0.14.4" { inherit profileName; };
      subtle = rustPackages."registry+https://github.com/rust-lang/crates.io-index".subtle."2.4.1" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".digest."0.9.0" = overridableMkRustCrate (profileName: rec {
    name = "digest";
    version = "0.9.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d3dd60d1080a57a05ab032377049e0591415d2b31afd7028356dbf3cc6dcb066"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "std" ]
    ];
    dependencies = {
      generic_array = rustPackages."registry+https://github.com/rust-lang/crates.io-index".generic-array."0.14.4" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".either."1.6.1" = overridableMkRustCrate (profileName: rec {
    name = "either";
    version = "1.6.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "e78d4f1cc4ae33bbfc157ed5d5a5ef3bc29227303d595861deb238fcec4e9457"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".generic-array."0.14.4" = overridableMkRustCrate (profileName: rec {
    name = "generic-array";
    version = "0.14.4";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "501466ecc8a30d1d3b7fc9229b122b2ce8ed6e9d9223f1138d4babb253e51817"; };
    dependencies = {
      typenum = rustPackages."registry+https://github.com/rust-lang/crates.io-index".typenum."1.14.0" { inherit profileName; };
    };
    buildDependencies = {
      version_check = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".version_check."0.9.3" { profileName = "__noProfile"; };
    };
  });
  
  "unknown".gorn."0.1.0" = overridableMkRustCrate (profileName: rec {
    name = "gorn";
    version = "0.1.0";
    registry = "unknown";
    src = fetchCrateLocal workspaceSrc;
    dependencies = {
      blake2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".blake2."0.9.2" { inherit profileName; };
      clap = rustPackages."registry+https://github.com/rust-lang/crates.io-index".clap."3.0.0-beta.5" { inherit profileName; };
      hex = rustPackages."registry+https://github.com/rust-lang/crates.io-index".hex."0.4.3" { inherit profileName; };
      rayon = rustPackages."registry+https://github.com/rust-lang/crates.io-index".rayon."1.5.1" { inherit profileName; };
      walkdir = rustPackages."registry+https://github.com/rust-lang/crates.io-index".walkdir."2.3.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".hashbrown."0.11.2" = overridableMkRustCrate (profileName: rec {
    name = "hashbrown";
    version = "0.11.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "ab5ef0d4909ef3724cc8cce6ccc8572c5c817592e9285f5464f8e86f8bd3726e"; };
    features = builtins.concatLists [
      [ "raw" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".heck."0.3.3" = overridableMkRustCrate (profileName: rec {
    name = "heck";
    version = "0.3.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "6d621efb26863f0e9924c6ac577e8275e5e6b77455db64ffa6c65c904e9e132c"; };
    dependencies = {
      unicode_segmentation = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-segmentation."1.8.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".hermit-abi."0.1.19" = overridableMkRustCrate (profileName: rec {
    name = "hermit-abi";
    version = "0.1.19";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "62b467343b94ba476dcb2500d242dadbb39557df889310ac77c5d99100aaac33"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    dependencies = {
      libc = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.108" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".hex."0.4.3" = overridableMkRustCrate (profileName: rec {
    name = "hex";
    version = "0.4.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "7f24254aa9a54b5c858eaee2f5bccdb46aaf0e486a595ed5fd8f86ba55232a70"; };
    features = builtins.concatLists [
      [ "alloc" ]
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".indexmap."1.7.0" = overridableMkRustCrate (profileName: rec {
    name = "indexmap";
    version = "1.7.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "bc633605454125dec4b66843673f01c7df2b89479b32e0ed634e43a91cff62a5"; };
    features = builtins.concatLists [
      [ "std" ]
    ];
    dependencies = {
      hashbrown = rustPackages."registry+https://github.com/rust-lang/crates.io-index".hashbrown."0.11.2" { inherit profileName; };
    };
    buildDependencies = {
      autocfg = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.0.1" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".lazy_static."1.4.0" = overridableMkRustCrate (profileName: rec {
    name = "lazy_static";
    version = "1.4.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".libc."0.2.108" = overridableMkRustCrate (profileName: rec {
    name = "libc";
    version = "0.2.108";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8521a1b57e76b1ec69af7599e75e38e7b7fad6610f037db8c79b127201b5d119"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".memchr."2.4.1" = overridableMkRustCrate (profileName: rec {
    name = "memchr";
    version = "2.4.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "308cc39be01b73d0d18f82a0e7b2a3df85245f84af96fdddc5d202d27e47b86a"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "std" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".memoffset."0.6.4" = overridableMkRustCrate (profileName: rec {
    name = "memoffset";
    version = "0.6.4";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "59accc507f1338036a0477ef61afdae33cde60840f4dfe481319ce3ad116ddf9"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
    buildDependencies = {
      autocfg = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.0.1" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".num_cpus."1.13.0" = overridableMkRustCrate (profileName: rec {
    name = "num_cpus";
    version = "1.13.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "05499f3756671c15885fee9034446956fff3f243d6077b91e5767df161f766b3"; };
    dependencies = {
      ${ if (hostPlatform.parsed.cpu.name == "x86_64" || hostPlatform.parsed.cpu.name == "aarch64") && hostPlatform.parsed.kernel.name == "hermit" then "hermit_abi" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".hermit-abi."0.1.19" { inherit profileName; };
      libc = rustPackages."registry+https://github.com/rust-lang/crates.io-index".libc."0.2.108" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".opaque-debug."0.3.0" = overridableMkRustCrate (profileName: rec {
    name = "opaque-debug";
    version = "0.3.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "624a8340c38c1b80fd549087862da4ba43e08858af025b236e509b6649fc13d5"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".os_str_bytes."4.2.0" = overridableMkRustCrate (profileName: rec {
    name = "os_str_bytes";
    version = "4.2.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "addaa943333a514159c80c97ff4a93306530d965d27e139188283cd13e06a799"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "memchr" ]
      [ "raw_os_str" ]
    ];
    dependencies = {
      memchr = rustPackages."registry+https://github.com/rust-lang/crates.io-index".memchr."2.4.1" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".proc-macro-error."1.0.4" = overridableMkRustCrate (profileName: rec {
    name = "proc-macro-error";
    version = "1.0.4";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "da25490ff9892aab3fcf7c36f08cfb902dd3e71ca0f9f9517bea02a73a5ce38c"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "syn" ]
      [ "syn-error" ]
    ];
    dependencies = {
      proc_macro_error_attr = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro-error-attr."1.0.4" { profileName = "__noProfile"; };
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.10" { inherit profileName; };
      syn = rustPackages."registry+https://github.com/rust-lang/crates.io-index".syn."1.0.82" { inherit profileName; };
    };
    buildDependencies = {
      version_check = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".version_check."0.9.3" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".proc-macro-error-attr."1.0.4" = overridableMkRustCrate (profileName: rec {
    name = "proc-macro-error-attr";
    version = "1.0.4";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "a1be40180e52ecc98ad80b184934baf3d0d29f979574e439af5a55274b35f869"; };
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.10" { inherit profileName; };
    };
    buildDependencies = {
      version_check = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".version_check."0.9.3" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" = overridableMkRustCrate (profileName: rec {
    name = "proc-macro2";
    version = "1.0.32";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "ba508cc11742c0dc5c1659771673afbab7a0efab23aa17e854cbab0837ed0b43"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "proc-macro" ]
    ];
    dependencies = {
      unicode_xid = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-xid."0.2.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".quote."1.0.10" = overridableMkRustCrate (profileName: rec {
    name = "quote";
    version = "1.0.10";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "38bc8cc6a5f2e3655e0899c1b848643b2562f853f114bfec7be120678e3ace05"; };
    features = builtins.concatLists [
      [ "default" ]
      [ "proc-macro" ]
    ];
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".rayon."1.5.1" = overridableMkRustCrate (profileName: rec {
    name = "rayon";
    version = "1.5.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "c06aca804d41dbc8ba42dfd964f0d01334eceb64314b9ecf7c5fad5188a06d90"; };
    dependencies = {
      crossbeam_deque = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-deque."0.8.1" { inherit profileName; };
      either = rustPackages."registry+https://github.com/rust-lang/crates.io-index".either."1.6.1" { inherit profileName; };
      rayon_core = rustPackages."registry+https://github.com/rust-lang/crates.io-index".rayon-core."1.9.1" { inherit profileName; };
    };
    buildDependencies = {
      autocfg = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".autocfg."1.0.1" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".rayon-core."1.9.1" = overridableMkRustCrate (profileName: rec {
    name = "rayon-core";
    version = "1.9.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d78120e2c850279833f1dd3582f730c4ab53ed95aeaaaa862a2a5c71b1656d8e"; };
    dependencies = {
      crossbeam_channel = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-channel."0.5.1" { inherit profileName; };
      crossbeam_deque = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-deque."0.8.1" { inherit profileName; };
      crossbeam_utils = rustPackages."registry+https://github.com/rust-lang/crates.io-index".crossbeam-utils."0.8.5" { inherit profileName; };
      lazy_static = rustPackages."registry+https://github.com/rust-lang/crates.io-index".lazy_static."1.4.0" { inherit profileName; };
      num_cpus = rustPackages."registry+https://github.com/rust-lang/crates.io-index".num_cpus."1.13.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".same-file."1.0.6" = overridableMkRustCrate (profileName: rec {
    name = "same-file";
    version = "1.0.6";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "93fc1dc3aaa9bfed95e02e6eadabb4baf7e3078b0bd1b4d7b6b0b68378900502"; };
    dependencies = {
      ${ if hostPlatform.isWindows then "winapi_util" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi-util."0.1.5" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".scopeguard."1.1.0" = overridableMkRustCrate (profileName: rec {
    name = "scopeguard";
    version = "1.1.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "d29ab0c6d3fc0ee92fe66e2d99f700eab17a8d57d1c1d3b748380fb20baa78cd"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".strsim."0.10.0" = overridableMkRustCrate (profileName: rec {
    name = "strsim";
    version = "0.10.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "73473c0e59e6d5812c5dfe2a064a6444949f089e20eec9a2e5506596494e4623"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".subtle."2.4.1" = overridableMkRustCrate (profileName: rec {
    name = "subtle";
    version = "2.4.1";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "6bdef32e8150c2a081110b42772ffe7d7c9032b606bc226c8260fd97e0976601"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".syn."1.0.82" = overridableMkRustCrate (profileName: rec {
    name = "syn";
    version = "1.0.82";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8daf5dd0bb60cbd4137b1b587d2fc0ae729bc07cf01cd70b36a1ed5ade3b9d59"; };
    features = builtins.concatLists [
      [ "clone-impls" ]
      [ "default" ]
      [ "derive" ]
      [ "full" ]
      [ "parsing" ]
      [ "printing" ]
      [ "proc-macro" ]
      [ "quote" ]
    ];
    dependencies = {
      proc_macro2 = rustPackages."registry+https://github.com/rust-lang/crates.io-index".proc-macro2."1.0.32" { inherit profileName; };
      quote = rustPackages."registry+https://github.com/rust-lang/crates.io-index".quote."1.0.10" { inherit profileName; };
      unicode_xid = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-xid."0.2.2" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".termcolor."1.1.2" = overridableMkRustCrate (profileName: rec {
    name = "termcolor";
    version = "1.1.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "2dfed899f0eb03f32ee8c6a0aabdb8a7949659e3466561fc0adf54e26d88c5f4"; };
    dependencies = {
      ${ if hostPlatform.isWindows then "winapi_util" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi-util."0.1.5" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".textwrap."0.14.2" = overridableMkRustCrate (profileName: rec {
    name = "textwrap";
    version = "0.14.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "0066c8d12af8b5acd21e00547c3797fde4e8677254a7ee429176ccebbe93dd80"; };
    features = builtins.concatLists [
      [ "unicode-width" ]
    ];
    dependencies = {
      unicode_width = rustPackages."registry+https://github.com/rust-lang/crates.io-index".unicode-width."0.1.9" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".typenum."1.14.0" = overridableMkRustCrate (profileName: rec {
    name = "typenum";
    version = "1.14.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "b63708a265f51345575b27fe43f9500ad611579e764c79edbc2037b1121959ec"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicase."2.6.0" = overridableMkRustCrate (profileName: rec {
    name = "unicase";
    version = "2.6.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "50f37be617794602aabbeee0be4f259dc1778fabe05e2d67ee8f79326d5cb4f6"; };
    buildDependencies = {
      version_check = buildRustPackages."registry+https://github.com/rust-lang/crates.io-index".version_check."0.9.3" { profileName = "__noProfile"; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicode-segmentation."1.8.0" = overridableMkRustCrate (profileName: rec {
    name = "unicode-segmentation";
    version = "1.8.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8895849a949e7845e06bd6dc1aa51731a103c42707010a5b591c0038fb73385b"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicode-width."0.1.9" = overridableMkRustCrate (profileName: rec {
    name = "unicode-width";
    version = "0.1.9";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "3ed742d4ea2bd1176e236172c8429aaf54486e7ac098db29ffe6529e0ce50973"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".unicode-xid."0.2.2" = overridableMkRustCrate (profileName: rec {
    name = "unicode-xid";
    version = "0.2.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "8ccb82d61f80a663efe1f787a51b16b5a51e3314d6ac365b08639f52387b33f3"; };
    features = builtins.concatLists [
      [ "default" ]
    ];
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".version_check."0.9.3" = overridableMkRustCrate (profileName: rec {
    name = "version_check";
    version = "0.9.3";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "5fecdca9a5291cc2b8dcf7dc02453fee791a280f3743cb0905f8822ae463b3fe"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".walkdir."2.3.2" = overridableMkRustCrate (profileName: rec {
    name = "walkdir";
    version = "2.3.2";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "808cf2735cd4b6866113f648b791c6adc5714537bc222d9347bb203386ffda56"; };
    dependencies = {
      same_file = rustPackages."registry+https://github.com/rust-lang/crates.io-index".same-file."1.0.6" { inherit profileName; };
      ${ if hostPlatform.isWindows then "winapi" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi."0.3.9" { inherit profileName; };
      ${ if hostPlatform.isWindows then "winapi_util" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi-util."0.1.5" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".winapi."0.3.9" = overridableMkRustCrate (profileName: rec {
    name = "winapi";
    version = "0.3.9";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "5c839a674fcd7a98952e593242ea400abe93992746761e38641405d28b00f419"; };
    features = builtins.concatLists [
      [ "consoleapi" ]
      [ "errhandlingapi" ]
      [ "fileapi" ]
      [ "minwinbase" ]
      [ "minwindef" ]
      [ "processenv" ]
      [ "std" ]
      [ "winbase" ]
      [ "wincon" ]
      [ "winerror" ]
      [ "winnt" ]
    ];
    dependencies = {
      ${ if hostPlatform.config == "i686-pc-windows-gnu" then "winapi_i686_pc_windows_gnu" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi-i686-pc-windows-gnu."0.4.0" { inherit profileName; };
      ${ if hostPlatform.config == "x86_64-pc-windows-gnu" then "winapi_x86_64_pc_windows_gnu" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi-x86_64-pc-windows-gnu."0.4.0" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".winapi-i686-pc-windows-gnu."0.4.0" = overridableMkRustCrate (profileName: rec {
    name = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "ac3b87c63620426dd9b991e5ce0329eff545bccbbb34f3be09ff6fb6ab51b7b6"; };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".winapi-util."0.1.5" = overridableMkRustCrate (profileName: rec {
    name = "winapi-util";
    version = "0.1.5";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "70ec6ce85bb158151cae5e5c87f95a8e97d2c0c4b001223f33a334e3ce5de178"; };
    dependencies = {
      ${ if hostPlatform.isWindows then "winapi" else null } = rustPackages."registry+https://github.com/rust-lang/crates.io-index".winapi."0.3.9" { inherit profileName; };
    };
  });
  
  "registry+https://github.com/rust-lang/crates.io-index".winapi-x86_64-pc-windows-gnu."0.4.0" = overridableMkRustCrate (profileName: rec {
    name = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    registry = "registry+https://github.com/rust-lang/crates.io-index";
    src = fetchCratesIo { inherit name version; sha256 = "712e227841d057c1ee1cd2fb22fa7e5a5461ae8e48fa2ca79ec42cfc1931183f"; };
  });
  
}
