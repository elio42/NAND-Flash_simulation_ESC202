from pathlib import Path
import re

import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import numpy as np


# Parameters
OUTPUT_DIR = Path(__file__).resolve().parent / "output"
PATTERN = "wavefunction_*.txt"
INTERVAL_MS = 80
OUTPUT_MP4 = Path(__file__).resolve().parent / "wavefunction.mp4"


def frame_index(path: Path) -> int:
	m = re.search(r"wavefunction_(\d+)\.txt$", path.name)
	return int(m.group(1)) if m else -1


files = sorted(OUTPUT_DIR.glob(PATTERN), key=frame_index)
if not files:
	raise FileNotFoundError(f"No files found in {OUTPUT_DIR} matching {PATTERN}")

first = np.atleast_2d(np.loadtxt(files[0]))
x = first[:, 0]

fig, ax = plt.subplots()
line_re, = ax.plot(x, first[:, 1], label="Re[psi]", color="#1fb45d96", lw=1.0)
line_im, = ax.plot(x, first[:, 2], label="Im[psi]", color="#0e9fff81", lw=1.0)
line_prob, = ax.plot(x, first[:, 3], label="|psi|^2", color="#a02c2c", lw=1.0)
ax.set_xlabel("x")
ax.set_ylabel("psi")
ax.legend()


def update(i):
	data = np.atleast_2d(np.loadtxt(files[i]))
	line_re.set_ydata(data[:, 1])
	line_im.set_ydata(data[:, 2])
	line_prob.set_ydata(data[:, 3])
	ax.set_title(f"timestep = {frame_index(files[i])}")
	return line_re, line_im, line_prob


anim = FuncAnimation(fig, update, frames=len(files), interval=INTERVAL_MS, blit=False)
anim.save(OUTPUT_MP4, fps=1000 / INTERVAL_MS)
