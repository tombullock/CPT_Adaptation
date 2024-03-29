%{
Plot_Time_Frequency_CPT
Author: Tom Bullock, UCSB Attention Lab
Date: 09.15.18
%}

clear
close all

%% set dirs
sourceDir = '/home/bullock/BOSS/CPT_Adaptation/Data_Compiled';

%% what to plot? 1=means,2=individuals
plotType=1;

%% load data
load([sourceDir '/' 'SPECTRA_MASTER.mat' ])

%% baseline correct?
baselineCorrect=1;
if baselineCorrect

else

end

%% if plotting whole group
if plotType==1
    
    %% plot ffts
    for iElects=1:5
        
        % electrode region groups (split front to back in four sections)
        frontal={'Fp1','Fp2','AF3','AF4','AF7','AF8','F7','F5','F3','F1','Fz','F2','F4','F6','F8'};
        central={'FC5','FC3','FC1','FCz','FC2','FC4','FC6','C5','C3','C1','Cz','C2','C4','C6'};
        parietal={'CP5','CP3','CP1','CPz','CP2','CP4','CP6','P7','P5','P3','P1','Pz','P2','P4','P6','P8'};
        occipital={'PO7','PO3','POz','PO2','PO4','PO8','O1','Oz','O2'};
        allElects=[frontal,central,parietal,occipital];
        
        clear theseChans theseElects
        
        if      iElects==1; theseChans=frontal;
        elseif  iElects==2; theseChans=central;
        elseif  iElects==3; theseChans=parietal;
        elseif  iElects==4; theseChans=occipital;
        elseif  iElects==5; theseChans=allElects;
        end
        
        cnt=0;
        for i=1:length(chanlocs)
            if  ismember(chanlocs(i).labels,theseChans)
                cnt=cnt+1;
                theseElects(cnt)=i;
            end
        end
        
        % plot both sessions
        figure('units','normalized','outerposition',[0,0,1,1])
        plotCnt=0;
        for iOrder=1:5
            
            for iPhase=1:5 % base,p1,p2,p3,rec
                plotCnt=plotCnt+1;
                subplot(5,5,plotCnt);
                
                for iSession=[2,1]
                    if iSession==1; thisColor='c';
                    elseif iSession==2; thisColor='r';
                    end
                    
                    thisMean=squeeze(mean(mean(abs(specMaster(:,iSession,iPhase,iOrder,theseElects,:).^2),5),1)); hold on
                    thisSEM= std(squeeze(mean(abs(specMaster(:,iSession,iPhase,iOrder,theseElects,:)).^2,5)),0,1)./sqrt(size(specMaster,1));
                    
                    thisMean=smooth(thisMean);
                    thisSEM=smooth(thisSEM);
                    
                    shadedErrorBar(1:291,thisMean,thisSEM,{'color',thisColor});
                    %plot(thisMean,'color',thisColor)
                end
                
                set(gca,'ylim',[0,.25],'XTick',linspace(1,291,4),'XTickLabel',[0,10,20,30])       %
            end
            %pause(1)
        end
        
    end
    
end


%% if looping through subs
subjects=CPT_SUBJECTS;
if plotType==2
    for iSubs=1:size(specMaster,1)
        sjNum=subjects(iSubs);
        
        %% plot ffts
        for iElects=5%1:5 (all elects avg)
            
            % electrode region groups (split front to back in four sections)
            frontal={'Fp1','Fp2','AF3','AF4','AF7','AF8','F7','F5','F3','F1','Fz','F2','F4','F6','F8'};
            central={'FC5','FC3','FC1','FCz','FC2','FC4','FC6','C5','C3','C1','Cz','C2','C4','C6'};
            parietal={'CP5','CP3','CP1','CPz','CP2','CP4','CP6','P7','P5','P3','P1','Pz','P2','P4','P6','P8'};
            occipital={'PO7','PO3','POz','PO2','PO4','PO8','O1','Oz','O2'};
            allElects=[frontal,central,parietal,occipital];
            
            clear theseChans theseElects
            
            if      iElects==1; theseChans=frontal;
            elseif  iElects==2; theseChans=central;
            elseif  iElects==3; theseChans=parietal;
            elseif  iElects==4; theseChans=occipital;
            elseif  iElects==5; theseChans=allElects;
            end
            
            cnt=0;
            for i=1:length(chanlocs)
                if  ismember(chanlocs(i).labels,theseChans)
                    cnt=cnt+1;
                    theseElects(cnt)=i;
                end
            end
            
