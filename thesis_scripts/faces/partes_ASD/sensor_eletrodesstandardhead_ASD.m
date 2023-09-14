%% visualização com eletrodos alinhados 
% With rotation

cfg=[];
cfg.method='interactive'; 
cfg.headshape=headmodel_eeg.bnd(1);
cfg.elec=elec2; 
elec_aligned_ASD=ft_electroderealign(cfg); %makes sure the aligned electrodes are updated
data.elec=elec_aligned_ASD;  %theta

% visualize the coregistration of electrodes, headmodel, and sourcemodel.

figure(5);
% create colormap to plot parcels in different color
nLabels     = length(dkatlas.tissuelabel);
colr        = parula(nLabels);
vertexcolor = ones(size(dkatlas.pos,1), 3);
for i = 1:length(dkatlas.tissuelabel)
    index = find(dkatlas.tissue==i);
   if ~isempty(index)
      vertexcolor(index,:) = repmat(colr(i,:),  length(index), 1);
   end   
end

% make the headmodel surface transparent
ft_plot_headmodel(headmodel_eeg, 'edgecolor', 'none','facecolor', 'black'); alpha 0.1
ft_plot_mesh(dkatlas, 'facecolor', 'brain',  'vertexcolor', vertexcolor, 'facealpha', .5);
ft_plot_sens(elec_aligned_ASD);  
view([0 -90 0])

%% Save data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD';
outputdir=fullfile(output,['results_faces_' subjASD]);
mkdir(outputdir);
save(fullfile(outputdir,'elec_aligned_ASD'),'elec_aligned_ASD'); 

