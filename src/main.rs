use blake2::{Blake2b, Digest};
use clap::Parser;
use rayon::prelude::*;
use std::{collections::BTreeMap, fs::File, io::Read, path::Path};
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
    let opts = Opt::parse();

    let hashes = build_file_tree(&opts.path).map(calculate_hashes::<Blake2b>)?;
    let merged = merge_hashes(hashes.clone());
    let string_hashes = print_hashes(hashes);

    if opts.print_tree {
        println!("{:#?}", string_hashes);
    }

    if opts.common {
        println!("{:#?}", find_commons(string_hashes));
    }

    println!("{:02x}", &merged.finalize());
    Ok(())
}

fn find_commons(string_hashes: BTreeMap<String, String>) -> (i32, Vec<[String; 2]>) {
    let mut commons = Vec::new();
    let mut counter = 0;

    for (file_name1, hash1) in string_hashes.iter() {
        for (file_name2, hash2) in string_hashes.iter() {
            if &hash1 == &hash2 {
                counter += 1;
                commons.push([file_name1.to_owned(), file_name2.to_owned()])
            }
        }
    }

    (counter, commons)
}

fn build_file_tree(path: &Path) -> std::io::Result<BTreeMap<String, File>> {
    let metadata = path.metadata()?;
    if metadata.is_file() {
        let file = File::open(path)?;
        return Ok(BTreeMap::from([(path.to_str().unwrap().to_owned(), file)]));
    }

    let mut result = BTreeMap::new();
    for entry in WalkDir::new(path).into_iter().filter_map(|e| e.ok()) {
        let metadata = entry.metadata()?;

        if metadata.is_file() {
            let file = File::open(entry.path())?;
            result.insert(entry.path().to_str().unwrap().to_owned(), file);
        }
    }

    Ok(result)
}

fn calculate_hashes<H: Digest + Default + Send>(
    source: BTreeMap<String, File>,
) -> BTreeMap<String, H> {
    source
        .into_par_iter()
        .map(|(path, file)| (path, hash::<H>(file)))
        .collect()
}

fn print_hashes<H: Digest>(source: BTreeMap<String, H>) -> BTreeMap<String, String> {
    source
        .into_iter()
        .map(|(path, hasher)| (path, hex::encode(hasher.finalize())))
        .collect()
}

fn merge_hashes<H: Digest + Default>(source: BTreeMap<String, H>) -> H {
    source.into_iter().fold(H::default(), |mut acc, (_, hash)| {
        acc.update(hash.finalize());
        acc
    })
}

fn hash<H: Digest + Default>(mut file: File) -> H {
    let mut buffer = [0u8; 2048];
    let mut hasher = H::default();

    while let Ok(n) = file.read(&mut buffer) {
        hasher.update(&buffer[..n]);
        if n == 0 || n < 1024 {
            break;
        }
    }

    hasher
}
