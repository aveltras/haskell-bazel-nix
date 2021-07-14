# haskell-bazel-nix

Building a binary with Bazel
```sh
bazel build //backend:skeleton
```

Building a binary packaged as a container with Bazel
```sh
bazel build //backend:skeleton_container
```

Watching the project with ghcid:
```sh
ghcid --command 'bazel run //:hie-bios@repl' -W -T :main
```

To clean rules_haskell sources to not interfere with hie-bios, clone rules_haskell in another directory and generate the patch with the following:
```sh
find . -name "*.hs" -type f -delete
find . -name "*.lhs" -type f -delete
git diff > clean_rules_haskell.patch
```
