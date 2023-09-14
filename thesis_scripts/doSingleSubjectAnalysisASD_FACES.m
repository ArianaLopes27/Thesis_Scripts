function doSingleSubjectAnalysisASD_FACES (subjASD)
    
    fprintf('evaluating single subject analysis for %s\n', subjASD);
    filename=[num2str(subjASD) '_FACES.set'];
    EEG = pop_loadset(filename); 
    subj1 = eeglab2fieldtrip(EEG, 'raw');
    
    %%
    
    elec2 = ft_read_sens([subjASD '_FACES.set']);
    elec2=ft_convert_units(elec2,'mm');
    
    % select EEG electrodes only
    cfg         = [];
    cfg.channel = elec2.label;
    data        = ft_selectdata(cfg,EEG);
    data        = rmfield(data,'chanlocs');
    
    %% load the required geometrical information
    load('/Users/arianalopes/Documents/MATLAB/standards/dkatlas.mat')
    load('/Users/arianalopes/Documents/MATLAB/standards/headmodel_eeg.mat')
    load('/Users/arianalopes/Documents/MATLAB/standards/sourcemodel.mat')
    
    
     %It is important to refer that the paths defined in this part have to
    %be changed in case of running by another user

    %% Sensor Analysis
    % analysis of the results acquired from the scalp, with reconstruction of
    % the electrodes localization are made based on different brain waves frequencies
    
    %% eletrode layout plotting (57 eletrodes) and spectral analysis/peak picking
     run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/sensor_layoutpower2D_ASD.m');
    
    %% localization of eletrodes in a standard head
     run('//Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/sensor_eletrodesstandardhead_ASD.m');
    
    %% connectivity studies between eletrodes at sensor level
    run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/sensor_connectivitystudies_ASD.m');

    %% Source Analysis
    % analysis of the source of the signal recorded, an attempt of finding the
    % linking between regions of the brain
    
    %% source reconstruction and neural-activity-index (power/noise)
     run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/source_reconstruction_ASD.m');
    
    %% identification of indices of trials with high and low frequency power and plot 
     run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/source_alpha_ASD.m');
    
    %% source reconstruction of low and high frequency activity epochs and plot
     run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/source_differences_ASD.m');
    
    
    %% Network Analysis
    % connectivity analysis between all pairs of dipoles (connectomes), using
    % the computation of the imaginary part of coherency
    
     run('/Users/arianalopes/Documents/MATLAB/DADOS FEITOS/estudos_grupo/faces/partes_ASD/source_connectivityanalysis_ASD.m');

end