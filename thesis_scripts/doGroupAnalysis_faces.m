function doGroupAnalysis_faces(subjlist_CTR, subjlist_ASD)

    load('/Users/arianalopes/Documents/MATLAB/standards/dkatlas.mat')
    load('/Users/arianalopes/Documents/MATLAB/standards/headmodel_eeg.mat')
    load('/Users/arianalopes/Documents/MATLAB/standards/sourcemodel.mat')
    
    network_int= cell(size(subjlist_CTR));    network_int_ASD= cell(size(subjlist_ASD));
    coh=cell(size(subjlist_CTR));             coh_ASD= cell(size(subjlist_ASD));        
    elec_aligned=cell(size(subjlist_CTR));    elec_aligned_ASD= cell(size(subjlist_ASD));
    lay=cell(size(subjlist_CTR));             lay_ASD= cell(size(subjlist_ASD));
    source_conn=cell(size(subjlist_CTR));  source_conn_ASD=cell(size(subjlist_ASD));

    inputdir_CTR='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_CTR';
    inputdir_ASD='/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD';

    %load the results from disk
    for i=1:numel(subjlist_CTR)
        subj=subjlist_CTR{i};
        fprintf('loading data for subject %s\n', subj);
    
        inputpath_CTR=fullfile(inputdir_CTR,['results_faces_' subj]); %add "_theta_" to run the theta frequencies
        % CTR data
        tmp=load(fullfile(inputpath_CTR,'lay')); lay{i}=tmp.lay;
        tmp=load(fullfile(inputpath_CTR,'elec_aligned')); elec_aligned{i}=tmp.elec_aligned;
        tmp=load(fullfile(inputpath_CTR,'network_int')); network_int{i}=tmp.network_int;
        tmp=load(fullfile(inputpath_CTR,'coh')); coh{i}=tmp.coh;
        tmp=load(fullfile(inputpath_CTR,'source_conn')); source_conn{i}=tmp.source_conn;
        clear tmp
    end

    for i=1:numel(subjlist_ASD)
        subj=subjlist_ASD{i};
        fprintf('loading data for subject %s\n', subj);
    
        inputpath_ASD=fullfile(inputdir_ASD,['results_faces_' subj]); %add "_theta_" to run the theta frequencies
        % ASD data
        tmp=load(fullfile(inputpath_ASD,'lay_ASD')); lay_ASD{i}=tmp.lay_ASD;
        tmp=load(fullfile(inputpath_ASD,'elec_aligned_ASD')); elec_aligned_ASD{i}=tmp.elec_aligned_ASD;
        tmp=load(fullfile(inputpath_ASD,'network_int_ASD')); network_int_ASD{i}=tmp.network_int_ASD;
        tmp=load(fullfile(inputpath_ASD,'coh_ASD')); coh_ASD{i}=tmp.coh_ASD;
        tmp=load(fullfile(inputpath_ASD,'source_conn_ASD')); source_conn_ASD{i}=tmp.source_conn_ASD;
        clear tmp
    end

    
    %% Average of the location of the elctrodes -> sensor_layoutpower2D
    avglay=lay{1};
    for i=2:numel(lay)
        avglay.pos = avglay.pos + lay{i}.pos;
    end
    avglay.pos=avglay.pos/numel(lay); %perform medium of the data to extract the group results
    
    figure()
    title('Localization of electros in the heas 2D configuration');
    ft_plot_layout(avglay) 

    %% Average of the electromagnetic expected distribution -> sensor_electrodestandardhead (elec_aligned)
    avgelec_aligned=elec_aligned{1};
    for i=2:numel(elec_aligned)
        avgelec_aligned.elecpos = avgelec_aligned.elecpos + elec_aligned{i}.elecpos;
    end
    avgelec_aligned.elecpos=avgelec_aligned.elecpos/numel(elec_aligned);

    figure();
    nLabels     = length(dkatlas.tissuelabel);
    colr        = parula(nLabels);
    vertexcolor = ones(size(dkatlas.pos,1), 3);
    for i = 1:length(dkatlas.tissuelabel)
        index = find(dkatlas.tissue==i);
       if ~isempty(index)
          vertexcolor(index,:) = repmat(colr(i,:),  length(index), 1);
       end   
    end
    
    title('Electomagnetic expected distribution for scalp potentials - CTR');
    ft_plot_headmodel(headmodel_eeg, 'edgecolor', 'none','facecolor', 'black'); alpha 0.1
    ft_plot_mesh(dkatlas, 'facecolor', 'brain',  'vertexcolor', vertexcolor, 'facealpha', .5);
    ft_plot_sens(avgelec_aligned);
    view([0 -90 0])

    avgelec_aligned_ASD=elec_aligned_ASD{1};
    for i=2:numel(elec_aligned_ASD)
        avgelec_aligned_ASD.elecpos = avgelec_aligned_ASD.elecpos + elec_aligned_ASD{i}.elecpos;
    end
    avgelec_aligned_ASD.elecpos=avgelec_aligned_ASD.elecpos/numel(elec_aligned_ASD);

    figure();
    nLabels     = length(dkatlas.tissuelabel);
    colr        = parula(nLabels);
    vertexcolor = ones(size(dkatlas.pos,1), 3);
    for i = 1:length(dkatlas.tissuelabel)
        index = find(dkatlas.tissue==i);
       if ~isempty(index)
          vertexcolor(index,:) = repmat(colr(i,:),  length(index), 1);
       end   
    end
    
    title('Electomagnetic expected distribution for scalp potentials - ASD');
    ft_plot_headmodel(headmodel_eeg, 'edgecolor', 'none','facecolor', 'black'); alpha 0.1
    ft_plot_mesh(dkatlas, 'facecolor', 'brain',  'vertexcolor', vertexcolor, 'facealpha', .5);
    ft_plot_sens(avgelec_aligned_ASD);
    view([0 -90 0])

    %% Average of the source connectivity for CTR and ASD and difference between the groups -> source_connectivityanalysis (network_int)
    avgnetwork_int=network_int{1};
    for i=2:numel(network_int)
        avgnetwork_int.degrees = avgnetwork_int.degrees + network_int{i}.degrees;
    end
    avgnetwork_int.degrees=avgnetwork_int.degrees/numel(network_int);

    cfg              = [];
    cfg.method       = 'surface';
    cfg.funparameter = 'degrees';
    cfg.colorbar     = 'yes';
    figure();
    ft_sourceplot(cfg, avgnetwork_int);
    title('Source Connectivity: control group');
    view([-90 30]);
    light('style','infinite','position',[0 -200 200]);
    %caxis([0 100]); define the best value for comparision purpose 
    colorbar 
    material dull
    set(gcf,'color','w'); 
    
    avgnetwork_int_ASD=network_int_ASD{1};
    for i=2:numel(network_int_ASD)
        avgnetwork_int_ASD.degrees = avgnetwork_int_ASD.degrees + network_int_ASD{i}.degrees;
    end
    avgnetwork_int_ASD.degrees=avgnetwork_int_ASD.degrees/numel(network_int_ASD);

    cfg              = [];
    cfg.method       = 'surface';
    cfg.funparameter = 'degrees';
    cfg.colorbar     = 'yes';
    figure();
    ft_sourceplot(cfg, avgnetwork_int_ASD);
    title('Source Connectivity: ASD group');
    view([-90 30]);
    light('style','infinite','position',[0 -200 200]);
    %caxis([0 100]); define the best value for comparision purpose
    colorbar 
    material dull
    set(gcf,'color','w'); 

    
  %% Average of coh (coherence) for sensor connectivity, difference between ASD and CTR for nofaces -> sensor_connectivitystudies (coh)   

    avgcoh=coh{1};
    for i=2:numel(coh)
        avgcoh.cohspctrm = avgcoh.cohspctrm + coh{i}.cohspctrm;
    end
    avgcoh.cohspctrm=avgcoh.cohspctrm/numel(coh);
    
    avgcoh_ASD=coh_ASD{2};
    for i=3:numel(coh_ASD)
        avgcoh_ASD.cohspctrm = avgcoh_ASD.cohspctrm + coh_ASD{i}.cohspctrm;
    end
    avgcoh_ASD.cohspctrm=avgcoh_ASD.cohspctrm/numel(coh_ASD);
    
    % Aqui executo no gráfico as linhas para ASD e CTR na face recognition
    cfg=[];
    cfg.parameter='cohspctrm';
    cfg.complex = 'absimag';
     %In this case, all channels are intended to be used, but we can choose
    %only to performe studies with some of them
    cfg.channel={'AF3','AF4','AF7','C1','C2','C3','C4','C5','C6','CP1','CP2','CP3','CP4','CP5','CP6','CPz','Cz','F1','F2','F3','F4','F5','F6','F7','F8','FC1','FC2','FC3','FC4','FC5','FC6','FT10','FT7','FT8','FT9','Fz','O1','O2','Oz','P1','P2','P3','P4','P5','P6','P7','P8','PO3','PO4','PO7','PO8','POz','Pz','T7','T8','TP7','TP8'};
    cfg.xlim=[2 20];
    cfg.zlim=[0 0.2];
    figure();
    xlabel('Frequency'); ylabel('Imaginary Coherence');
    ft_connectivityplot(cfg,avgcoh,avgcoh_ASD);
    %title('sensor connectivity');   

%% save the results to the disk

 outputdir='results_Group_faces'; %add "_theta_"
 mkdir(outputdir)
 save(fullfile(outputdir,'avgnetwork_int'),'avgnetwork_int');
 save(fullfile(outputdir,'avgnetwork_int_ASD'),'avgnetwork_int_ASD');
 save(fullfile(outputdir,'avgcoh'),'avgcoh');
 save(fullfile(outputdir,'avgcoh_ASD'),'avgcoh_ASD');
 save(fullfile(outputdir,'avgelec_aligned'),'avgelec_aligned');
 save(fullfile(outputdir,'avgelec_aligned_ASD'),'avgelec_aligned_ASD');
 save(fullfile(outputdir,'avglay'),'avglay');

end