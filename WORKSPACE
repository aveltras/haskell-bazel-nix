workspace(name = "skeleton")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "io_tweag_rules_nixpkgs",
    strip_prefix = "rules_nixpkgs-c40b35f73e5ab1c0096d95abf63027a3b8054061",
    urls = ["https://github.com/tweag/rules_nixpkgs/archive/c40b35f73e5ab1c0096d95abf63027a3b8054061.tar.gz"],
    sha256 = "47fffc870a25d82deedb887c32481a43a12f56b51e5002773046f81fbe3ea9df",
)

http_archive(
  name = "rules_haskell",
  strip_prefix = "rules_haskell-c0e0759dc9c170ec589953194c0efa8fb1f5341d",
  urls = ["https://github.com/tweag/rules_haskell/archive/c0e0759dc9c170ec589953194c0efa8fb1f5341d.tar.gz"],
  sha256 = "3ed7e30e3aefe33e5e1c785d5d10dce2467172d670695b6c55b69052028f240c",
)

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59d5b42ac315e7eadffa944e86e90c2990110a1c8075f1cd145f487e999d22b3",
    strip_prefix = "rules_docker-0.17.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.17.0/rules_docker-v0.17.0.tar.gz"],
)

load("@io_bazel_rules_docker//toolchains/docker:toolchain.bzl", docker_toolchain_configure="toolchain_configure")
docker_toolchain_configure(name = "docker_config", docker_path = "/usr/bin/docker")

load("@io_tweag_rules_nixpkgs//nixpkgs:repositories.bzl", "rules_nixpkgs_dependencies")
rules_nixpkgs_dependencies()

load("@rules_haskell//haskell:repositories.bzl", "rules_haskell_dependencies")
rules_haskell_dependencies()

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_local_repository", "nixpkgs_package")
nixpkgs_local_repository(name = "nixpkgs", nix_file = "//:nixpkgs.nix")

load("@rules_haskell//haskell:nixpkgs.bzl", "haskell_register_ghc_nixpkgs")
haskell_register_ghc_nixpkgs(
  version = "8.10.4",
  attribute_path = "compiler",
  repository = "@nixpkgs",
  # repositories = { "nixpkgs": "@nixpkgs" },
)

nixpkgs_package(
    name = "raw-haskell-base-image",
    repository = "@nixpkgs",
    attribute_path = "raw-haskell-base-image",
    build_file_content = """
package(default_visibility = [ "//visibility:public" ])
exports_files(["image"])
    """,
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_cc_configure")
nixpkgs_cc_configure(repository = "@nixpkgs")

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repositories = "repositories")
container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()

load("@io_bazel_rules_docker//container:container.bzl", "container_load")
container_load(name = "haskell-base-image", file = "@raw-haskell-base-image//:image")
