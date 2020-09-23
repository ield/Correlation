function plotCorrelationSubtraction(X1, Y1, figure1)
%CREATEFIGURE(X1, YMatrix1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 23-Sep-2020 08:14:42

% Create figure
% figure1 = figure('Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot(X1,Y1,'Color',[0 0 0],'Parent',axes1);

% Create ylabel
ylabel({'Correlation subtraction'});

% Create xlabel
xlabel('Distance [m]','FontSize',9);

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[1977.7257 2081.8299]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontName','Times New Roman','FontSize',9);
