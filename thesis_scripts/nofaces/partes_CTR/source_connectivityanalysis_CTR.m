%% 3 parte- Connectivity analysis and parcellation

% compute connectivity 
cfg         = [];
cfg.method  ='coh';
cfg.complex = 'absimag';
source_conn = ft_connectivityanalysis(cfg, source); 

% parcellation and network analysis
cfg=[];
cfg.method='degrees';
cfg.parameter='cohspctrm';
cfg.threshold=.1
network_full  = ft_networkanalysis(cfg,source_conn);  

% sourceinterpolate
cfg           = [];
cfg.parameter = 'degrees';
network_int   = ft_sourceinterpolate(cfg, network_full, dkatlas);
network_int   = ft_sourceparcellate([], network_int, dkatlas);  

% create a fancy mask
cfg              = [];
cfg.method       = 'surface';
cfg.funparameter = 'degrees';
cfg.colorbar     = 'no';
figure(10);
ft_sourceplot(cfg, network_int);  
view([-90 30]);
light('style','infinite','position',[0 -200 200]);
colorbar off
material dull
set(gcf,'color','w');

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/nofaces/partes_CTR';
outputdir=fullfile(output,['results_nofaces_' subjCTR]);
mkdir(outputdir)
save(fullfile(outputdir,'source_conn'),'source_conn');  
save(fullfile(outputdir,'network_int'),'network_int'); 