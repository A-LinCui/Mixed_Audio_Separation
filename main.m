% Created by Junbo Zhao 2020.1.12 for THU 'Signal and System' Course
% All Rights Reserved for Junbo Zhao
% Nobody is allowed to copy this code without permission
clear;

% Load the original wav file
[original,fs] = audioread('modulatedSong_noisy.wav');
Time = length(original)/fs; % get the time of the wav file
length = length(original);  % get the length of the wav file
f = fs * (0:2047)/4096;

% Draw the original signal time domain waveform
figure(1);
plot(original);
title('Original Signal Time Domain Waveform');
xlabel('Time');
ylabel('Amplitude');
grid on;

% Draw the original signal Frequency Domain waveform
fft_original = fft(original, 4096); % fast fourier transform
abs_fft_original = abs(fft_original); % calculate the amplitude of fft_original wav
figure (2);
plot(f, abs_fft_original (1:2048));
title('Original Signal Frequency Domain Waveform');
xlabel('Frequency/Hz');
ylabel('Amplitude');
grid on;

% 45kHz band pass filter
c_45 = [0.0005,0,-0.0014,0,0.0014,0,-0.0005];
d_45 = [1.0000,0.1824,2.6883,0.3268,2.4144,0.1470,0.7236];
[H_45,F_45] = freqz(c_45,d_45,4096,fs);

% 65kHz band pass filter
b_65 = [4.670669486554073e-03,0, -9.341338973108146e-03,0,4.670669486554073e-03];
a_65 = [1.0000,2.579623390365959,3.465091698701277,2.330009599091112,8.162659773170391e-01];
[H_65,F_65] = freqz(b_65,a_65,4096,fs);

% Draw the amplitude response of the 45kHz filter
figure(3);
plot(F_45, 20*log10(abs(H_45)));
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
title('45kHz Bandpass Filter Amplitude Response');
grid on;

% Draw the phase response of the 45kHz filter
figure(4);
pha = angle(H_45) * 180 / pi;
plot(F_45, pha);
xlabel('Frequency/Hz');
ylabel('Phase');
title('45kHz Bandpass Filter Phase Response');
grid on;

% Draw the amplitude response of the 65kHz filter
figure(5);
plot(F_65, 20*log10(abs(H_65)));
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
title('65kHz Bandpass Filter Amplitude Response');
grid on;

% Draw the phase response of the 65kHz filter
figure(6);
pha = angle(H_65) * 180 / pi;
plot(F_65, pha);
xlabel('Frequency/Hz');
ylabel('Phase');
title('65kHz Bandpass Filter Phase Response');
grid on;

% 45kHz signal through the buttord filter
output_first_song = filter(c_45,d_45,original);

% 65kHz signal through the buttord filter
output_second_song = filter(b_65, a_65,original);

% Draw the 45kHz Signal after Bandpass Filter Frequency Domain waveform
fft_output_first_song = fft(output_first_song, 4096); % fast fourier transform
abs_fft_output_first_song = abs(fft_output_first_song); 
figure (7);
plot(f, abs_fft_output_first_song (1:2048));
title('45kHz Signal after Bandpass Filter Frequency Domain Waveform');
xlabel('Frequency/Hz');
ylabel('Amplitude');
grid on;

% Draw the 65kHz Signal after Bandpass Filter Frequency Domain waveform
fft_output_second_song = fft(output_second_song, 4096); % fast fourier transform
abs_fft_output_second_song = abs(fft_output_second_song); 
figure (8);
plot(f, abs_fft_output_second_song (1:2048));
title('65kHz Signal after Bandpass Filter Frequency Domain Waveform');
xlabel('Frequency/Hz');
ylabel('Amplitude');
grid on;

% Demodulation of the 45kHz signal
n=0:length-1;
cos_signal = cos(n * 2 * pi * 45000 / fs);
middle_original_45 = output_first_song .* cos_signal';
middle_original_45 = middle_original_45 - mean(middle_original_45);

% Demodulation of the 65kHz signal
n=0:length-1;
cos_signal = cos(n * 2 * pi * 65000 / fs);
middle_original_65 = output_second_song .* cos_signal';
middle_original_65 = middle_original_65 - mean(middle_original_65);

