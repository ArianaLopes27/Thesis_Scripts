%% creation of a 'pseudo-contrast' based on a median split of the epochs

%in this script it is implemented the visualization if activity contrasts
%like line basis vs activation intervals, whose intention is only to make
%sure that the beamformer formation are well executed. To do so, it is
%created an experimental contrast, using a division of the data from high
%and low alpha (based on occipital alpha power). 
% It is used a line of basis (in case of no stimulus) and the stimulus
% itself, to see the differences


% compute sensor level single trial power spectra
cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foilim       =  [9 11];  % [9 11] for alpha frequency run and [5 7] for theta frequency run
cfg.tapsmofrq    = 1;
cfg.keeptrials   = 'yes';
datapow          = ft_freqanalysis(cfg, subj1);  
cfg.foilim       = [3 40];
datapowfull      = ft_freqanalysis(cfg, subj1);

% identify the indices of trials with high and low alpha power
freqind = nearest(datapow.freq, 10);   %use 10 in alpha frequency run and 6 when in theta frequency run
tmp     = datapow.powspctrm(:,:,freqind);  
chanind = find(mean(tmp,1)==max(mean(tmp,1)));  % find the sensor where power is max
indlow  = find(tmp(:,chanind)<=median(tmp(:,chanind)));
indhigh = find(tmp(:,chanind)>=median(tmp(:,chanind)));

%% compute the power spectrum for the median splitted data
cfg              = [];
cfg.trials       = indlow;
datapow_low      = ft_freqdescriptives(cfg, datapowfull); 

cfg.trials       = indhigh;
datapow_high     = ft_freqdescriptives(cfg, datapowfull); 

%% compute the difference between high and low
cfg = [];
cfg.parameter = 'powspctrm';
cfg.operation = 'divide';
powratio      = ft_math(cfg, datapow_high, datapow_low); 

%% plot the topography of the difference along with the spectra

cfg        = [];
cfg.layout = lay;   
cfg.xlim   = [9.9 10.1];  %[9.9 10.1] for alpha frequency run and [5.9 6.1] for theta frequency run
figure(7);
ft_topoplotER(cfg, powratio); 

figure(8)
cfg         = [];
cfg.channel = {'P6', 'PO8'};
ft_singleplotER(cfg, datapow_high, datapow_low); 

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); %add "_theta_"
mkdir(outputdir)
save(fullfile(outputdir,'powratio'),'powratio');  
save(fullfile(outputdir, 'datapow_high'),'datapow_high');  
save(fullfile(outputdir, 'datapow_low'),'datapow_low');  
