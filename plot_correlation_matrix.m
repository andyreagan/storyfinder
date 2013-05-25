% plot_correlation_matrix.m
%
% plot the timeseries correlation for different valence
%
% written by Andy Reagan
% 4/16/13

% load the files
valence_h = {'000','025','050','075','100','125','150','175','200'};

for i=1:length(valence_h)
    tmp = sprintf('Boston_Valence_Seires_%s_clean.txt',valence_h{i});
    %data = load(tmp);
    load(tmp);
end
