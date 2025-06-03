#!/bin/sh

cd out/qovery-client-rust || exit

for p in $(ls --color=never ../../generator/patches/rust/*.diff)
do
  echo "Applying patch $p"
  patch -p1 < $p
done
cargo build
cargo fmt
