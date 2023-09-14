%% prepare layout and construct a 2D configuration


% select EEG electrodes only
cfg         = [];
cfg.channel = elec2.label;
data        = ft_selectdata(cfg,EEG);
data        = rmfield(data,'chanlocs');
cfg         = [];
cfg.elec    = elec2;
layout      = ft_prepare_layout(cfg);

% % scale the layout to fit the head outline
lay         =layout;  
lay.pos     =layout.pos./.7;
lay.pos(:,1)=layout.pos(:,1)./.9;
lay.pos(:,2)=layout.pos(:,2)+ 0.015;   
lay.pos(:,2)=lay.pos(:,2)./.7;

figure(1);
ft_plot_layout(lay) 

% compute the power spectrum

cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.keeptrials   = 'no';
datapow          = ft_freqanalysis(cfg, subj1);  

figure(2);
cfg             = [];
cfg.layout      = lay;  
cfg.xlim        = [9 11]; % [9 11] alpha, [5 7] theta
cfg.marker = 'on';
ft_topoplotER(cfg, datapow);   

figure(3);
cfg             = [];
cfg.channel     = {'P6', 'PO6'};
cfg.xlim        = [3 30];
ft_singleplotER(cfg, datapow); 


%% save the results to the disk
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/nofaces/partes_CTR';
outputdir=fullfile(output,['results_nofaces_' subjCTR]);
mkdir(outputdir)
save(fullfile(outputdir,'lay'),'lay'); 
save(fullfile(outputdir,'datapow'),'datapow');  
