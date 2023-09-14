%% creation of a 'pseudo-contrast' based on a median split of the epochs

% compute sensor level single trial power spectra
cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.foilim       =  [9 11];  %[9 11] alpha  [5 7] theta
cfg.tapsmofrq    = 1;
cfg.keeptrials   = 'yes';
datapow          = ft_freqanalysis(cfg, subj1);  
cfg.foilim       = [3 40];
datapowfull      = ft_freqanalysis(cfg, subj1);

% identify the indices of trials with high and low alpha power
freqind = nearest(datapow.freq, 10); %theta 10 alpha 6  theta
tmp     = datapow.powspctrm(:,:,freqind);  
chanind = find(mean(tmp,1)==max(mean(tmp,1)));  % find the sensor where power is max
indlow  = find(tmp(:,chanind)<=median(tmp(:,chanind)));
indhigh = find(tmp(:,chanind)>=median(tmp(:,chanind)));

%% compute the power spectrum for the median splitted data
cfg              = [];
cfg.trials       = indlow;
datapow_low_ASD      = ft_freqdescriptives(cfg, datapowfull); 

cfg.trials       = indhigh;
datapow_high_ASD     = ft_freqdescriptives(cfg, datapowfull);

%% compute the difference between high and low
cfg = [];
cfg.parameter = 'powspctrm';
cfg.operation = 'divide';
powratio_ASD      = ft_math(cfg, datapow_high_ASD, datapow_low_ASD);

%% plot the topography of the difference along with the spectra

cfg        = [];
cfg.layout = lay_ASD;  
cfg.xlim   = [9.9 10.1];  %[9.9 10.1] alpha [5.9 6.1] theta
figure(7);
ft_topoplotER(cfg, powratio_ASD);   

figure(8)
cfg         = [];
cfg.channel = {'P6', 'PO8'};
ft_singleplotER(cfg, datapow_high_ASD, datapow_low_ASD); 

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD';
outputdir=fullfile(output,['results_faces_' subjASD]);
mkdir(outputdir)
save(fullfile(outputdir,'powratio_ASD'),'powratio_ASD'); 
save(fullfile(outputdir, 'datapow_high_ASD'),'datapow_high_ASD'); 
save(fullfile(outputdir, 'datapow_low_ASD'),'datapow_low_ASD'); 
