#include "ssfm1d.h"
#include <cfenv>
#include <filesystem>

#if defined(__linux__)
#include <fenv.h>
#endif

namespace {
void initialize_output_directory(const std::string& output_dir) {
    namespace fs = std::filesystem;

    fs::path dir_path(output_dir);
    if (!fs::exists(dir_path)) {
        fs::create_directories(dir_path);
        return;
    }

    for (const auto& entry : fs::directory_iterator(dir_path)) {
        if (entry.is_regular_file()) {
            fs::remove(entry.path());
        }
    }
}
}

int main()
{ // int argc, char *argv[]
#if defined(__linux__)
    feenableexcept(FE_INVALID | FE_DIVBYZERO | FE_OVERFLOW);
#endif
    std::cout << "Running 1D SSFM simulation..." << std::endl;

    SSFM1D ssfm;
    std::string output_dir = "output/";
    initialize_output_directory(output_dir);
    int num_steps = 1000000;
    for (int i = 0; i < num_steps; ++i)
    {
        if (i % 10000 == 0)
        { // Output every 100 steps
            ssfm.output_wavefunction(output_dir + "wavefunction_" + std::to_string(i) + ".txt");
        }
        ssfm.step();
    }

    return 0;
}
