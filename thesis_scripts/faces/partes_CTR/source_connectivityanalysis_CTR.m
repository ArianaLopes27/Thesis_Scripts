%% Connectivity analysis and parcellation
%Here the connectivity matriz between all the pais of connectomes (dipoles)
%is executed. It is used the imaginary coherence of the data, this way the
%random coherence from the eletromagnetic campus is supressed. Imaginary
%part is considered to be a more robust indicator of the real neuronal
%connectivity

% compute connectivity 
cfg         = [];
cfg.method  ='coh';
cfg.complex = 'absimag';
source_conn = ft_connectivityanalysis(cfg, source);  %theta

% parcellation and network analysis

cfg=[];
cfg.method='degrees';
cfg.parameter='cohspctrm';
cfg.threshold=.1 %this theresold indicated, results from the "node degree" estimation, which
%means the quantity of noddes with which one nodee has an estimated
%connectivity of 0.1 or more
network_full  = ft_networkanalysis(cfg,source_conn);  %theta

% sourceinterpolate
cfg           = [];
cfg.parameter = 'degrees';
network_int   = ft_sourceinterpolate(cfg, network_full, dkatlas);
network_int   = ft_sourceparcellate([], network_int, dkatlas); 

% creation of a fancy mask
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
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); %add "_theta_"
mkdir(outputdir)
save(fullfile(outputdir,'source_conn'),'source_conn'); 
save(fullfile(outputdir,'network_int'),'network_int'); 