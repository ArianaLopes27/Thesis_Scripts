%% Preparing the brain more real shape

setenv('PATH', '/Users/arianalopes/Documents/OpenMEEG-2.4.1-MacOSX/bin')
setenv('DYLD_LIBRARY_PATH', '/Users/arianalopes/Documents/OpenMEEG-2.4.1-MacOSX/lib')

system('om_assemble')

cfg         = [];
cfg.elec    = elec_aligned;            
cfg.channel = elec2.label;
cfg.sourcemodel.pos    = sourcemodel.pos;           % 2002v source points over the brain
cfg.sourcemodel.inside = 1:size(sourcemodel.pos,1); % all source points are inside of the brain
cfg.headmodel = headmodel_eeg;                      % volume conduction model
leadfield     = ft_prepare_leadfield(cfg);

%% Source reconstruction and comparison of trials with high and low alpha power

% compute sensor level Fourier spectra, to be used for cross-spectral density computation.
cfg            = [];
cfg.method     = 'mtmfft';
cfg.output     = 'fourier';
cfg.keeptrials = 'yes';
cfg.tapsmofrq  = 1;  
cfg.foi        = 10; %6 for theta analysis, 10 for alpha analysis
freq           = ft_freqanalysis(cfg, subj1);

%% do the source reconstruction - Neural-activity index
cfg                   = [];
cfg.frequency         = freq.freq;
cfg.method            = 'pcc'; % generates Fourier coeficients for every dipole location 
cfg.sourcemodel       = leadfield;
cfg.headmodel         = headmodel_eeg;
cfg.keeptrials        = 'yes';
cfg.pcc.lambda        = '10%';
cfg.pcc.projectnoise  = 'yes';
cfg.pcc.fixedori      = 'yes';
cfg.elec              = elec_aligned;  
source = ft_sourceanalysis(cfg, freq);
source = ft_sourcedescriptives([], source); % to get the neural-activity-index

%% Visualization of the neural-activity-index
% plot the neural activity index (power/noise)

cfg           = [];
cfg.parameter = 'nai';
sourceint     = ft_sourceinterpolate(cfg, source, dkatlas);
sourceint     = ft_sourceparcellate([], sourceint, dkatlas);

%sourceint is responsible to use and calculate the leadfield matrix using
%the method "beamformer" to help estimate the neural activity in spacific
%brain areas. The main ibjective of the "beamformer" is to get a better
%precision of the spatial neural activity stimated, filtereing signals
%captured from the electrodes and giving more enphasis to the interested
%points

%This method relies in specific sensor characteristics as coherence between
%signals to obtain the source location. The covariance matrix represents
%the relation between signals acquired from different sensors.

cfg               = [];
cfg.method        = 'surface';
cfg.funparameter  = 'nai';
cfg.maskparameter = cfg.funparameter;
cfg.opacitymap    = 'rampup';
cfg.colorbar      = 'no';

figure(6);
ft_sourceplot(cfg, sourceint);  
colorbar off
view([-90 30]);
light('Position',[0,-90 30])
material dull
set(gcf,'color','w');

%% save informations
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); %add "_theta_"
mkdir(outputdir)
save(fullfile(outputdir,'sourceint'),'sourceint'); 