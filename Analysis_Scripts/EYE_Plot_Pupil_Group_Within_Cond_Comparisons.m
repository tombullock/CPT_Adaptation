%{
EYE_Plot_Pupil_Area
Author: Tom Bullock, UCSB Attention Lab
Date: 09.17.18, updated 05.25.19

Notes: normalize data

%}

clear
close all

%% set dirs
sourceDir = '/home/bullock/BOSS/CPT_Adaptation/Data_Compiled';
plotDir = '/home/bullock/BOSS/CPT_Adaptation/Plots';

%% load compiled EYE Data (paMatAll = sub,session,task,eye,timepoint)
load([sourceDir '/' '/CPT_EYE_Master.mat'])

%% baseline correction [Note that Event times are 1,20000,32500,77500,97500]
baselineCorrect=0;

%% load resampled stats
if baselineCorrect==0
    load([sourceDir '/' 'STATS_Resampled_EYE_n21_raw.mat'],'sigVec')
else
    load([sourceDir '/' 'STATS_Resampled_EYE_n21_bln.mat'],'sigVec')
end

% remove bad subjects
badSubs = [103,105,108,109,115,116,117,118,126,128,135,136,138,139,140,146,147,148,154,157,158,159];
[a,b] = setdiff(subjects,badSubs);
paMatAll = paMatAll(b,:,:,:,:);


        


theseXlims=[0,195];
theseXticks=[0,40,65,155,195];

if baselineCorrect==1
    paMatBL= nanmean(paMatAll(:,:,:,:,round(26000/2):round(40000/2)),5);
    paMatAll = paMatAll - paMatBL;
end

%% downsample to 1Hz [average across each second (500Hz original SR)]
for i=1:195
    paMattAll_DS(:,:,:,:,i) = nanmean(paMatAll(:,:,:,:,((i*500)+1:(i+1)*500)-500),5);
end
paMatAll = paMattAll_DS;

%% plot settings
theseYlims = [0,1];

%% normalize between -1 and 1
maxPA = squeeze(max(max(max(max(nanmean(paMatAll,1))))));
minPA = squeeze(min(min(min(min(nanmean(paMatAll,1))))));
paMatAll = (paMatAll-minPA)/(maxPA-minPA);

%% plot T1-T5 on separate plots
%plotCnt=0;

h=figure('units','normalized','outerposition',[0 0 0.5 0.4]);
for iCond=1:2
    
    subplot(1,2,iCond)
        
    for iOrder=[5,4,3,2,1]
        
        thisEye=1:2; %1=left,2=right
        
        if      iOrder==1; thisColor = [255,0,0]; %red
        elseif  iOrder==2; thisColor = [255,140,0];% orange ;
        elseif  iOrder==3; thisColor = [252,226,5]; % yellow[255,192,203];
        elseif  iOrder==4; thisColor = [0,255,0]; % green
        elseif  iOrder==5; thisColor = [0,0,255]; %blue
        end
        
        plot(1:195,smooth(squeeze(nanmean(nanmean(paMatAll(:,iCond,iOrder,thisEye,:),1),4)),5),...
            'color',thisColor./255,...
            'linewidth',4); hold on % plot indices (500 Hz,to divide by 2)
        
        % add lines
        t1=1; % start pre baseline ( 40 s)
        t2=40; % immersion period (position feet for immersion -25 s)
        t3=65; % start CPT (immerse feet - 90 s)
        t4=155; % recovery (feet out, start recovery baseline - 40 s)
        
        for iLine=2:4
            if iLine==1; tx=t1;thisText = 'Baseline';
            elseif iLine==2; tx=t2; thisText = 'Prep';
            elseif iLine==3; tx=t3; thisText = 'CPT';
            elseif iLine==4; tx=t4; thisText = 'Recovery';
            end
            line([tx,tx],[-300,600],'color','k','linewidth',4,'linestyle',':');
            text(tx,700,thisText,'fontsize',18)
        end
        
        % add T1, T2 etc labels on left
        thisTime = ['T' num2str(iOrder)];
        %text(-25,0, thisTime,'fontsize',34)
        
        %xlabel('Time (s)','fontsize',18)
        %ylabel('P.Area (norm.)')
        set(gca,...
            'xlim',theseXlims,...
            'XTick',theseXticks,...
            'ylim',theseYlims,...
            'box','off',...
            'fontsize',26,...
            'linewidth',1.5)
        
                       % change aspect ratio
                pbaspect([2,1,1])
        
        %legend('ICE','WARM')
        
    end
    
    if baselineCorrect==0
        saveas(h,[plotDir '/' 'EYE_Raw_Within_Condition.eps'],'epsc')
    else
        saveas(h,[plotDir '/' 'EYE_Bln_Within_Condition.eps'],'epsc')
    end
    
    
end

% % save data
% if baselineCorrect==1
%     save([sourceDir '/' 'EYE_FOR_PREDICTIVE_ANALYSIS.mat'],'subjects','badSubs','paMatAll')
%     saveas(h,[plotDir '/' 'Eye_Normalized_Resampled_Bln.eps'],'epsc')
% else
%     save([sourceDir '/' 'EYE_FOR_PREDICTIVE_ANALYSIS_RAW.mat'],'subjects','badSubs','paMatAll')
%     saveas(h,[plotDir '/' 'Eye_Normalized_Resampled_Raw.eps'],'epsc')
% end
