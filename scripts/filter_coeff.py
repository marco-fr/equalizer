import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

N = 101
a = [1, 0]
MULT = 512

def sig2db(mag_spec):
    return 20*np.log10(mag_spec)

lpf_bands = [0, 0.3, 0.35, 1]
lpf_desired = [1, 0]
lpf = signal.remez(N, lpf_bands, lpf_desired, fs=2)
lpf *= MULT
lpf = lpf.astype(int)
w, H_lpf = signal.freqz(lpf, a)

bpf_bands = [0, 0.3, 0.35, 0.6, 0.65, 1]
bpf_desired = [0, 1, 0]
bpf = signal.remez(N, bpf_bands, bpf_desired, fs=2)
bpf *= MULT
bpf = bpf.astype(int)
w, H_bpf = signal.freqz(bpf, a)

hpf_bands = [0, 0.6, 0.65, 1]
hpf_desired = [0, 1]
hpf = signal.remez(N, hpf_bands, hpf_desired, fs=2)
hpf *= MULT
hpf = hpf.astype(int)
w, H_hpf = signal.freqz(hpf, a)

def verilog_conv(l):
    res = "'{"
    count = 0
    for i in l:
        if(count == 10):
            count = 0
            res += "\n"
        if(i < 0):
            res += "-16'd" + str(abs(i)) + ', '
        else:
            res += "16'd" + str(abs(i)) + ', '
        count += 1
    return res[:-2] + "\n}"


def print_coeff():
    print("LOW PASS: " + verilog_conv(lpf))
    print("BAND PASS: " + verilog_conv(bpf))
    print("HIGH PASS: " + verilog_conv(hpf))

def display_filters():
    plt.figure(figsize=(20, 6))
    plt.subplot(131)
    plt.title('Low-pass Filter')
    plt.plot(w, (abs(H_lpf)))
    plt.subplot(132)
    plt.title('Band-pass Filter')
    plt.plot(w, (abs(H_bpf)))
    plt.subplot(133)
    plt.title('High-pass Filter')
    plt.plot(w, (abs(H_hpf)))
    plt.show()

print_coeff()
display_filters()