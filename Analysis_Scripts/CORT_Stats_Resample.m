%{
Cortisol_Stats_Resample
Author: Tom Bullock, UCSB Attention Lab
Date: 12.27.19

%}


clear
close all

% set dirs
sourceDir = '/home/bullock/BOSS/CPT_Adaptation/Data_Compiled';

% add plotting functions to path
addpath(genpath('/home/bullock/matlab_2016b/TOOLBOXES/plotSpread'))

% load data
load([sourceDir '/' 'Cortisol_CPT_Master.mat'])

% load subs list
[~,subjects] = CPT_SUBJECTS
subjects(1)=[]; % get rid of 102;

% apply subs list
subIdx = ismember(cortisol_CPT(:,1)',subjects);
cortisol_CPT(~subIdx,:) = [];

% create observed data mat
observedData = cortisol_CPT(:,4:9);

% name variables
var1_name = 'tx/ct';
var1_levels = 2;
var2_name = 'sample';
var2_levels = 3;

% run ANOVA (iterate 1000 times)
for j=1:1000
    j
    for i=1:size(observedData,1)    % for each row of the observed data
       
        thisPerm = randperm(size(observedData,2)); % shuffle colums for each row
        
        for k=1:length(thisPerm)
            
            nullDataMat(i,k,j) = observedData(i,thisPerm(k));
  
        end
        
    end
    
    % do ANOVA on permuted data for each new iteration
    statOutput = teg_repeated_measures_ANOVA(nullDataMat(:,:,j),[var1_levels var2_levels],{var1_name, var2_name});  % do ANOVA
    var1.fValsNull(j,1) = statOutput(1,1);   % create column vector of null F-values
    var2.fValsNull(j,1) = statOutput(2,1);
    varInt.fValsNull(j,1) = statOutput(3,1);
    
    clear statOutput
    
    % get post-hoc null t value distribution (only makes sense to create
    % one null distribution for all combinations of tests, given within
    % subjects column shuffling method)
    [H,P,CI,STATS] = ttest(nullDataMat(:,1,j),nullDataMat(:,2,j)); 
    tValsNull(j,1) = STATS.tstat;
    clear STATS
    
end


%%DO THIS FOR BOTH MAIN EFFECTS AND INTERACTION (JUST CHANGE THE VALUE FROM
%%STAT OUTPUT>

% do ANOVA on observed data
statOutput = teg_repeated_measures_ANOVA(observedData,[var1_levels var2_levels],{var1_name, var2_name});
var1.fValObserved = statOutput(1,1);   % exercise
var2.fValObserved = statOutput(2,1);
varInt.fValObserved = statOutput(3,1);

%clear statOutput

% sort null f-values, get index value and convert to percentile (VAR_1)
var1.NAME = var1_name;
var1.LEVELS = var1_levels;
var1.fValsNull = sort(var1.fValsNull(:,1),1,'descend');
[c var1.fValueIndex] = min(abs(var1.fValsNull - var1.fValObserved)); 
var1.fValueIndex = var1.fValueIndex/1000;
var1.pValueANOVA = var1.fValueIndex;
var1.eta_p2 = statOutput(1,6);
var1.df = statOutput(1,[2,3]);

% sort null f-values, get index value and convert to percentile (VAR_2)
var2.NAME = var2_name;
var2.LEVELS = var2_levels;
var2.fValsNull = sort(var2.fValsNull(:,1),1,'descend');
[c var2.fValueIndex] = min(abs(var2.fValsNull - var2.fValObserved)); 
var2.fValueIndex = var2.fValueIndex/1000;
var2.pValueANOVA = var2.fValueIndex;
var2.eta_p2 = statOutput(2,6);
var2.df = statOutput(2,[2,3]);


% sort null f-values, get index value and convert to percentile (VAR INTER)
VarInt.NAME = 'INTERACTION';
varInt.LEVELS = [num2str(var1_levels) '-by-' num2str(var2_levels)];
varInt.fValsNull = sort(varInt.fValsNull(:,1),1,'descend');
[c varInt.fValueIndex] = min(abs(varInt.fValsNull - varInt.fValObserved)); 
varInt.fValueIndex = varInt.fValueIndex/1000;
varInt.pValueANOVA = varInt.fValueIndex;
varInt.eta_p2 = statOutput(3,6);
varInt.df = statOutput(3,[2,3]);







% save important stats info
save([sourceDir '/' 'STATS_Cortisol.mat'],'var1', 'var2','varInt','observedData','nullDataMat','statOutput');













% 
% 
% % iteration loop (null data)
% for i=1:1000
%     
%     disp(['Null Iteration ' num2str(i)])
%     
%     % sample (timepoint) loop
%     for j=1:size(paMatAll,5)
%         
%         % trial (CPT/WPT exposure) loop
%         for k=1:size(paMatAll,3)
%             
%             observedData = squeeze(mean(paMatAll(:,:,k,:,j),4)); % subs x conds (average across R/L eyes)
%             
%             for m=1:length(observedData)              
%                 thisPerm = randperm(size(observedData,2));              
%                 nullDataMat(m,:) = observedData(m,thisPerm);       
%             end
%             
%             [H,P,CI,STATS] = ttest(nullDataMat(:,1),nullDataMat(:,2));
%             tValsNull(i,j,k) = STATS.tstat;
%             clear STATS nullDataMat observedData
%             
%         end
%     end
% end
% 
% %% generate matrix of real t-test results
% 
% % sample (timepoint) loop
% for j=1:size(paMatAll,5)
%     % trial (CPT/WPT loop) 
%     for k=1:size(paMatAll,3)
%         
%         observedData = squeeze(mean(paMatAll(:,:,k,:,j),4)); % subs x conds (average across R/L eyes)
%         [H,P,CI,STATS] = ttest(observedData(:,1),observedData(:,2));
%         tValsObs(j,k) = STATS.tstat;
%         clear STATS observedData 
%  
%     end
% end
% 
%     
% %% compare observed t-test at each trial and timepoint with corresponding null distribution of t-values
% 
% % sample (timepoint) loop
% for j=1:size(tValsNull,2)
%     
%     % trial (exposure) loop
%     for k=1:size(tValsNull,3)
% 
%         thisNullDist = sort(tValsNull(:,j,k),1,'descend');
%         [~,idx] = min(abs(thisNullDist - tValsObs(j,k)));
%         tStatIdx(j,k) = idx;
%         clear thisNullDist  idx
%         
%     end
% end
% 
% % convert idx value to probability
% %pValuesPairwise = tStatIdx./1000;
% 
% % convert idx value to a vector of 0's and 1's (representing significance
% % at p<.05)
% clear sigVec
% for j=1:size(tStatIdx,1)
%     for k=1:size(tStatIdx,2)
%         if tStatIdx(j,k)<25 || tStatIdx(j,k)>975
%             sigVec(j,k) = 1;
%         else
%             sigVec(j,k)=0;
%         end
%     end
% end
% 
% % save data
% save([sourceDir '/' 'STATS_Resampled_EYE_n25.mat'],'sigVec','tValsObs','tValsNull','subjects','badSubs')
% 



