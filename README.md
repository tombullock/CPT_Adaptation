# Habituation of the Stress Response Multiplex to Repeated Cold Pressor Exposure

Insert paper details and abstract here when accepted!

This repository contains scripts for analyzing the preprocessed CPT_Adapatation EEG data.  

The data are available upon here:[INSERT BOX LINK - Upload RAW Physio Data]

This project typically lives in: /home/bullock/BOSS/CPT_Adaptation [can transfer to /work when complete]

## Script Authors: 

Tom Bullock, Attention Lab, UCSB 

Neil Dundon, Action Lab, UCSB

Repository last updated: 12.03.22 (Tom Bullock)

## Notes

Tom reran EEG analyses in Dec 2022.  In folder on BIC cluster called EEG_RERUN + all dirs in EEG scripts point here not original folders.  




## GENERAL

`CPT_SUBJECTS.m` List of valid CPT subjects for each measure, with notes


## CORTISOL

`CORT_Plot.m` Plot cortisol results averaged across time of day (TOD)

`CORT_Stats_Resample.m` Generate resampled stats for results averaged across TOD

`CORT_Plot_Split_TOD.m` Plot cortisol results split by AM/PM session

`CORT_Stats_Resample_TOD.m` Generate resampled stats plit by AM/PM session


## DEMOGRAPHICS

`DEMOGRAPHICS_Get_Info.m` Extract demographic info 

`DEMOGRAPHICS_Get_Info_Additional.m` Extract additional demographic info (income etc.) to address a reviewer comment


## EEG

### Run preprocessing scripts to recover a few missing event codes.  These scripts are on BOSS cluster.  

`EEG_Prepro_Wrapper.m`

`EEG_process_CPT_New.m`

`EEG_Recover_CPT_Triggers_From_EYE.m`


### Move EEG data from BOSS MASTER structure to `EEG_CPT_Prepro` directory on BIC cluster.  Now preprocess and run ICA.

`EEG_Clean_For_ICA.m` +job Clean data in prep for ICA (for broadband muscle noise analysis set analysisType=0, for main ICA analyses set analysisType=1)

`EEG_AMICA.m` +job Run ICA on data

`EEG_Dipfit.m' +job Do dipole fitting in ICA data


### Run Time Frequency Analyses [CLEAN UP AND RE-RUN THESE SCRIPTS]

`EEG_TFA_Generate_ERSPs.m` +job generates ERSPS for anticipatory (no baseline corr) and stress response (baseline corr)

`EEG_TFA_Compile_ERSPs.m` Compiles ERSPs into a single matrix [need to adjust all the analysis type stuff here - correct but inconsistent]

`EEG_TFA_Stats_Resample_ERSP_Anticipatory.m` +job Run resampled ERSP data for anticipatory (baseline) period only

`EEG_TFA_Plot_Topos_ERSPS_Anticipatory.m` Plots topos for anticipatory activity (averages ERSPs over freq bands and baseline period)

`EEG_TFA_Stats_Resample_ERSP_Response.m` +job Run resampled ERSP data for response activity (averages ERSPs over freq bands and early/mid/late/rec phases)

`EEG_TFA_Plot_Topos_ERSPS_Response.m` Plots topos for stress response activity (averages ERSPs over freq bands and early/mid/late/rec phases)

`EEG_TFA_Stats_Resample_ERSP_Post_Hocs_Alpha` Run Alpha post-hoc tests for manuscript


### Useful misc EEG scripts.

`EEG_ICLabel_Get_Classification_Stats.m` Get a summary of IC classification across all subjects and conditions.



## PUPILLOMETRY

`EYE_Compile_Pupil.m` Grabs the raw eyelink data (edfs), identifies start/end points and exports data into CPT_EYE_Master.mat. Note this script lives on BOSS cluster.  MOVE master mat over to BIC05. 

`EYE_Stats_Resample.m` +job Runs resampled ANOVAs + pairwise comparisons on pupil size data 

`EYE_Plot_Main_Figs_Analyses.m` Plot Fig 8 pupil size plots w/stats (resampled)

`EYE_Stats_Resample_Averaged_Immersion_Phase.m` Runs resampled ANOVAs on the averaged immersion phase 



## PHYSIO

`PHYSIO_Prepro_Extract_Interpolate_MEAP_Data.m` Extracts data from RAW MEAP files, interpolates/normalizes each measure to 195 s (1 Hz SR).  Note this script normally lives on the BOSS cluster. Generates PHYSIO_MASTER_FINAL.mat on BOSS Cluster which I transfer to BIC05.

`PHYSIO_Stats_Resample.m` +job Run resampled stats analyses

`PHYSIO_Plot_Main_Figs_Analyses.m` Plot Figs 4-7 w/stats

`PHYSIO_Stats_Resample_3way.m` +job Run resampled stats analysis with 3-way ANOVAs for supplemental info

`PHYSIO_Plot_Main_Figs_Analyses_3way.m` Plot Figs with 3-way ANOVA results for supplemental info 

`PHYSIO_Get_Baseline_Data_For_Table.m` Extract "baseline" measures to plot in Table



## SELF REPORT (PAIN)

`SELF_REPORT_Stats_Resample.m` Runs stats on self-reported pain data [don't think we ended up using this coz ANOVA unnecessary given floor fx]

`SELF_REPORT_Plot.m` Plot self-reported pain ratings 



## MISC/DEPENDENCIES

`Demographic_Info.m` Compiles demographic info for presentation

`my_fxcomb.m` Neil's comb filter

`my_fixtrap.m` Neil's trapizoidal filter

`shadedErrorBar.m` Creates exactly that (borrowed)

`simple_mixed_anova.m` Does that (borrowed)
