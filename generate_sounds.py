import wave
import struct
import math
import os

AUDIO_DIR = r"E:\YOUTUBE 2026\Publish APPS\PujaVidhi\pujavidhi_main\assets\audio"
os.makedirs(AUDIO_DIR, exist_ok=True)

def generate_bell(filename, duration=2.5, sample_rate=44100):
    # Temple brass bell: fundamental around 800Hz with rich harmonics and exponential decay
    num_samples = int(duration * sample_rate)
    samples = []
    freqs = [780, 1560, 2340, 3120, 3900]
    weights = [0.5, 0.25, 0.12, 0.08, 0.05]
    decays = [2.0, 3.5, 5.0, 6.5, 8.0]

    for i in range(num_samples):
        t = i / sample_rate
        val = 0.0
        for f, w, d in zip(freqs, weights, decays):
            val += w * math.sin(2 * math.pi * f * t) * math.exp(-d * t)
        # normalize to 16-bit
        int_val = int(max(min(val * 28000, 32767), -32768))
        samples.append(int_val)

    with wave.open(os.path.join(AUDIO_DIR, filename), 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        for s in samples:
            wav_file.writeframes(struct.pack('<h', s))

def generate_shankh(filename, duration=3.0, sample_rate=44100):
    # Divine Shankh sound: brassy horn-like drone around 240Hz rising slightly with warm vibrato
    num_samples = int(duration * sample_rate)
    samples = []
    
    for i in range(num_samples):
        t = i / sample_rate
        # attack and decay envelope
        env = 1.0
        if t < 0.3:
            env = t / 0.3
        elif t > 2.2:
            env = max(0.0, (3.0 - t) / 0.8)

        # slight pitch rise and vibrato
        f = 240.0 + 10.0 * (1.0 - math.exp(-3 * t)) + 3.0 * math.sin(2 * math.pi * 5 * t)
        val = 0.6 * math.sin(2 * math.pi * f * t) + \
              0.3 * math.sin(2 * math.pi * (f * 2) * t) + \
              0.15 * math.sin(2 * math.pi * (f * 3) * t) + \
              0.08 * math.sin(2 * math.pi * (f * 4) * t)
        val *= env
        int_val = int(max(min(val * 26000, 32767), -32768))
        samples.append(int_val)

    with wave.open(os.path.join(AUDIO_DIR, filename), 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        for s in samples:
            wav_file.writeframes(struct.pack('<h', s))

def generate_japa_click(filename, duration=0.2, sample_rate=44100):
    # Wood / rudraksha bead tactile click sound
    num_samples = int(duration * sample_rate)
    samples = []
    
    for i in range(num_samples):
        t = i / sample_rate
        val = math.sin(2 * math.pi * 1200 * t) * math.exp(-35 * t)
        int_val = int(max(min(val * 24000, 32767), -32768))
        samples.append(int_val)

    with wave.open(os.path.join(AUDIO_DIR, filename), 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        for s in samples:
            wav_file.writeframes(struct.pack('<h', s))

generate_bell("temple_bell.wav")
generate_shankh("shankh_sound.wav")
generate_japa_click("japa_click.wav")
print("Generated audio sound effects successfully.")
