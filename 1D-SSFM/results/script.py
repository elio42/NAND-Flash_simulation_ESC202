import sys
import os
import subprocess

def call_SSFM1D(N, L, padding, time):
    subprocess.run(["build/SSFM1D", "-N", str(N), "-L", str(L), "-P", str(padding), "-t", str(time)])

def call_animation_script(title, output, fps):
    subprocess.run(["python3", "results/animate_wavefunction.py", "--title", title, "--output", output, "--fps", str(fps)])

def test_equality_between_settings():
    base_N = 1024
    base_padding = 50
    time = 0.07

    scenarios = [
        (1, 1),
        (2, 2),
        #(3, 3),
        #(4, 4),
    ]

    for L in [1, 2]:
        for n_mult, p_mult in scenarios:
            N = base_N * n_mult
            padding = base_padding * p_mult

            call_SSFM1D(N, L, padding, time)

            title = f"TDSE SSFM: L={L}, N={N} ({n_mult}x), padding={padding} ({p_mult}x)"
            output = f"results/tdse_ssfm_L{L}_N{N}_P{padding}.mp4"
            call_animation_script(title, output, 30)

def main():
    test_equality_between_settings()

if __name__ == "__main__":
    main()