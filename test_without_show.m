clear;

% Load the original wav file
[original,fs] = audioread('modulatedSong_noisy.wav');

Time = length(original)/fs; % get the time of the wav file
length = length(original);  % get the length of the wav file
oiginal = original - mean(original);
f = fs * (0:2047)/4096;
fft_x = fft(original, 4096); % fast fourier transform
magX = abs(fft_x); % calculate the amplitude of fft wav
%figure(1);
%freqz(original);
%plot(f,(magX(1:2048)));
% design the buttord filter of the 45kHz song 
% frequence_first_song = 65000;
% fp_range = [63000,67000];
% fs_range = [60000,70000];
frequence_first_song = 45000;
fp_range = [43000,47000];
fs_range = [41000,49000];
Rp = 4;
Rs = 30;
Wp = fp_range/(fs/2);
Ws = fs_range/(fs/2);
[n, Wn] = buttord(Wp,Ws,Rp,Rs);
[b,a] = butter(n,Wn);
disp(n);

[H,F] = freqz(b,a,4096,fs);
figure(2);
plot(F, 20*log10(abs(H)));
% signal through the buttord filter
output_first_song = filter(b,a,original);
%sound(output_first_song, fs);
audiowrite('kHz.wav',output_first_song,fs);

n=0:length-1;
cos_signal = cos(n * 2 * pi * 45000 / fs); % 45kHz”‡œ“–≈∫≈
middle_original = output_first_song .* cos_signal';
middle_original = middle_original - mean(middle_original);
fft1 = fft(middle_original, 4096);
magout = abs(fft1);
f = fs * (0:2047)/4096;
figure(3);
freqz(middle_original);
figure(4);
plot(f,magout(1:2048));

% design µÕÕ®¬À≤®∆˜
fp = 6000;
fss = 8000;
Rp = 4;
Rs = 30;
Wp = fp / (fs / 2);
Ws = fss / (fs / 2);
[n, Wn] = buttord(Wp, Ws, Rp, Rs);
disp(n);
[b, a] = butter(n,Wn);
disp(b);
[H, F] = freqz(b,a,1000,fs);
figure(5);
plot(F, 20*log10(abs(H)));
output_song = filter(b,a,middle_original);
fft2 = fft(output_song, 4096);
magout = abs(fft2);
f = fs * (0:2047)/4096;
figure(6);
freqz(output_song);
figure(7);
plot(f,magout(1:2048));
sound(output_song,fs);
audiowrite('45kHz_song.wav',output_song,fs);