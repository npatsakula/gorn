use blake2::{Blake2b, Digest};
use clap::Parser;
use rayon::prelude::*;
use std::{
    collections::{BTreeMap, HashMap},
    fs::File,
    io::Read,
    path::Path,
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

    /// Find duplicate files by hashes in directory.
    #[clap(short, long)]
    duplicates: bool,

    /// Count duplicate files by hashes in directory.
    #[clap(short, long)]
    count: bool,
}

#[allow(unused_variables, unreachable_patterns)]
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let opts = Opt::parse();

    let hashes = build_file_tree(&opts.path).map(calculate_hashes::<Blake2b>)?;
    let merged = merge_hashes(hashes.clone());
    let string_hashes = print_hashes(hashes);

    if opts.print_tree {
        println!("{:#?}", string_hashes)
    }

    if opts.duplicates {
        println!("{:#?}", find_duplicates(&string_hashes))
    }
    if opts.count {
        println!("{}", find_duplicates(&string_hashes).len())
    }

    println!("{:02x}", &merged.finalize());
    Ok(())
}

fn find_duplicates(hashes: &BTreeMap<String, String>) -> HashMap<&str, Vec<&str>> {
    let mut result: HashMap<&str, Vec<&str>> = HashMap::with_capacity(hashes.len());

    for (path, hash) in hashes {
        result.entry(hash).or_default().push(path);
    }

    result
        .into_iter()
        .filter(|(_hash, pathes)| pathes.len() > 1)
        .collect()
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

#[cfg(test)]
mod tests {
    use crate::find_duplicates;
    use std::collections::{BTreeMap, HashMap};

    #[test]
    fn find_common() {
        let mut hello_map = BTreeMap::new();
        hello_map.insert("hello".to_owned(), "48656c6c6f20776f726c6421".to_owned());
        hello_map.insert(
            "hello_world".to_owned(),
            "48656c6c6f20776f726c6421".to_owned(),
        );
        hello_map.insert(
            "Hello, world!".to_owned(),
            "48656c6c6f20776f726c6421".to_owned(),
        );

        let result = find_duplicates(&hello_map);
        let mut result_hash = HashMap::new();
        result_hash.insert(
            "48656c6c6f20776f726c6421",
            vec!["Hello, world!", "hello", "hello_world"],
        );
        assert_eq!(result, result_hash);
    }
}
