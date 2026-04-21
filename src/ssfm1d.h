#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <vector>
#include <cmath>
#include <complex>
#include <fftw3.h>

const double L = 1; // Length of the grid
const double N = 1024;
const double dx = L / N;
const double boudary_potential = 1e6;
const double hbar = 1;
const double m = 1;
const double dk = 2 * M_PI / L;

class SSFM1D {
    private:
        std::vector<double> grid;
        std::vector<std::complex<double>> waveFunction;
        std::vector<double> enviroment_potential;
        std::vector<double> k;
        std::vector<std::complex<double>> U_p;
        std::vector<std::complex<double>> U_k;
        fftw_plan plan_forward;
        fftw_plan plan_backward;
        fftw_complex *psi_in;
        double dt;
        double dk;

        void configure_fftw_plans();
        void set_max_time_step();
        void initialize_grid();
        void initialize_wavefunction();
        void initialize_enviroment_potential();
        void initialize_potential_operator();
        void initialise_kinetic_operator();
        void normalize_wavefunction();

        void potential_half_step();
        void forward_fft();
        void kinetic_full_step();
        void inverse_fft();

    public:
        SSFM1D();
        
        void step();
        std::vector<double> calculate_probability_density();
        void output_wavefunction(const std::string& filename);
};