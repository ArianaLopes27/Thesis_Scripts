%% prepare layout and construct a 2D configuration


% select EEG electrodes only
cfg         = [];
cfg.channel = elec2.label;
data        = ft_selectdata(cfg,EEG);
data        = rmfield(data,'chanlocs');
cfg         = [];
cfg.elec    = elec2;
layout      = ft_prepare_layout(cfg);

%% scale the layout to fit the head outline
lay         =layout;  %adicionar theta quando fizer a análise para a freq theta
lay.pos     =layout.pos./.7;
lay.pos(:,1)=layout.pos(:,1)./.9;
lay.pos(:,2)=layout.pos(:,2)+ 0.015;   
lay.pos(:,2)=lay.pos(:,2)./.7; %theta

%Visualization of the electrodes place in a standard head in 2D
%configuration
figure(1);
ft_plot_layout(lay) %theta

% compute the power spectrum making the average from two occipital
% electrodes
%this part was not used in the results, it was performed only to make sure
%reliable outcomes for source and sensor connectivity studies were obtained
cfg              = [];
cfg.output       = 'pow';
cfg.method       = 'mtmfft';
cfg.taper        = 'hanning';
cfg.keeptrials   = 'no';
datapow          = ft_freqanalysis(cfg, subj1);  

figure(2);
cfg             = [];
cfg.layout      = lay;  %th [9 11] for alpha frequency run and [5 7] for theta frequency run
cfg.marker = 'on';
ft_topoplotER(cfg, datapow);   

figure(3);
cfg             = [];
cfg.channel     = {'P6', 'PO6'};
cfg.xlim        = [3 30];
ft_singleplotER(cfg, datapow); 

%% save the results to the disk
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); % add "_theta_"
mkdir(outputdir)
save(fullfile(outputdir,'lay'),'lay');  
save(fullfile(outputdir,'datapow'),'datapow');   
