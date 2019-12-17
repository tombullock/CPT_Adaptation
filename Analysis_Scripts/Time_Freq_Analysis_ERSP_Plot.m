%{
Plot_Time_Frequency_CPT
Author: Tom Bullock, UCSB Attention Lab
Date: 09.15.18
%}

clear
close all

%% set dirs
%sourceDir = '/data/DATA_ANALYSIS/BOSS_PREPROCESSING/EEG/CPT/Data_Compiled';
%sourceDir = '/data/DATA_ANALYSIS/CPT/Data_Compiled';
sourceDir = '/home/bullock/BOSS/CPT_Adaptation/Data_Compiled';

%% select analysis type and load data (0=1-500 Hz, 1=1-100 Hz, 2...)
analysisType=3; 

if analysisType==0
    load([sourceDir '/' 'GRAND_ERSP_1-500Hz.mat'])
elseif analysisType==1
    load([sourceDir '/' 'GRAND_ERSP_1-100Hz.mat'])
elseif analysisType==2
    load([sourceDir '/' 'GRAND_ERSP_1-30Hz_ICA_Occ_Rej.mat'])
elseif analysisType==3
    load([sourceDir '/' 'GRAND_ERSP_1-30Hz_ICA_Brain_80.mat'])

% elseif analysisType==1
%     load([sourceDir '/' 'GRAND_ERSP_1-30Hz.mat'])
end

%% baseline correct?
baselineCorrect=1;
if baselineCorrect
    erspBL = mean(erspAll(:,:,:,:,:,25:40),6); % this is a little off, fix
    ersp = erspAll - erspBL;
else
    ersp = erspAll;
end

%% plot ersps
for iElects=1:5
    
    % electrode region groups (split front to back in four sections)
    frontal={'Fp1','Fp2','AF3','AF4','AF7','AF8','F7','F5','F3','F1','Fz','F2','F4','F6','F8'};
    central={'FC5','FC3','FC1','FCz','FC2','FC4','FC6','C5','C3','C1','Cz','C2','C4','C6'};
    parietal={'CP5','CP3','CP1','CPz','CP2','CP4','CP6','P7','P5','P3','P1','Pz','P2','P4','P6','P8'};
    occipital={'PO7','PO3','POz','PO2','PO4','PO8','O1','Oz','O2'};
    allElects=[frontal,central,parietal,occipital];
    
    clear theseChans theseElects
    
    if      iElects==1; theseChans=frontal; thisChanTitle = 'Frontal';
    elseif  iElects==2; theseChans=central; thisChanTitle = 'Central';
    elseif  iElects==3; theseChans=parietal; thisChanTitle = 'Parietal';
    elseif  iElects==4; theseChans=occipital; thisChanTitle = 'Occipital';
    elseif  iElects==5; theseChans=allElects; thisChanTitle = 'All Elects';
    end
    
    cnt=0;
    for i=1:length(chanlocs)
        if  ismember(chanlocs(i).labels,theseChans)
            cnt=cnt+1;
            theseElects(cnt)=i;
        end
    end
    
    
    % plot both sessions, averaged
    h=figure('units','normalized','outerposition',[0 0 1 1]);
    plotCnt=0;
    for iOrder=1:5
        for iSession=1:2
            
            plotCnt=plotCnt+1;
            plotIdx=[1,2,4,5,7,8,10,11,13,14];
            
            subplot(5,3,plotIdx(plotCnt))
            
            % plot titles
            if iSession==1; thisTitle = ['Ice Water' '-' thisChanTitle]; thisTime = ['T' num2str(iOrder)];
            elseif iSession==2; thisTitle = ['Warm Water' '-' thisChanTitle];
            end
            
            % set colorbar maxmin
            if analysisType==0 || analysisType==1           
                thisCbar=[-2,8];
            elseif analysisType>1
                thisCbar=[-2,5];
            end

