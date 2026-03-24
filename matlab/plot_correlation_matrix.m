% plot_correlation_matrix.m
%
% plot the timeseries correlation for different valence
%
% written by Andy Reagan
% 4/16/13

clear all;

% load the files
valence_h = {'000','025','050','075','100','125','150','175','200'};

for i=1:length(valence_h)
    tmp = sprintf('../data/Boston_Valence_Seires_%s_clean.txt',valence_h{i});
    %data = load(tmp);
    tmpdata = load(tmp);
    
    data(:,i) = tmpdata(:,1);
end

[corrMat, pvalMat]=corr(data,data,'type','spearman');

% inds=find(pvalMat>.01);
% corrMat(inds)=0; 

tmp = size(corrMat);

newCorrMat = ones(tmp(1)+1);

newCorrMat(1:9,1:9) = corrMat;

figure;

shadeB = 1; % if 0, flat squares (if 1, shade)
if shadeB
    pcolor(corrMat);
    colorbar;
    shading interp
    tmpfilenoname = 'correlationMatrix_shade';
else
    pcolor(newCorrMat);
    colorbar;
    tmpfilenoname = 'correlationMatrix';
end

tmpylab=ylabel('$\Delta h$','fontsize',15,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
set(tmpylab,'position',get(tmpylab,'position') + [-.35 0 0]);

tmpxlab=xlabel('$\Delta h$','fontsize',15,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
set(tmpxlab,'position',get(tmpxlab,'position') + [0 -.35 0]);

valence_h = {'0','0.25','0.5','0.75','1','1.25','1.5','1.75','2'};

if ~shadeB
    set(gca,'xtick',1.5:1:9.5)
    set(gca,'ytick',1.5:1:9.5)
end

set(gca,'xticklabel',valence_h)
set(gca,'yticklabel',valence_h)

psprintcpdf(tmpfilenoname);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
system(tmpcommand);


% figure;
% clustergram(corrMat);
% colorbar; 