% plot_timeseries.m
%
% plot the difference valence timeseries



%figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
%figshape(600,800);

tmpfilename = 'timeseries';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

%% set(gcf,'Color','none');
%% set(gcf,'InvertHardCopy', 'off');

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',5);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {[255 0 0]/255,[223 97 1]/255,[255 187 1]/255,[255 229 1]/255,'k',[125 255 255]/255,[75 202 255]/255,[71 71 255]/255,[0 0 255]/255};


positions(1).box = [.2 .2 .7 .7]; % [ xmin ymin xmax ymax
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

valence_h = {'000','025','050','075','100','125','150','175','200'};

for i=1:length(valence_h)
    
    tmp = sprintf('../data/Boston_Valence_Seires_%s_clean.txt',valence_h{i});

    data = load(tmp);
    
    %figure;
    %plot(1:length(data(:,1)),data(:,1));
    
    %title(tmp);
    %ylim([5 7]);
    
    tmph(i) = plot(1:length(data(:,1)),data(:,1),'Color',tmpcol{i},'LineWidth',1.4);
    hold on
    
    %tmph(i) = plot(1:length(data(1:3:end,1)),data(1:3:end,1),'Marker',tmpsym{mod(i,6)+1},'MarkerFaceColor',tmpcol{mod(i,6)+1},'LineStyle','none');
end

tmpylab=ylabel('Happs','fontsize',10,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
set(tmpylab,'position',get(tmpylab,'position') + [-.05 0 0]);

tmpxlab=xlabel('Time','fontsize',10,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
set(tmpxlab,'position',get(tmpxlab,'position') + [0 -.05 0]);

% valence_h_dec=zeros(1,length(valence_h));
% for j=1:length(valence_h)   
%     valence_h_dec(j) = num2str(str2num(valence_h{j})/100);
% end

valence_h = {'0.00','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00'};


% Legend at axes 1
tmplegend = legend(gca,tmph(1:4),valence_h{1:4},1); % {6},tmpleg{3},tmpleg{5},tmpleg{1},tmpleg{2},tmpleg{4}
set(tmplegend,'position',get(tmplegend,'position')-[.11 0 0 0]); %% -[x y 0 0]
%% change font
tmplegend = findobj(tmplegend,'type','text');
set(tmplegend,'FontSize',9);
%% remove box:
legend boxoff

% Block 2
% Axes handle 2 (unvisible, only for place the second legend)
ah2=axes('position',get(gca,'position'), 'visible','off');
% Legend at axes 2
tmplegend = legend(ah2,tmph(5:9),valence_h{5:9},1); % {6},tmpleg{3},tmpleg{5},tmpleg{1},tmpleg{2},tmpleg{4}
set(tmplegend,'position',get(tmplegend,'position')-[0 0 0 0]); %% -[x y 0 0]
% %% change font
tmplegend = findobj(tmplegend,'type','text');
set(tmplegend,'FontSize',9);
% %% remove box:
legend boxoff
% 
% % Block 3
% % Axes handle 3 (unvisible, only for place the third legend)
% ah3=axes('position',get(gca,'position'), 'visible','off');
% % Legend at axes 3
% legend(ah3,h(5:6),'y5','y6',3)




psprintcpdf(tmpfilenoname);


tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
system(tmpcommand);

% system('epstopdf distribution-comparison001_noname.ps','-echo');
% system('open distribution-comparison001_noname.pdf');

%% archivify
%figurearchivify(tmpfilenoname);

%close(tmpfigh);
clear tmp*