%             if analysisType==1
%                 thisCbar=[-6,8];
%             else
%                 if baselineCorrect==0
%                     thisCbar=[-10,0];
%                 else
%                     thisCbar=[-6,8];
%                 end
%             end
            
            
            
            % find mean and plot data
            dataMean = squeeze(mean(mean(mean(ersp(:,iSession,iOrder,theseElects,:,5:195),1),3),4));
            imagesc(dataMean,thisCbar)
            
            if analysisType==0
                thisYtick = linspace(1,50,6);
                thisYtickLabel = [1,100,200,300,400,500];
            elseif analysisType==1
                thisYtick = linspace(1,50,6);
                thisYtickLabel = [1,20,40,60,80,100];
            elseif analysisType>1
                thisYtick = linspace(1,30,6);
                thisYtickLabel = [1,4,8,12,20,30];
            end
            
%             if analysisType==2
%                 thisYtick = linspace(1,50,6);
%                 thisYtickLabel = [1,20,40,60,80,100];
%             else
%                 thisYtick = [1,4,8,12,20,30];
%                 thisYtickLabel = thisYtick;
%             end
            
            set(gca,'ydir','normal',...
                'fontsize',14,...
                'xtick',[1,20,40,60,80,100,120,140,160,180,195],...
                'YTick',thisYtick,...
                'YTickLabel',thisYtickLabel)
            
            % add lines
            t1=1; % start pre baseline ( 40 s)
            t2=40; % immersion period (position feet for immersion -25 s)
            t3=65; % start CPT (immerse feet - 90 s)
            t4=155; % recovery (feet out, start recovery baseline - 40 s)
            
            for iLine=1:4
                if iLine==1; tx=t1;thisText = 'Baseline';
                elseif iLine==2; tx=t2; thisText = 'Prep';
                elseif iLine==3; tx=t3; thisText = 'CPT';
                elseif iLine==4; tx=t4; thisText = 'Recovery';
                end
                line([tx,tx],[1,size(erspAll,5)],'color','w','linewidth',4,'linestyle',':');
                %text(tx,35,thisText,'fontsize',18)
            end
            
            % add title at top
            if iOrder==1
                th = title(thisTitle,'fontsize',24);
                titlePos = get(th,'position');
                set(th,'position',titlePos+1.5)
            end
            
            % add T1, T2 etc labels on left
            if iSession==1
                text(-65,20, thisTime,'fontsize',36)
            end

            if iOrder==5
                xlabel('Time (s)','fontsize',18)
            end
            ylabel('Freq (Hz)')
            
            pbaspect([3,1,1])
            
            % plot colorbar
            cbar
            
        end
    end
    
    
    %% plot session1 (ICE) - session2 (WARM) difference ERSP
    plotCnt=0;
    for iOrder=[1:5]
        
        plotCnt=plotCnt+1;
        plotIdx=3:3:15;       
        subplot(5,3,plotIdx(plotCnt))
        
        % plot title
        thisTitle = 'Ice vs. Warm (pairwise)'; thisTime = ['T' num2str(iOrder)];
        
        % do t-tests between conditions
        erspAllChans = squeeze(mean(ersp(:,:,:,theseElects,:,:),4)); % isolate this T and avg over channels
        
        tMat = [];
        for f=1:size(erspAllChans,4)
            for t=1:size(erspAllChans,5)
                
                tResult = [];
                tResult = ttest(erspAllChans(:,1,iOrder,f,t), erspAllChans(:,2,iOrder,f,t));
                tMat(f,t) = tResult;
                
            end
        end
        
        % generate t-plot
        imagesc(tMat)
          
        
        if analysisType==0
            thisYtick = linspace(1,50,6);
            thisYtickLabel = [1,100,200,300,400,500];
        elseif analysisType==1
            thisYtick = linspace(1,50,6);
            thisYtickLabel = [1,20,40,60,80,100];
        elseif analysisType>1
            thisYtick = linspace(1,30,6);
            thisYtickLabel = [1,4,8,12,20,30];
        end
        
