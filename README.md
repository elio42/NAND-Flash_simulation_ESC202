# NAND-Flash_simulation_ESC202

## 1D-SSFM

**Dependencies:**

- `fftw3`

**Build:** (from `(...)/1D-SSFM`)

- cmake -S src -B build
- cmake --build build
- ./build/SSFM1D

**Difference schedule possibilities:

- `#pragma omp parallel for schedule(static, N / omp_get_max_threads())`
- `#pragma omp parallel for schedule(guided, 1)`
- `#pragma omp parallel for schedule(auto)`