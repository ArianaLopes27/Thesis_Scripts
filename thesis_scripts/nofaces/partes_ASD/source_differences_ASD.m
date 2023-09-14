%% Source reconstruction of ‘low’ and ‘high’ alpha activity epochs

% compute fourier spectra for frequency of interest according to the trial split
cfg            = [];
cfg.method     = 'mtmfft';
cfg.output     = 'fourier';
cfg.keeptrials = 'yes';
cfg.tapsmofrq  = 1;
cfg.foi        = 10;  %10 alpha 6 theta

cfg.trials = indlow;
freq_low   = ft_freqanalysis(cfg, subj1);

cfg.trials = indhigh;
freq_high  = ft_freqanalysis(cfg, subj1);

% compute the beamformer filters based on the entire data
cfg                   = [];
cfg.frequency         = freq.freq;
cfg.method            = 'pcc';
cfg.sourcemodel       = leadfield;
cfg.headmodel         = headmodel_eeg;
cfg.elec              = elec_aligned_ASD;  
cfg.keeptrials        = 'yes';
cfg.pcc.lambda        = '10%';
cfg.pcc.projectnoise  = 'yes';
cfg.pcc.keepfilter    = 'yes';
cfg.pcc.fixedori      = 'yes';
source = ft_sourceanalysis(cfg, freq);

% use the precomputed filters
cfg                   = [];
cfg.frequency         = freq.freq;
cfg.method            = 'pcc';
cfg.sourcemodel       = leadfield;
cfg.sourcemodel.filter = source.avg.filter;
cfg.headmodel         = headmodel_eeg;
cfg.elec              = elec_aligned_ASD; 
cfg.keeptrials        = 'yes';
cfg.pcc.lambda        = '10%';
cfg.pcc.projectnoise  = 'yes';
source_low  = ft_sourcedescriptives([], ft_sourceanalysis(cfg, freq_low));
source_high = ft_sourcedescriptives([], ft_sourceanalysis(cfg, freq_high));

cfg           = [];
cfg.operation = 'log10(x1)-log10(x2)';
cfg.parameter = 'pow';
source_ratio  = ft_math(cfg, source_high, source_low);

%% visualization of the log-difference on the cortical sheet
cfg           = [];
cfg.parameter = 'pow';
sourceint     = ft_sourceinterpolate(cfg, source_ratio, dkatlas);
sourceint1_ASD     = ft_sourceparcellate([], sourceint, dkatlas);
cfg              = [];
cfg.method       = 'surface';
cfg.funparameter = 'pow';
cfg.colorbar     = 'no';
cfg.funcolormap  = '*RdBu';
figure(8);
ft_sourceplot(cfg, sourceint1_ASD); 
view([-90 30]);
light('style','infinite','position',[0 -200 200]);
colorbar off
material dull
set(gcf,'color','w');

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/nofaces/partes_ASD';
outputdir=fullfile(output,['results_nofaces_' subjASD]);
mkdir(outputdir)
save(fullfile(outputdir,'sourceint1_ASD'),'sourceint1_ASD'); 