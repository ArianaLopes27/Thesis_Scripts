%% Connectivity studies

%Non-parametric computation of the cross-sprectral density matrix

cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'dpss';
cfg.output    = 'fourier';
cfg.tapsmofrq = 2;
freq          = ft_freqanalysis(cfg, subj1);

%%
%Computation and inspection of the connectivity measures
    
cfg=[];
cfg.method='coh';
cfg.complex='absimag';
coh_ASD=ft_connectivityanalysis(cfg,freq);

cfg=[];
cfg.parameter='cohspctrm';
cfg.channel={'P5','P6','PO7','PO8','Pz'};
cfg.xlim=[0 80];
cfg.zlim=[0 1];

figure()
ft_connectivityplot(cfg,coh_ASD); 

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/nofaces/partes_ASD';
outputdir=fullfile(output,['results_nofaces_' subjASD]);
mkdir(outputdir)
save(fullfile(outputdir,'coh_ASD'),'coh_ASD');  
