include("PSolver.jl")
include("SpStFT.jl")
include("WaveFunc.jl")
using Plots


N = 1024
l = 20.0

x = range(-l/2, l/2, length=N)

σ = 0.5
x₀ = 0.0
k₀ = 5.0

ψ = WaveFunc.wave_func(x, σ, x₀, k₀)

sys = SpStFT.SingleElectronSystem(ψ, zeros(N), l/N)

dt = 0.05


steps = 1000


ψs, ϕs = SpStFT.steps(sys, dt, steps)

SpStFT.Plot(ψs, ϕs, sys)
[]
