clear
close all

subjlist_CTR = {'PAC104','PAC103','PAC101','PAC100','PAC035','PAC034','PAC033','PAC032','PAC031','PAC030','PAC029','PAC027','PAC026','PAC025','PAC023','PAC022','PAC021','PAC020'};%,'PAC019','PAC018','PAC017','PAC016','PAC015','PAC014','PAC013','PAC012','PAC011','PAC009','PAC008','PAC007'};

subjlist_ASD = {'PEA001','PEA003','PEA004','PEA005','PEA006','PEA007','PEA008','PEA009','PEA010','PEA011','PEA012','PEA014','PEA015','PEA016','PEA018','PEA019','PEA020','PEA021'}; 

%% Loop single-subject analyses over subjects ->FACES
for i = 1:numel(subjlist_CTR)
    subjCTR= subjlist_CTR{i};
    doSingleSubjectAnalysisCTR_FACES(subjCTR); 
end
%%
for i = 1:numel(subjlist_ASD) 
    subjASD = subjlist_ASD{i};
    doSingleSubjectAnalysisASD_FACES(subjASD);
end

%% Loop single-subject analyses over subjects ->NO FACES
for i = 1:numel(subjlist_CTR)
    subjCTR= subjlist_CTR{i};
    doSingleSubjectAnalysisCTR_NOFACES(subjCTR);
end
%%
for i = 1:numel(subjlist_ASD)
    subjASD = subjlist_ASD{i};
    doSingleSubjectAnalysisASD_NOFACES(subjASD);
end

%% Group analysis
doGroupAnalysis_faces(subjlist_CTR, subjlist_ASD);

%%
doGroupAnalysis_nofaces(subjlist_CTR, subjlist_ASD);

