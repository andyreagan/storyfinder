% plot_timeseries.m
%
% plot the difference valence timeseries



%figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
%figshape(600,800);

tmpfilename = 'presidents';

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
tmpcol = {'g','b','r','k','c','m'};


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
    
    line = plot(1:length(data(:,1)),data(:,1),'Color',tmpcol{mod(i,6)+1},'LineWidth',2);
    hold on
    
    %tmph(i) = plot(1:length(data(1:3:end,1)),data(1:3:end,1),'Marker',tmpsym{mod(i,6)+1},'MarkerFaceColor',tmpcol{mod(i,6)+1},'LineStyle','none');
end


tmplegend = legend(tmph,valence_h,'location','northeast'); % {6},tmpleg{3},tmpleg{5},tmpleg{1},tmpleg{2},tmpleg{4}
set(tmplegend,'position',get(tmplegend,'position')-[.02 0.02 0 0]); %% -[x y 0 0]
%% change font
tmplegend = findobj(tmplegend,'type','text');
set(tmplegend,'FontSize',16);
%% remove box:
legend boxoff


%psprintcpdf(tmpfilenoname);


%tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
%system(tmpcommand);

% system('epstopdf distribution-comparison001_noname.ps','-echo');
% system('open distribution-comparison001_noname.pdf');

%% archivify
%figurearchivify(tmpfilenoname);

%close(tmpfigh);
clear tmp*



