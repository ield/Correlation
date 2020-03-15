%Engineer: ield
%Company: ALTER-UPM

function [] = managePlot(xaxis, fourier)
%% General Explanation
%   Sets properly a graph
%   #1: Labels the axis
%   #2: Titles the graph (depending whether the correlation is Fourier or
%       not
%   #3: Limits the axis

% xaxis:    x axis of the plot. It is used to limit the x axis
% fourier:  true if the graph is the one of a fourier correlation

    xlabel('Distance [m]');
    ylabel('Correlation');
    
    if(fourier)
        title('Fourier Correlation');
    else
        title('Normal Correlation');
    end
    
    xlim([xaxis(1) xaxis(length(xaxis))]);
    
end

