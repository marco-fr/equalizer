import numpy as np
import matplotlib.pyplot as plt

from scipy import signal
from scipy.io import wavfile

input_audio = []
output_audio = []

with open('input_audio.txt', 'r') as file:
    for line in file:
        input_audio.append(line)

with open('output_audio.txt', 'r') as file:
    for line in file:
        output_audio.append(line)

input_audio = np.array(input_audio)
output_audio = np.array(output_audio)

input_audio = input_audio.astype(float)
output_audio = output_audio.astype(float)

input_fft = np.fft.rfft(input_audio)
output_fft = np.fft.rfft(output_audio)

omega_real = np.linspace(0, np.pi, len(input_fft))


plt.figure(figsize=(20, 12))
plt.subplot(2, 3, 1)
plt.title('Original Signal')
plt.xlabel('n')
plt.ylabel('Value')
plt.plot(range(len(input_audio)), input_audio)

plt.subplot(2, 3, 2)
plt.title('Output Signal')
plt.xlabel('n')
plt.ylabel('Value')
plt.plot(range(len(output_audio)), output_audio)

plt.subplot(2, 3, 3)
plt.title('Input FFT')
plt.xlabel('$\omega$')
plt.ylabel('Magnitude Response')
plt.plot(omega_real, np.absolute(input_fft))

plt.subplot(2, 3, 4)
plt.title('Output FFT')
plt.xlabel('$\omega$')
plt.ylabel('Magnitude Response')
plt.plot(omega_real, np.absolute(output_fft))

plt.show()