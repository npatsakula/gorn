use blake2::{Blake2b512, Digest};
use clap::Parser;
use rayon::prelude::*;
use std::{
    collections::{BTreeMap, BTreeSet, HashMap},
    fs::{File, OpenOptions},
    io::{self, Read},
    path::{Path, PathBuf},
};
use walkdir::WalkDir;

#[derive(Debug, Parser)]
#[clap(version, author, about)]
struct Opt {
    /// Path to hashable file or directory.
    #[clap(short, long)]
    path: std::path::PathBuf,

    /// Print entire hash tree.
    #[clap(long)]
    print_tree: bool,

    /// Find common hashes in directory.
    #[clap(short, long)]
    common: bool,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let Opt {
        path,
        print_tree,
        common,
    } = Opt::parse();

    let paths = extract_paths(&path)?;
    let hashes = calculate_hashes::<Blake2b512>(paths)?;

    let merged = merge_hashes(hashes.values().cloned());
    let string_hashes = stringify_hashes(hashes);

    if print_tree {
        println!("{:#?}", string_hashes);
    }

    if common {
        println!("{:#?}", find_duplicates(&string_hashes));
    }

    println!("{:02x}", &merged.finalize());
    Ok(())
}

fn find_duplicates(hashes: &BTreeMap<PathBuf, String>) -> BTreeMap<&str, Vec<&Path>> {
    let mut result: HashMap<&str, Vec<&Path>> = HashMap::with_capacity(hashes.len());

    for (path, hash) in hashes {
        result.entry(hash).or_default().push(path);
    }

    result
        .into_iter()
        .filter(|(_hash, paths)| paths.len() > 1)
        .collect()
}

fn extract_paths(path: &Path) -> io::Result<BTreeSet<PathBuf>> {
    let mut result = BTreeSet::new();
    if path.metadata()?.is_file() {
        result.insert(path.to_owned());
        return Ok(result);
    }

    for entry in WalkDir::new(path).into_iter().filter_map(|e| e.ok()) {
        if entry.metadata()?.is_file() {
            result.insert(entry.path().to_owned());
        }
    }

    Ok(result)
}

fn calculate_hashes<H: Digest + Default + Send>(
    source: BTreeSet<PathBuf>,
) -> io::Result<BTreeMap<PathBuf, H>> {
    source
        .into_par_iter()
        .map(|path| {
            let file = OpenOptions::new()
                .read(true)
                .write(false)
                .create(false)
                .open(&path)?;

            Ok((path, hash::<H>(file)))
        })
        .try_fold(
            || BTreeMap::new(),
            |mut acc: BTreeMap<PathBuf, H>, val: io::Result<(PathBuf, H)>| {
                let (path, hash) = val?;
                acc.insert(path, hash);
                Ok(acc)
            },
        )
        .try_reduce(
            || BTreeMap::new(),
            |mut acc, mut val| {
                acc.append(&mut val);
                Ok(acc)
            },
        )
}

fn stringify_hashes<T: Ord + Send, H: Digest + Send>(
    source: BTreeMap<T, H>,
) -> BTreeMap<T, String> {
    source
        .into_par_iter()
        .map(|(p, hasher)| (p, hex::encode(hasher.finalize())))
        .collect()
}

fn merge_hashes<I: IntoIterator<Item = H>, H: Digest + Default>(source: I) -> H {
    source.into_iter().fold(H::default(), |mut acc, hash| {
        acc.update(hash.finalize());
        acc
    })
}

fn hash<H: Digest + Default>(mut file: File) -> H {
    const BUFFER_SIZE: usize = 4086;
    let mut buffer = [0u8; BUFFER_SIZE];
    let mut hasher = H::default();

    while let Ok(n) = file.read(&mut buffer) {
        hasher.update(&buffer[..n]);
        if n < BUFFER_SIZE {
            break;
        }
    }

    hasher
}
