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