% Draw the 45kHz signal time after Demodulation Step One Frequency Waveform
fft_middle_45 = fft (middle_original_45, 4096); % fast fourier transform
abs_fft_middle_45 = abs(fft_middle_45);
figure(9);
plot (f, abs_fft_middle_45 (1:2048));
title ('45kHz Signal after Demodulation Step One Frequency Domain Waveform');
xlabel ('Frequency/Hz');
ylabel ('Amplitude');
grid on;

% Draw the 65kHz signal time after Demodulation Step One Frequency Waveform
fft_middle_65 = fft (middle_original_65, 4096); % fast fourier transform
abs_fft_middle_65 = abs(fft_middle_65);
figure(10);
plot (f, abs_fft_middle_65 (1:2048));
title ('65kHz Signal after Demodulation Step One Frequency Domain Waveform');
xlabel ('Frequency/Hz');
ylabel ('Amplitude');
grid on;

% Design Low Pass Filter for The 45kHz Signal
b_45 = [5.994320231034189e-05, 2.397728092413676e-04, 3.596592138620514e-04, 2.397728092413676e-04, 5.994320231034189e-05];
a_45 = [1.0000, -3.512958673247569, 4.653998866041075, -2.753805161156560, 6.137240596000196e-01];
[H_45, F_45] = freqz(b_45,a_45,1000,fs);

% Design Low Pass Filter for The 65kHz Signal
b_65 = [5.994320231034189e-05, 2.397728092413676e-04, 3.596592138620514e-04, 2.397728092413676e-04, 5.994320231034189e-05];
a_65 = [1.0000, -3.512958673247569, 4.653998866041075, -2.753805161156560, 6.137240596000196e-01];
[H_65, F_65] = freqz(b_65,a_65,1000,fs);

% Draw The Amplitude Response of The 45kHz Lowpass Filter
figure(11);
plot(F_45, 20*log10(abs(H_45)));
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
title('45kHz Lowpass Filter Amplitude Response');
grid on;

% Draw The Phase Response of The 45kHz Lowpass Filter
figure(12);
pha = angle(H_45) * 180 / pi;
plot(F_45, pha);
xlabel('Frequency/Hz');
ylabel('Phase');
title('45kHz Lowpass Filter Phase Response');
grid on;

% Draw The Amplitude Response of The 65kHz Lowpass Filter
figure(13);
plot(F_65, 20*log10(abs(H_65)));
xlabel('Frequency/Hz');
ylabel('Amplitude/dB');
title('65kHz Lowpass Filter Amplitude Response');
grid on;

% Draw The Phase Response of The 65kHz Lowpass Filter
figure(14);
pha = angle(H_65) * 180 / pi;
plot(F_65, pha);
xlabel('Frequency/Hz');
ylabel('Phase');
title('65kHz Lowpass Filter Phase Response');
grid on;

% 45kHz signal through the buttord lowpass filter
output_song_45 = filter(b_45,a_45,middle_original_45);

% 65kHz signal through the buttord lowpass filter
output_song_65 = filter(b_65,a_65,middle_original_65);

% Save The Output Songs
%sound(output_song_45,fs);
sound(output_song_65,fs);
audiowrite('45kHz_song.wav',output_song_45,fs);
audiowrite('65kHz_song.wav',output_song_65,fs);

% Draw The 45kHz Output Song Time Domain Waveform
figure(15);
plot(output_song_45);
title ('Output 45kHz Song Time Domain Waveform');
xlabel ('Time');
ylabel ('Amplitude');
grid on;

% Draw the 45kHz Output Song Frequency Domain Waveform
fft_output_45 = fft (output_song_45, 4096); % fast fourier transform
abs_fft_output_45 = abs(fft_output_45); % calculate the amplitude of fft_original wav
figure (16);
plot (f, abs_fft_output_45 (1:2048));
title ('Output 45kHz Song Frequency Domain Waveform');
xlabel ('Frequency/Hz');
ylabel ('Amplitude');
grid on;

% Draw The 65kHz Output Song Time Domain Waveform
figure(17);
plot(output_song_65);
title ('Output 65kHz Song Time Domain Waveform');
xlabel ('Time');
ylabel ('Amplitude');
grid on;

% Draw the 65kHz Output Song Frequency Domain Waveform
fft_output_65 = fft (output_song_65, 4096); % fast fourier transform
abs_fft_output_65 = abs(fft_output_65); % calculate the amplitude of fft_original wav
figure (18);
plot (f, abs_fft_output_65 (1:2048));
title ('Output 65kHz Song Frequency Domain Waveform');
xlabel ('Frequency/Hz');
ylabel ('Amplitude');
grid on;