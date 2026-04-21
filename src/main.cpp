#include "ssfm1d.h"
#include <cfenv>

#if defined(__linux__)
#include <fenv.h>
#endif

int main()
{ // int argc, char *argv[]
#if defined(__linux__)
    feenableexcept(FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW);
#endif

    std::cout << "Running 1D SSFM simulation..." << std::endl;

    SSFM1D ssfm;
    int num_steps = 10000000;
    for (int i = 0; i < num_steps; ++i)
    {
        if (i % 10000 == 0)
        { // Output every 100 steps
            ssfm.output_wavefunction("output/wavefunction_" + std::to_string(i) + ".txt");
        }
        ssfm.step();
    }

    return 0;
}
