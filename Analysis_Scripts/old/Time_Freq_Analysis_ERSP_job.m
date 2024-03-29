%{
Time_Freq_Analysis_ERSP_job
Author: Tom Bullock, UCSB Attention Lab
Date: 10.31.19
%}

clear 
close all

%% run in serial (0) or parallel (1)
runInParallel = 0;

%% select analysis type (0=1-500 Hz no ICA, 1=1-100 Hz no ICA, 2=1-30Hz ICA Reject Occular Arts only, 6=1-50Hz IClabel_DipFit), 7=no baseline correction (for anticipatory only)!
analysisType=6; % EITHER 1 (no ica) or 6 (ICA)-seeother scirpt!

%% set up cluster
if runInParallel  
    cluster=parcluster();
    job = createJob(cluster);
end

%% select subjects
subjects = CPT_SUBJECTS;
%subjects = 155;
disp(['Processing n=' num2str(length(subjects)) ' subjects'])

%% create jobs for subjects
for iSub =1:length(subjects)
    sjNum = subjects(iSub);
    disp(['Processing Subject ' num2str(sjNum)])
    if runInParallel       
        %job.createTask(@Time_Freq_Analysis_ERSP,0,{sjNum,analysisType})       
        createTask(job,@Time_Freq_Analysis_ERSP,0,{sjNum,analysisType})      
    else
        Time_Freq_Analysis_ERSP(sjNum,analysisType)
    end
end
    
%% submit jobs (if running in parallel)
if runInParallel
    submit(job)
    wait(job,'finished');
    results = getAllOutputArguments(job);
end

%% Compile ERSPS
Time_Freq_Analysis_ERSP_Compile(analysisType)
disp('ERSPs COMPILED')

