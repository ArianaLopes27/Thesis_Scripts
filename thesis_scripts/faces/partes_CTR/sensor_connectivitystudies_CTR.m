%% Connectivity studies

% Non-parametric computation of the cross-sprectral density matrix

cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 2;
freq          = ft_freqanalysis(cfg, subj1);

%% Computation and inspection of the connectivity measures
% In this section Fourier transforms are used to convert the signal from time to frequency domain
% Implementation of imaginary coherence for the study of sensor
% connectivity
cfg=[];
cfg.method='coh';
cfg.complex='absimag';
coh=ft_connectivityanalysis(cfg,freq); 

cfg=[];
cfg.parameter='cohspctrm';
cfg.channel={'P5','P6','PO7','PO8','Pz'};
cfg.xlim=[0 80];
cfg.zlim=[0 1];

figure()
ft_connectivityplot(cfg,coh); 

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); % add "_theta_"
mkdir(outputdir)
save(fullfile(outputdir,'coh'),'coh'); 
