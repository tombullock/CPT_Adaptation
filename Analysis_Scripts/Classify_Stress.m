%{
Classify_Stress_States
Author: Tom Bullock
Date: 01.03.20

%}

clear
close all

sourceDir = '/home/bullock/BOSS/CPT_Adaptation/Data_Compiled';

load([sourceDir '/' 'GRAND_MATS_ALL_DATA.mat'])

% just try this with cardiac measures first

% set condition labels
condLabels=[1,1,1,1,1,2,2,2,2,2];
nTrials = length(condLabels);

% preallocate accData with NANS
%accData(1:61,1:159) = nan;

% loop through permuted and real data classification
for permuteLabels=0:1
    
    
    % loop through subjects
    for iMeasure=1:8
        
        
        iMeasure
        cntSub=0;
        for iSub=1:size(grandMat,1)
            
            
            
            %try
            
            
            clear sjMat
            sjMat = squeeze(grandMat(iSub,:,:,35:190,iMeasure)); % just the exposure + recovery part of the trialn [EDIT THE FEATURES 1:8 GOING INTO CLASSIFIER HERE]
            
            runClassifier=1;
            %     if isnan(sjMat)
            %         runClassifier=0;
            %     end
            
            if runClassifier
                
                
                
                
                
                
                
                cntSub=cntSub+1;
                
                for iTime=1:size(sjMat,3)
                    
                    % permute condition labels if requested
                    if permuteLabels
                        for i=1:7
                            condLabels = condLabels(randperm(size(condLabels,2)));
                        end
                    end
                    
                    thisData = [squeeze(sjMat(:,1,iTime,:));squeeze(sjMat(:,2,iTime,:))];
                    
                    try
                        correctTrials=0;
                        for iTrial=1:nTrials
                            
                            testData = thisData(iTrial,:);
                            testMember = condLabels(iTrial);
                            trainIdx = setdiff(1:10,iTrial);
                            trainData = thisData(trainIdx,:);
                            trainMember = condLabels(trainIdx);
                            p=repmat(1/2,1,2);
                            
                            Labels=classify(testData,trainData,trainMember,'lin',p);
                            
                            if length(Labels)==1
                                if Labels==testMember
                                    correctTrials=correctTrials+1;
                                end
                            else
                                correctTrials=correctTrials+length(find(Labels==testMember));
                            end
                            
                            % create confusion matrix (do this later)
                            %confMtx(testMember,Labels)=confMtx(testMember,Labels)+1;
                            %classCtr(testMember)=classCtr(testMember)+1;
                            
                            
                            
                        end
                        
                        accData(cntSub, iTime)=correctTrials/nTrials;
                        
                        
                    catch
                        
                        accData(cntSub,iTime) = nan;
                        
                        %disp('skip timepoint')
                    end
                    
                    
                    
                    
                    
                end
                
            end
            
            
            
        end
        
        % add classification to structures
        if permuteLabels==0
            classStruct(iMeasure).accData = accData;
        elseif permuteLabels==1
            classStructPerm(iMeasure).accData = accData;
        end

    end
end

save([sourceDir '/' 'CLASSIFICATION_DATA.mat'],'classStruct','classStructPerm','grandMatHeaders')

















        
        
        
% correctTrials=0;
% 
% for iTrial = 1:nTrials
%     
%     
%     
%     testData = thisData(iTrial,:);
%     testMember = trialLocs(iTrial);
%     trainIdx = setdiff(1:nTrials,iTrial);
%     trainData = thisData(trainIdx,:);
%     trainMember = trialLocs(trainIdx);
%     p=repmat(1/6,1,6);
%     
%     %force a uniform prior, to ensure that the classifier doesn't just merely use class frequency
%     %                   to determine the descriminant function. i.e.,
%     %
%     
%     % vanilla matlab classifier. the 'lin' flag specifies a linear
%     % classifier that fits a multivariate normal density to each group,
%     % with a pooled estimate of covariance. see lines 223-237 in
%     % classify.m. then the label for any given trial is determined by
%     % the density function that is closest to the test trial.
%     
%     Labels=classify(testData,trainData,trainMember,'lin',p);
%     
%     
%     if length(Labels)==1
%         if Labels==testMember
%             correctTrials=correctTrials+1;
%         end
%     else
%         correctTrials=correctTrials+length(find(Labels==testMember));
%     end
%     
%     % create confusion matrix
%     %confMtx(testMember,Labels)=confMtx(testMember,Labels)+1;
%     %classCtr(testMember)=classCtr(testMember)+1;
%     
%     
%     
%     
% end
% 
% % compute accuracy
% accData=correctTrials/nTrials;
% 
% %  conf matrix p
% pConfMtx=confMtx./classCtr'; % WHY rotate???
% 
% 
% 
% 
% 
% end
% end


