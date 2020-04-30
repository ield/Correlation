function plotSamplingResultsDistance(X1, YMatrix1, X2, Y1, X3, Y2, X4, Y3, X5, Y4)
%CREATEFIGURE(X1, YMatrix1, X2, Y1, X3, Y2, X4, Y3, X5, Y4)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data
%  X2:  vector of x data
%  Y1:  vector of y data
%  X3:  vector of x data
%  Y2:  vector of y data
%  X4:  vector of x data
%  Y3:  vector of y data
%  X5:  vector of x data
%  Y4:  vector of y data

%  Auto-generated by MATLAB on 17-Apr-2020 18:45:52

% Create figure
figure1 = figure('WindowState','maximized','Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',2,'LineStyle','none','Color',[0 0 0]);
set(plot1(1),'DisplayName','Distance without interolation','Marker','+');
set(plot1(2),'DisplayName','Distance with interpolation','Marker','o');

% Create plot
plot(X2,Y1,'DisplayName','Error','LineStyle','--','Color',[0 0 0]);

% Create plot
plot(X3,Y2,'LineStyle','--','Color',[0 0 0]);

% Create plot
plot(X4,Y3,'LineStyle','--','Color',[0 0 0]);

% Create plot
plot(X5,Y4,'LineStyle','--','Color',[0 0 0]);

% Create ylabel
ylabel({'Distance (m)'});

% Create xlabel
xlabel({'Samples'});

% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0 11]);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[1010 1030]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontName','Times New Roman','FontSize',9,'XTick',[1 2 4 10],...
    'YTick',[1010 1030]);
% Create legend
legend(axes1,'show');