%             % plot both sessions
%             figure('units','normalized','outerposition',[0,0,1,1])
%             plotCnt=0;
%             for iOrder=1:5
%                 for iSession=1:2
%                     for iPhase=1:3 % base,exp,rec
%                         plotCnt=plotCnt+1;
%                         subplot(5,6,plotCnt);
%                         thisMean=squeeze(mean(mean(abs(specMaster(iSubs,iSession,iPhase,iOrder,theseElects,:).^2),5),1));
%                         plot(thisMean)
%                         set(gca,'ylim',[0,.25],'XTick',linspace(1,291,4),'XTickLabel',[0,10,20,30])       %
%                     end
%                 end
%             end
            
            
            % plot both sessions
            h=figure('units','normalized','outerposition',[0,0,1,1]);
            plotCnt=0;
            for iOrder=1:5
                
                for iPhase=1:5 % base,p1,p2,p3,rec
                    plotCnt=plotCnt+1;
                    subplot(5,5,plotCnt);
                    
                    for iSession=[2,1]
                        if iSession==1; thisColor='c';
                        elseif iSession==2; thisColor='r';
                        end
                        
                        thisMean=squeeze(mean(mean(abs(specMaster(iSubs,iSession,iPhase,iOrder,theseElects,:).^2),5),1)); hold on
                        %thisSEM= std(squeeze(mean(abs(specMaster(:,iSession,iPhase,iOrder,theseElects,:)).^2,5)),0,1)./sqrt(size(specMaster,1));
                        
                        thisMean=smooth(thisMean);
                        %thisSEM=smooth(thisSEM);
                        
                        %shadedErrorBar(1:291,thisMean,thisSEM,{'color',thisColor});
                        plot(thisMean,'color',thisColor)
                    end
                    
                    set(gca,'ylim',[0,.25],'XTick',linspace(1,291,4),'XTickLabel',[0,10,20,30])       %
                end
                %pause(1)
            end
            
            
            
            
            
            
            
            
        end
        
        %pause(5)
        
        % print to files
        saveas(h,['/home/bullock/BOSS/CPT_Adaptation/Plots/individualSubsFFTs' '/' sprintf('sj%02d_ffts_all_elects.jpg',sjNum) ],'jpeg')
        close
        
    end
end
    
    
    %%%%%%%%%%%%
%     
%     
%     % plot both sessions, averaged
%     h=figure;
%     plotCnt=0;
%     for iOrder=1:5
%         for iSession=1:2
%             
%             plotCnt=plotCnt+1;
%             plotIdx=[1,2,4,5,7,8,10,11,13,14];
%             
%             subplot(5,3,plotIdx(plotCnt))
%             
%             % plot titles
%             if iSession==1; thisTitle = 'Ice Water'; thisTime = ['T' num2str(iOrder)];
%             elseif iSession==2; thisTitle = 'Warm Water';
%             end
%             
%             % set colorbar maxmin
%             if analysisType==1
%                 thisCbar=[-6,8];
%             else
%                 if baselineCorrect==0
%                     thisCbar=[-10,0];
%                 else
%                     thisCbar=[-6,8];
%                 end
%             end
%             
%             
%             
%             % find mean and plot data
%             dataMean = squeeze(mean(mean(mean(ersp(:,iSession,iOrder,theseElects,:,5:195),1),3),4));
%             imagesc(dataMean,thisCbar)
%             
%             if analysisType==2
%                 thisYtick = linspace(1,50,6);
%                 thisYtickLabel = [1,20,40,60,80,100];
%             else
%                 thisYtick = [1,4,8,12,20,30];
%                 thisYtickLabel = thisYtick;
%             end
%             
%             set(gca,'ydir','normal',...
%                 'fontsize',14,...
%                 'xtick',[1,20,40,60,80,100,120,140,160,180,195],...
%                 'YTick',thisYtick,...
%                 'YTickLabel',thisYtickLabel)
%             
%             % add lines
%             t1=1; % start pre baseline ( 40 s)
%             t2=40; % immersion period (position feet for immersion -25 s)
%             t3=65; % start CPT (immerse feet - 90 s)
%             t4=155; % recovery (feet out, start recovery baseline - 40 s)
%             
%             for iLine=1:4
%                 if iLine==1; tx=t1;thisText = 'Baseline';
%                 elseif iLine==2; tx=t2; thisText = 'Prep';
%                 elseif iLine==3; tx=t3; thisText = 'CPT';
%                 elseif iLine==4; tx=t4; thisText = 'Recovery';
%                 end
%                 line([tx,tx],[1,size(erspAll,5)],'color','w','linewidth',4,'linestyle',':');
%                 %text(tx,35,thisText,'fontsize',18)
%             end
%             
%             % add title at top
%             if iOrder==1
%                 th = title(thisTitle,'fontsize',24);
%                 titlePos = get(th,'position');
%                 set(th,'position',titlePos+1.5)
%             end
%             
%             % add T1, T2 etc labels on left
%             if iSession==1
%                 text(-65,20, thisTime,'fontsize',36)
%             end
% 
%             if iOrder==5
%                 xlabel('Time (s)','fontsize',18)
%             end
%             ylabel('Freq (Hz)')
%             
%             pbaspect([3,1,1])
%             
%             % plot colorbar
%             cbar
%             
%         end
%     end
%     
%     
%     %% plot session1 (ICE) - session2 (WARM) difference ERSP
%     plotCnt=0;
%     for iOrder=[1:5]
%         
%         plotCnt=plotCnt+1;
%         plotIdx=3:3:15;       
%         subplot(5,3,plotIdx(plotCnt))
%         
%         % plot title
%         thisTitle = 'Ice vs. Warm (pairwise)'; thisTime = ['T' num2str(iOrder)];
%         
%         % do t-tests between conditions
%         erspAllChans = squeeze(mean(ersp(:,:,:,theseElects,:,:),4)); % isolate this T and avg over channels
%         
%         tMat = [];
%         for f=1:size(erspAllChans,4)
%             for t=1:size(erspAllChans,5)
%                 
%                 tResult = [];
%                 tResult = ttest(erspAllChans(:,1,iOrder,f,t), erspAllChans(:,2,iOrder,f,t));
%                 tMat(f,t) = tResult;
%                 
%             end
%         end
%         
%         % generate t-plot
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
%             text(0,0, thisTime,'fontsize',36)
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
%     
%     %% plot differences between T1 and T5
%     figure;
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
%     
%     
%     
% end

