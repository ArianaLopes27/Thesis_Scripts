%% 3 parte- Connectivity analysis and parcellation

% compute connectivity 
cfg         = [];
cfg.method  ='coh';
cfg.complex = 'absimag';
source_conn_ASD = ft_connectivityanalysis(cfg, source);  

% parcellation and network analysis

cfg=[];
cfg.method='degrees';
cfg.parameter='cohspctrm';
cfg.threshold=.15
network_full  = ft_networkanalysis(cfg,source_conn_ASD); 

% sourceinterpolate
cfg           = [];
cfg.parameter = 'degrees';
network_int   = ft_sourceinterpolate(cfg, network_full, dkatlas);
network_int_ASD   = ft_sourceparcellate([], network_int, dkatlas);  

% create a fancy mask
cfg              = [];
cfg.method       = 'surface';
cfg.funparameter = 'degrees';
cfg.colorbar     = 'no';
figure(10);
ft_sourceplot(cfg, network_int_ASD);  
view([-90 30]);
light('style','infinite','position',[0 -200 200]);
colorbar off
material dull
set(gcf,'color','w');

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/nofaces/partes_ASD';
outputdir=fullfile(output,['results_nofaces_' subjASD]);
mkdir(outputdir)
save(fullfile(outputdir,'source_conn_ASD'),'source_conn_ASD');
save(fullfile(outputdir,'network_int_ASD'),'network_int_ASD'); 