
module SpStFT
    using FFTW
    using Plots


    struct fastMultiElectronSystem
        ψ::Matrix{ComplexF64}
        ϕ::Vector{Real}
        dx::Real
    end

    struct MultiElectronSystem
        ψ::Matrix{ComplexF64}
        ϕ::Matrix{Real}
        dx::Real
    end

    struct SingleElectronSystem
        ψ::Vector{ComplexF64}
        ϕ::Vector{Real}
        dx::Real
    end

    MultiSys = Union{MultiElectronSystem, fastMultiElectronSystem}


    function step(sys::MultiSys, dt::Real)
        kick(sys, dt/2)
        drift(sys, dt)
        kick(sys, dt/2)
        comp_ϕ(sys)
    end





    function comp_ϕ(ψ::Vector{complex}, dx::Real)
        N = length(ψ)
        main_diag = fill(-2.0 / dx^2, N)
        off_diag = fill(1.0 / dx^2, N-1)
        A = diagm(0 => main_diag, -1 => off_diag, 1 => off_diag)
        ϕ = A * ψ
        return ϕ    
    end

    function comp_ϕ(sys::MultiElectronSystem)
        ϕ = sys.ϕ

        for i in 1:size(sys.ψ, 2)
            ϕ[:, i] = comp_ϕ(sys.ψ[:, i], sys.dx)
        end
    end


    

    function step(sys::SingleElectronSystem, dt::Real)
        kick(sys, dt/2)
        drift(sys, dt)
        kick(sys, dt/2)
    end


    function kick(sys::SingleElectronSystem, dt::Real)
        sys.ψ .*= exp.(-im .* sys.ϕ .* dt)        
    end




    function drift(sys::SingleElectronSystem, dt::Real)
        ψ̂ = fft(sys.ψ)
        ψ̂ .*= exp.(-im .* (0:length(sys.ψ)-1) .* dt)
        sys.ψ .= ifft(ψ̂)
        
    end


    anySys = Union{SingleElectronSystem, MultiElectronSystem, fastMultiElectronSystem}

    function Plot(sys::anySys)
        x = range(-length(sys.ψ)*sys.dx/2, length(sys.ψ)*sys.dx/2, length=length(sys.ψ))
        plot(x, abs.(sys.ψ).^2, title="Wave Function Probability Density", xlabel="x", ylabel="|ψ|^2")
        plot!(x, real.(sys.ψ), label="Real Part")
        plot!(x, imag.(sys.ψ), label="Imaginary Part")
        plot!(x, sys.ϕ, label="Potential", linestyle=:dash)
        
    end


    function steps(sys::anySys, dt::Real, nsteps::Integer)
        ψs = Vector{typeof(sys.ψ)}(undef, nsteps)
        ϕs = Vector{typeof(sys.ϕ)}(undef, nsteps)

        for i in 1:nsteps
            step(sys, dt)
            ψs[i] = copy(sys.ψ)
            ϕs[i] = copy(sys.ϕ)
        end
        return ψs, ϕs
    end
    
    
    function Plot(ψs, ϕs,sys::anySys)
        nsteps = length(ψs)
        x = range(-length(ψs[1])*sys.dx/2, length(ψs[1])*sys.dx/2, length=length(ψs[1]))

        anim = @animate for i in 1:nsteps
            plot(x, abs.(ψs[i]).^2, title="Wave Function Probability Density", xlabel="x", ylabel="|ψ|^2")
            plot!(x, real.(ψs[i]), label="Real Part")
            plot!(x, imag.(ψs[i]), label="Imaginary Part")
            plot!(x, ϕs[i], label="Potential", linestyle=:dash)
        end
        mp4(anim, "wave_evolution.mp4", fps=60)
        
    end
end