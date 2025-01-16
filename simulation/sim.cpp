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

void toggle_reset(int delay){
    top->reset = 1;
    for(int i = 0; i < delay; i++){
        top->clk = !top->clk;
        top->eval();
    }
    top->reset = 0;
}

void send_uart_gain(int band, int gain, int count, int begin){
    int uart_count = 0;
    int data = (gain << 3) + band;
    data = (data << 1);
    if(count >= begin && count <= 11 + begin){
        if(!(data & (1 << (count - begin))))
            top->rx = 0;
    }
}

void test_uart_change_gain(){
    std::vector<int16_t> inputs;
    std::vector<int16_t> outputs;

    load_file("simulation/audio_in.txt", inputs);

    int input_size = inputs.size();
    int count = 0;

    while (!Verilated::gotFinish() && sim_time < SIM_END_TIME) {
        if(count == input_size - 1){
            break;
        }
        top->rx = 1;
        if(!top->clk){
            top->audio_in = inputs[count];
            outputs.push_back(static_cast<int16_t>(top->audio_out));
            count++;
            send_uart_gain(2, 2, count, 5000);
            send_uart_gain(2, 64, count, 300000);
            send_uart_gain(2, 32, count, 500000);
        }

        top->clk = !top->clk;
        top->eval();
        sim_time++;
    }

    write_file("simulation/audio_out.txt", outputs);
}

void test_audio(){
    std::vector<int16_t> inputs;
    std::vector<int16_t> outputs;

    load_file("simulation/audio_in.txt", inputs);

    int input_size = inputs.size();
    int count = 0;

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
}

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv); 

    top = new Vaudio_equalizer;
    top->rx = 1;
    toggle_reset(10);

    //test_audio();
    test_uart_change_gain();

    delete top;
    return 0;
}
