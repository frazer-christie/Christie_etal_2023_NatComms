%% Plot_Christie_etal_2023_FigS9.m
% This code reads in the SAM and ONI records discussed in the text and plots Fig. S9 of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
%The code is dependent on the following toolbox and files, available at 
% the links/references detailed below:

% Climate Data Tools (Greene et al., 2019; https://uk.mathworks.com/matlabcentral/fileexchange/70338-climate-data-toolbox-for-matlab)
% newsam.1957.2007.csv (SAM Index data available at: https://legacy.bas.ac.uk/met/gjma/sam.html (note: converted from .txt to .csv for ease of use in code)) 
% oni.csv (ONI Index data available at: https://psl.noaa.gov/data/correlation/oni.data)

%% Code input
%Below, <> symbols denote user input prompt.

%% Code
close all; clear all;
addpath(genpath('<INSERT FILEPATH HERE>'));

%% Load climate indices
ONI = csvread('ONI.csv',1,1)';
ONI = ONI(:);
ONItime = csvread('ONI.csv',1,0,[1,0,73,0]);
ONIgraphtime = 1950:1/12:2022.99; % Define time

SAM = csvread('newsam.1957.2007.csv',1,1)';
SAM = SAM(:);
SAMtime = csvread('newsam.1957.2007.csv',1,0,[1,0,64,0])';  
SAMgraphtime = 1957:1/12:2020.99; % Define time

%% Plot SAM and ONI timeseries with a 1-year running mean to smooth data.
r1 = [160 28 38]./255; % Define custom colors for plot
b1 = [18 87 190]./255; % Define custom colors for plot

figure 
SAMrunningmean12month = movmean(SAM,12); % 1-year running mean
ax = subsubplot(3,1,1,'vpad',0.0);
xlim([2002 2016]);
yline(0)
for i = 2003:1:2015
    xline(i)
end
set(ax,'YAxisLocation', 'left')
set(gca,'color','none')
anomaly(SAMgraphtime, SAMrunningmean12month','color',[0.3 0.3 0.3],'topcolor',r1,'bottomcolor',b1,'linewidth',1.25);
ylabel('SAM Index','fontweight','bold');

%ONI
ONIrunningmean12month = movmean(ONI,12); % 1-year running mean
ax = subsubplot(3,1,3,'vpad',0.00);
xlim([2002 2016]);
yline(0)
for i = 2003:1:2015
    xline(i)
end
set(ax,'YAxisLocation', 'right')
set(gca,'color','none')
anomaly(ONIgraphtime, ONIrunningmean12month','color',[0.3 0.3 0.3],'topcolor',r1,'bottomcolor',b1,'linewidth',1.25);
ylabel('ONI (^{\circ}C)','fontweight','bold')
xlabel('Year','fontweight','bold')
hold on
anomaly(ONIgraphtime, ONIrunningmean12month','color',[0.3 0.3 0.3],'topcolor',r1,'bottomcolor',b1,'linewidth',1.25);
