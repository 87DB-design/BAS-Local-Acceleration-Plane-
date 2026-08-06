# B.A.S. Local Acceleration Plane
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://img.shields.io/badge/protocols.io-10.17504-blue.svg)](https://www.protocols.io)
[![arXiv](https://img.shields.io/badge/arXiv-quant--ph-red.svg)](https://arxiv.org)
A **Silicon-Isomorphic Execution Plane** for real-time Topological Quantum Error Correction (QEC) decoding. The B.A.S. engine converts dynamic, memory-bound local graph expansion into deterministic, single-cycle register bit-permutations.
---
## Key Performance Achievements

| Benchmark Metric | B.A.S. Local Plane Performance | Legacy CPU / GPU Baselines | Hardware Advantage |
| :--- | :--- | :--- | :--- |
| **Local Processing Latency** | **$17.8\,\text{ns}$ – $26.7\,\text{ns}$ per round** ($<0.55\,\mu\text{s}$ for 20 rounds) | $412.80\,\text{ns}$ avg (Pointer lookups) | **$18.4\times$ Latency Reduction** |
| **FPGA Block RAM (BRAM)** | **0 Slices ($0.0\%$)** | Hundreds of BRAM slices / DRAM buffers | **$100\%$ Memory Elimination** |
| **DSP Slice Utilization** | **0 Units ($0.0\%$)** | Dozens of DSP48 multiply units | **$100\%$ Hardware ALU Reduction** |
| **Off-Chip Memory Traffic** | **0 Bytes** (1–15 128-bit Envelopes) | High PCIe / DRAM bus jitter | **Zero Host Bus Overhead** |
| **Downstream Solver Speedup** | **$1.71\times$ (Union-Find) · Up to $2.09\times$ (Blossom MWPM)** | $O(N^3)$ dense graph matching | **Up to $95.2\%$ Workload Collapse** |
| **Hexagonal Wheel Advantage** | **$1.45\times$ relative defect reduction vs square** | $90^\circ$ Quadrature grid | **Shorter boundary collision paths** |

---
## Architecture Overview
```text
   RAW STABILIZER SYNDROMES (1 µs Round)
                  │
                  ▼
┌─────────────────────────────────────────────────────────┐
│  B.A.S. On-Chip Local Acceleration Plane (FPGA Logic)  │
│  ─────────────────────────────────────────────────────  │
│  • Target: Xilinx Kintex UltraScale+ (XCKU115 @ 450 MHz)│
│  • Processing Latency: < 0.55 µs (20-round worst case)  │
│  • Resource Usage: 0 BRAM Slices, 0 DSP Units           │
│  • Thermodynamic Mechanics: dS_algo = 0 (Reversible)    │
└─────────────────────────────────────────────────────────┘
                  │
                  │ Residual Defect Payload (Shrunk by 32% - 65%)
                  ▼
┌─────────────────────────────────────────────────────────┐
│  Chained 8:0:8 Register Envelopes (128-bit Bus Frames)  │
│  ─────────────────────────────────────────────────────  │
│  • 2D Surface/Color Patch (d=17): 1 to 2 Envelopes      │
│  • 4D Toric Volume (L=8, N=4096): 3 to 15 Envelopes     │
└─────────────────────────────────────────────────────────┘
                  │
                  │ Compact Residual Coordinates (< 240 Bytes)
                  ▼
┌─────────────────────────────────────────────────────────┐
│  Secondary Global Solver (Blossom MWPM / BP+OSD)        │
│  ─────────────────────────────────────────────────────  │
│  • Blossom Matching Time: Dropped from 5.11 ms -> 2.68 ms│
└─────────────────────────────────────────────────────────┘
```

##REPOSITORY STRUCTURE
```text
BAS-Local-Acceleration-Plane/
├── rtl/                                  # Synthesizable SystemVerilog IP Cores
│   ├── symmetrical_annihilator_alu.sv    # Single-cycle combinational Phase Annihilator
│   ├── envelope_808_reg.sv               # 128-bit byte-aligned tryte container register
│   ├── ca_growth_pipeline.sv             # Parallel lattice expansion pipeline (2D surface codes)
│   ├── singleshot_4d_sweep_alu.sv        # 8-neighbor SIMD loop contractor (4D toric codes)
│   ├── qldpc_tanner_sparsifier_alu.sv    # Group-algebra F_2[G] Tanner graph pre-sparsifier
│   ├── qldpc_bivariate_bicycle_engine.sv # Bivariate Bicycle [[144,12,12]] IP core
│   └── bas_envelope_pipeline_4d.sv       # Top-level 4D 8:0:8 envelope pipeline
├── sim/                                  # Simulation & Benchmarking Suite
│   ├── monte_carlo_percolation.py        # High-statistics Monte Carlo simulation suite
│   └── integration_harness_mwpm.py       # Union-Find and NetworkX Blossom MWPM harness
├── paper/                                # Manuscript Source Files
│   └── main.tex                          # IEEE Transactions publication manuscript
└── README.md                             # Repo Documentation
```