%         if analysisType==2
%             thisYtick = linspace(1,50,6);
%             thisYtickLabel = [1,20,40,60,80,100];
%         else
%             thisYtick = [1,4,8,12,20,30];
%             thisYtickLabel = thisYtick;
%         end
        
        set(gca,'ydir','normal',...
            'fontsize',14,...
            'xtick',[1,20,40,60,80,100,120,140,160,180,195],...
            'YTick',thisYtick,...
            'YTickLabel',thisYtickLabel)
        
        
        % add lines
        t1=1; % start pre baseline ( 40 s)
        t2=40; % immersion period (position feet for immersion -25 s)
        t3=65; % start CPT (immerse feet - 90 s)
        t4=155; % recovery (feet out, start recovery baseline - 40 s)
        
        for iLine=1:4
            if iLine==1; tx=t1;thisText = 'Baseline';
            elseif iLine==2; tx=t2; thisText = 'Prep';
            elseif iLine==3; tx=t3; thisText = 'CPT';
            elseif iLine==4; tx=t4; thisText = 'Recovery';
            end
            line([tx,tx],[1,size(erspAll,5)],'color','w','linewidth',4,'linestyle',':');
            %text(tx,35,thisText,'fontsize',18)
        end
        
        % add title at top
        if iOrder==1
            th = title(thisTitle,'fontsize',24);
            titlePos = get(th,'position');
            set(th,'position',titlePos+1.5)
        end
        
        % add T1, T2 etc labels on left
        if iSession==1
            text(0,0, thisTime,'fontsize',36)
        end
  
        if iOrder==5
            xlabel('Time (s)','fontsize',18)
        end
        ylabel('Freq (Hz)')
        
        pbaspect([3,1,1])
        
        % plot colorbar
        colormap('jet')
        
    end
    
%     %% plot differences between T1 and T5
%     h=figure('units','normalized','outerposition',[0 0 1 1]);
%     for iSession=1:2 % plot T1vsT5 ICE and T1vsT5 WARM
%         subplot(1,2,iSession)
%         tMat = [];
%         for f=1:size(erspAllChans,4)
%             for t=1:size(erspAllChans,5)
%                 
%                 tResult = [];
%                 tResult = ttest(erspAllChans(:,iSession,1,f,t), erspAllChans(:,iSession,5,f,t)); % compare T1 and T5 real
%                 tMat(f,t) = tResult;
%                 
%             end
%         end
%         
%         imagesc(tMat)
%         
%         if analysisType==2
%             thisYtick = linspace(1,50,6);
%             thisYtickLabel = [1,20,40,60,80,100];
%         else
%             thisYtick = [1,4,8,12,20,30];
%             thisYtickLabel = thisYtick;
%         end
%         
%         set(gca,'ydir','normal',...
%             'fontsize',14,...
%             'xtick',[1,20,40,60,80,100,120,140,160,180,195],...
%             'YTick',thisYtick,...
%             'YTickLabel',thisYtickLabel)
%         
%         
%         % add lines
%         t1=1; % start pre baseline ( 40 s)
%         t2=40; % immersion period (position feet for immersion -25 s)
%         t3=65; % start CPT (immerse feet - 90 s)
%         t4=155; % recovery (feet out, start recovery baseline - 40 s)
%         
%         for iLine=1:4
%             if iLine==1; tx=t1;thisText = 'Baseline';
%             elseif iLine==2; tx=t2; thisText = 'Prep';
%             elseif iLine==3; tx=t3; thisText = 'CPT';
%             elseif iLine==4; tx=t4; thisText = 'Recovery';
%             end
%             line([tx,tx],[1,size(erspAll,5)],'color','w','linewidth',4,'linestyle',':');
%             %text(tx,35,thisText,'fontsize',18)
%         end
%         
%         % add title at top
%         if iOrder==1
%             th = title(thisTitle,'fontsize',24);
%             titlePos = get(th,'position');
%             set(th,'position',titlePos+1.5)
%         end
%         
%         % add T1, T2 etc labels on left
%         if iSession==1
%             title('ICE T1 vs T5')
%         else
%             title('WARM T1 vs T5')
%         end
%         
%         if iOrder==5
%             xlabel('Time (s)','fontsize',18)
%         end
%         ylabel('Freq (Hz)')
%         
%         pbaspect([3,1,1])
%         
%         % plot colorbar
%         colormap('jet')
%         
%     end
    
    
    
end
