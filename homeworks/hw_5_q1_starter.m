% function get_peaks_and_synthesize(user)

% Copyright Tom Collins 20/2/2024

% Compute spectrogram peaks for a directory of audio files.

% Requires
addpath('./../FastPeakFind');

% Individual user paths
if strcmp(user, 'tom')
  inDir = fullfile('/Users', 'tomthecollins', 'Shizz',...
    'UMiami', 'Teaching', '511-611', 'spring24', 'homeworks',...
    'hw_2', 'music_data', 'small_dir_audio');
  outDir = fullfile('/Users', 'tomthecollins', 'Shizz',...
     'UMiami', 'Teaching', '511-611', 'spring24', 'homeworks',...
     'hw_5', 'matlab_out', 'q1');
elseif strcmp(user, 'anotherUser')
  % inDir = ...
  % outDir = ...
end

% Parameters
nfft = 1024;
win = hann(nfft);
overlap = 7*nfft/8; % 87.5% overlap between adjacent spectra.
% step = nfft - overlap;
% Given above params, this value of nrows would mean the analysis considers
% frequency components in the range 0-10.8 kHz (=500*44100/1024)
nrows = 250;
% A value will have to be in the top 5% of magnitude spectra values to
% even be considered a peak.
threshParam = 0.95;

% Import and analyse the audio files.
% Obtain details of all the WAV and MP3 files in inDir.
inWavs = fullfile(inDir, '*.wav');
inMp3s = fullfile(inDir, '*.mp3');
fnams = [dir(inWavs); dir(inMp3s)];
naud = length(fnams);

% Iterate.
for i=1:naud
  fprintf('Processing file %d of %d.\n', i, naud);
  % Import audio file.
  [sig, Fs] = audioread(fullfile(fnams(i).folder, fnams(i).name));
  % Spectrogram
  % Just left channel. Could do both or take the mean instead.
  % [s, w, t] = spectrogram(sig(:, 1), win, overlap, nfft);
  % sa = abs(s(1:nrows, :));
  % Alternative with stft()
  [u, f, ta] = stft(...
    sig(:, 1), Fs, Window = win, OverlapLength = overlap, FFTLength = nfft...
  );
  ua = abs(u(nfft/2:nfft/2 + nrows - 1, :));
  f = f(nfft/2:nfft/2 + nrows - 1);

  % Show spectrogram.
  close all; imagesc(-ua); colormap 'gray'; axis xy
  xlabel('Time (Spectrogram Increment)', 'FontSize', 18);
  ylabel('Frequency (Spectrogram Increment)', 'FontSize', 18);

  % Pick peaks.
  thresh = quantile(ua(:), threshParam);
  %% YOU COME IN HERE! %%
  % Use FastPeakFind().

  % Plot/visualize.
  hold on; plot(J, I, 'r+'); hold off;

  % Synthesize an audio file based on the extracted peaks.
  y = zeros(size(sig, 1), 1);
  t = (0:round(Fs*0.02))'/Fs;
  for j=1:length(J)
    % currTime = ...;
    % cts = ...; % Short for current time sample.
    % currFreq = ...;
    % currAmp = ...;
    % sineChunk = currAmp*sin(2*pi*currFreq*t);
    % y(cts:cts + length(t) - 1) = y(cts:cts + length(t) - 1) + sineChunk;
  end
  y = 0.8*y/max(abs(y)); % Normalize to [-.8, .8].
  fnams(i).peaks = [I, J]; % Store the peak locations.

  % Write output to file.
  audiowrite(fullfile(outDir, fnams(i).name), y, Fs);
  outfnam = fullfile(outDir, [fnams(i).name '.json']);
  fid = fopen(outfnam, 'w');
  encodedJson = jsonencode(fnams(i));
  fprintf(fid, encodedJson);
  % fprintf(fid, '%d', [1, 2]);
  fclose(fid);
end
