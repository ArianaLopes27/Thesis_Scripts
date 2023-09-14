%% visualização dos eletrodos alinhados 
% using rotation and other functions

%in this section the leadfield matriz is removed, which means that with the
%electrodes exact colocation, it is possible to acquire the electromagnetic
%signals from the electrodes (defining the the expectable eletromagnetic distribution)

%here the electrodes were placed in a standard head and different values
%were atributed so that they could fit well (0 0 0/1 0.9 1/4 1 50)
cfg=[];
cfg.method='interactive'; 
cfg.headshape=headmodel_eeg.bnd(1);
cfg.elec=elec2; 
elec_aligned=ft_electroderealign(cfg); %makes sure the aligned electrodes are updated
data.elec=elec_aligned; 

% visualize the coregistration of electrodes, headmodel, and sourcemodel
% gather all the components into one head
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
ft_plot_sens(elec_aligned); 
view([0 -90 0])

%% save the data
output='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
outputdir=fullfile(output,['results_faces_' subjCTR]); %add "_theta_"
mkdir(outputdir);
save(fullfile(outputdir,'elec_aligned'),'elec_aligned');  