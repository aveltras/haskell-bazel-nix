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
## Debugging repo

Content of bazel-bin/hie-bios@hie-bios loaded into $HIE_BIOS_OUTPUT
```sh
-package-id
base-4.14.1.0
-package-id
base-4.14.1.0
-pgma
bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python
-pgmc
bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python
-pgml
bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python
-pgmP
bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python -E -undef -traditional
-optc-fno-stack-protector
-ibackend/package-b/
-ibazel-out/k8-fastbuild/bin/backend/package-b/
-ibackend/package-a/
-ibazel-out/k8-fastbuild/bin/backend/package-a/
backend/package-b/src/Lib2.hs
backend/package-a/src/Main.hs
```
hie-bios check backend/package-b/src/Lib2.hs outputs nothing
```sh
hie-bios check backend/package-a/src/Main.hs outputs
backend/package-a/src/Main.hs:3:1:Could not find module ‘Lib2’
Perhaps you meant Lib (from libiserv-8.10.4)
Use -v (or `:set -v` in ghci) to see a list of the files searched for.
```
