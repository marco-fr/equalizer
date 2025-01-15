import numpy as np
import matplotlib.pyplot as plt

from scipy import signal
from numpy.random import randn
from IPython.display import Audio
from scipy.io import wavfile

fs, audio = wavfile.read('sound1.wav')
print("FS:" ,fs)
audio_signal_fft = np.fft.rfft(audio)
w1 = np.linspace(0, np.pi, len(audio_signal_fft))
audio_magnitude = np.absolute(audio_signal_fft)

def sig2db(mag_spec):
    return 20*np.log10(mag_spec)

def output_file(audio, file_name="audio_in.txt"):
    print("Audio Length: ", len(audio))
    print("Max Signal: ", max(audio))
    print("Min Signal: ", min(audio))
    print("Output file: ", file_name)
    
    with open(file_name, 'w') as f:
        for line in audio:
            f.write(f"{line}\n")

def load_sim_output(file_name="audio_out.txt"):
    with open(file_name, 'r') as f:
        int_list = []
        for line in f:
            int_list.append(int(line.strip()))
    int_list = np.array(int_list)
    print("MAX VAL: ", max(int_list))
    print("LENGTH: ", len(int_list))
    return int_list

def plot(audio, out):
    audio_signal_fft = np.fft.rfft(audio)
    w1 = np.linspace(0, np.pi, len(audio_signal_fft))
    audio_magnitude = np.absolute(audio_signal_fft)

    out_signal_fft = np.fft.rfft(out)
    w2 = np.linspace(0, np.pi, len(out_signal_fft))
    out_magnitude = np.absolute(out_signal_fft)
    
    plt.figure(figsize=(20,6))
    plt.subplot(1, 2, 1)
    plt.plot(w1,audio_magnitude) 
    plt.xlabel('$\omega$')
    plt.ylabel('Magnitude Response (Linear)')
    plt.title("Magnitude Response of FFT of Audio Signal vs $\omega$")
    plt.subplot(1, 2, 2)
    plt.plot(w2,out_magnitude) 
    plt.xlabel('$\omega$')
    plt.ylabel('Magnitude Response (Linear)')
    plt.title("Magnitude Response of FFT of Output Signal vs $\omega$")
    plt.show()

def spectrogram(audio, out, fs):
    nfft = 512
    f_a, t_a, S_a = signal.spectrogram(audio, fs, nperseg = nfft, noverlap = int(nfft/2), nfft = nfft)
    f_b, t_b, S_b = signal.spectrogram(out, fs, nperseg = nfft, noverlap = int(nfft/2), nfft = nfft)

    plt.figure(figsize=(20,5))
    plt.subplot(1, 2, 1)
    plt.pcolormesh(t_a, f_a, sig2db(S_a), vmin=-200, vmax=170)
    plt.title('Spectrogram for Audio (Log)')
    plt.ylim([0, 21000])
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.colorbar()
    plt.subplot(1, 2, 2)
    plt.pcolormesh(t_b, f_b, sig2db(S_b), vmin=-200, vmax=170)
    plt.title('Spectrogram for Output (Log)')
    plt.ylim([0, 21000])
    plt.ylabel('Frequency [Hz]')
    plt.xlabel('Time [sec]')
    plt.colorbar()
    plt.show()

def write_audio(fs, audio, file_name="audio_out.wav"):
    wavfile.write(file_name, fs, audio.astype(np.int16))
out = load_sim_output()

write_audio(fs, out)
plot(audio, out)
spectrogram(audio,out, fs)

#output_file(audio)