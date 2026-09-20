#!/bin/bash
# Paste into the cloud environment's "Setup script" field.
# Runs once as root, before Claude Code launches; the filesystem is then snapshotted
# and reused for every later session in this environment, so this ~2.5 min cost is
# paid once (until this script, or the allowed network hosts, change -- or the ~7-day
# cache expiry hits). See https://code.claude.com/docs/en/cloud-environments#setup-scripts

RAW_BASE="https://raw.githubusercontent.com/gamer-project/gamer-metrics/claude/claude/"

# 1. Fetch the short cloud-agent guide as this VM's user-level CLAUDE.md, and the
#    machine config file to $HOME -- copy it into gamer/configs/ when compiling.
mkdir -p ~/.claude
curl -fsSL "$RAW_BASE/CLAUDE.md"             -o ~/.claude/CLAUDE.md || true
curl -fsSL "$RAW_BASE/claude_cloud.config"   -o ~/claude_cloud.config || true

# 2. Install MPI + CUDA toolkit (compile-only here -- no GPU hardware, but nvcc still
#    compiles and links correctly). --no-install-recommends skips the heavy
#    Nsight/Visual Profiler GUI tooling the plain package would otherwise pull in.
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq || true
apt-get install -y --no-install-recommends \
  libopenmpi-dev openmpi-bin \
  nvidia-cuda-toolkit \
  || true
apt-get clean || true