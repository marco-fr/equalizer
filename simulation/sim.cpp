#include <iostream>
#include <cstdint>
#include <vector>
#include <fstream>
#include <string>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vaudio_equalizer.h"

using namespace std;

Vaudio_equalizer* top;

vluint64_t sim_time = 0;
const vluint64_t SIM_END_TIME = 2000000;

void set_gain(int8_t low, int8_t mid, int8_t high){
    top->gain_low = low;
    top->gain_mid = mid;
    top->gain_high = high;
}

void print_gains(){
    std::cout << "LOW: " << static_cast<int>(top->gain_low) << std::endl;
    std::cout << "MID: " << static_cast<int>(top->gain_mid) << std::endl;
    std::cout << "HIGH: " << static_cast<int>(top->gain_high) << std::endl;
}

void load_file(string file_name, vector<int16_t> &list){
    std::ifstream file(file_name);
    int line_count = 0;
    if (!file.is_open()) {
        std::cerr << "Cannot open input file" << std::endl;
        return;
    }
    int16_t tmp;
    while(file >> tmp){
        list.push_back(tmp);
        line_count++;
    }
    file.close();
    std::cout << "Loaded " << line_count << " inputs" << std::endl;
}

void write_file(string file_name, vector<int16_t> &list){
    std::ofstream file(file_name);
    int line_count = list.size();
    if (!file.is_open()) {
        std::cerr << "Cannot open output file" << std::endl;
        return;
    }
    for(auto line : list){
        file << line << std::endl;
    }
    file.close();
    std::cout << "Wrote " << line_count << " outputs." << std::endl;
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv); 

    top = new Vaudio_equalizer;

    set_gain(32, 4, 0);

    std::vector<int16_t> inputs;
    std::vector<int16_t> outputs;

    load_file("simulation/audio_in.txt", inputs);

    int input_size = inputs.size();
    int count = 0;

    top->reset = 1;
    for(int i = 0; i < 10; i++){
        top->clk = !top->clk;
        top->eval();
    }
    top->reset = 0;

    while (!Verilated::gotFinish() && sim_time < SIM_END_TIME) {
        if(count == input_size - 1){
            break;
        }

        if(!top->clk){
            top->audio_in = inputs[count];
            outputs.push_back(static_cast<int16_t>(top->audio_out));
            count++;
        }

        top->clk = !top->clk;
        top->eval();
        sim_time++;
    }
    write_file("simulation/audio_out.txt", outputs);
    delete top;
    return 0;
}
