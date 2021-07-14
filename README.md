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

Output of hie-bios debug backend/package-a/src/Main.hs
```sh
Root directory:        /home/romain/Code/skeleton
Component directory:   /home/romain/Code/skeleton
GHC options:           -package-id base-4.14.1.0 -package-id base-4.14.1.0 -pgma bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python -pgmc bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python -pgml bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python -pgmP "bazel-out/host/bin/external/rules_haskell/haskell/cc_wrapper-python -E -undef -traditional" -optc-fno-stack-protector -ibackend/package-b/ -ibazel-out/k8-fastbuild/bin/backend/package-b/ -ibackend/package-a/ -ibazel-out/k8-fastbuild/bin/backend/package-a/ backend/package-b/src/Lib2.hs backend/package-a/src/Main.hs -Wwarn
GHC library directory: CradleSuccess "/nix/store/dw33h578wv2rqcxl0yhpcrfs33p0rl2r-ghc-8.10.4-with-packages/lib/ghc-8.10.4"
GHC version:           CradleSuccess "8.10.4"
Config Location:       /home/romain/Code/skeleton/hie.yaml
Cradle:                Cradle {cradleRootDir = "/home/romain/Code/skeleton", cradleOptsProg = CradleAction: Multi}
```

Output of haskell-language-server backend/package-a
```sh
haskell-language-server version: 1.2.0.0 (GHC: 8.10.4) (PATH: /nix/store/5vkn6fdmg7xnrfvxsknj70svjx4bbnyq-haskell-language-server-1.2.0.0/bin/haskell-language-server)
 ghcide setup tester in /home/romain/Code/skeleton.
Report bugs at https://github.com/haskell/haskell-language-server/issues

Step 1/4: Finding files to test in /home/romain/Code/skeleton
Found 1 files

Step 2/4: Looking for hie.yaml files that control setup
Found 1 cradle
  (/home/romain/Code/skeleton/hie.yaml)

Step 3/4: Initializing the IDE

Step 4/4: Type checking the files
2021-07-14 11:07:47.0951084 [ThreadId 52] INFO hls:     Consulting the cradle for "backend/package-a/src/Main.hs"
Output from setting up the cradle Cradle {cradleRootDir = "/home/romain/Code/skeleton", cradleOptsProg = CradleAction: Multi}
> Loading:
> Loading: 0 packages loaded
> Analyzing: target //:hie-bios (0 packages loaded, 0 targets configured)
> INFO: Analyzed target //:hie-bios (0 packages loaded, 0 targets configured).
> INFO: Found 1 target...
> [0 / 1] [Prepa] BazelWorkspaceStatusAction stable-status.txt
> Target //:hie-bios up-to-date:
>   bazel-bin/hie-bios@hie-bios
> Build artifacts:
> >>>/home/romain/.cache/bazel/_bazel_romain/4e0a165b088520c120efa911290fd831/execroot/skeleton/bazel-out/k8-fastbuild/bin/hie-bios@hie-bios
> INFO: Elapsed time: 0.063s, Critical Path: 0.00s
> INFO: 1 process: 1 internal.
> INFO: Build completed successfully, 1 total action
> INFO: Build completed successfully, 1 total action
2021-07-14 11:07:47.2581032 [ThreadId 52] INFO hls:     Using interface files cache dir: /home/romain/.cache/ghcide/main-8be3724dfa35261128b0a57754cdef62c299d729
2021-07-14 11:07:47.2583892 [ThreadId 52] INFO hls:     Making new HscEnv[main]
2021-07-14 11:07:47.2742464 [ThreadId 141] INFO hls:    File:     /home/romain/Code/skeleton/backend/package-a/src/Main.hs
Hidden:   no
Range:    3:8-3:12
Source:   not found
Severity: DsError
Message:  Could not find module ‘Lib2’Perhaps you meant Lib (from libiserv-8.10.4)
2021-07-14 11:07:47.2750074 [ThreadId 152] INFO hls:    finish: User TypeCheck (took 0.01s)
2021-07-14 11:07:47.275172 [ThreadId 155] INFO hls:     finish: GetHie (took 0.00s)
Files that failed:
 * /home/romain/Code/skeleton/backend/package-a/src/Main.hs

Completed (0 files worked, 1 file failed)
2021-07-14 11:07:47.2753287 [ThreadId 157] INFO hls:    finish: GenerateCore (took 0.00s)
```
