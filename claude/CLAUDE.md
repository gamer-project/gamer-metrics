# GAMER cloud-agent notes

Ephemeral Anthropic-hosted VM (4 vCPU / 16GB RAM / ~30GB disk, Ubuntu 24.04) dedicated
to GAMER. Fetched into `~/.claude/CLAUDE.md` by the setup script, not part of the repo.
Source: https://github.com/gamer-project/gamer-metrics/blob/claude/claude/CLAUDE.md

## Capabilities
CPU serial, OpenMP, and MPI all work, including actually running
(`mpirun --allow-run-as-root -np N ./gamer` — root needs the flag). CUDA compiles and
links fine, but there's no physical GPU: any `--gpu=true` build will always fail at
*runtime* with "no CUDA-capable device is detected". That's expected — don't debug it.

## To compile
```bash
cp ~/claude_cloud.config gamer/configs/        # pre-installed by the setup script
cd gamer/src
bash ../tool/config/set_settings.sh --global --machine=claude_cloud      # bash, not sh
python3 configure.py --model=HYDRO --openmp=true --mpi=false --gpu=false # drop/add flags as needed
make clean
make -j4
```

## To setup input files
You can find the template and examples in `example/test_problem/`

e.g. To run a simple 1D test:
``` bash
cd bin
mkdir shocktube
cd shocktube
cp -r ../../example/test_problem/Hydro/Riemann/* .
cp ../gamer .
```

## Git
No push access to `gamer-project/gamer` directly, but there is to several forks.
Run `git remote -v` and confirm which remote to push to before pushing — don't assume
`origin` is writable.

## If this is stale
Treat it as a shortcut, not ground truth — verify against actual behavior if in doubt.