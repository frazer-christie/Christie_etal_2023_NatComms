%% Plot_Christie_etal_2023_FigS8.m
% This code reads in GlobalMass and IMBIE mass balance records for West Antarctica and plots Fig. S8 of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
%The code is dependent on the following files and functions, which either accompany this code or are available at 
% the links/references detailed below:

% Antarcitc_BHM_mass_trends_2003_2015.csv (BHM mass trends file available at: https://www.globalmass.eu/data/)
% FigS8_IMBIE_WAIS_data_Gtyr.csv (IMBIE mass loss trends derived from the data presented at: http://imbie.org/)
% shadedErrorBar.m (available at: https://uk.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)

%% Code input
%Below, <> symbols denote user input prompt.

%% Code
close all; clear all;
addpath(genpath('<INSERT FILEPATH HERE>')); % filepath containing GlobalMass and IMBIE datasets 

%% Load GlobalMass BHA data corresponding to Amundsen Sea region 
time = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1,2,[1,2,13,2]); % Define 2003-2015 time 

%Region 322 Pine Island Glacier 
PIG_ice = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',274,3,[274,3,286,3]);
PIG_ice_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',274,4,[274,4,286,4]);
PIG_sfc = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1054,3,[1054,3,1066,3]);
PIG_sfc_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1054,4,[1054,4,1066,4]);
PIG_mass = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',664,3,[664,3,676,3]);
PIG_mass_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',677,4,[677,4,689,4]);

%Region 321 Thwaites Pope Smith Kohler 
THWPSK_ice = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',261,3,[261,3,273,3]);
THWPSK_ice_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',261,4,[261,4,273,4]);
THWPSK_sfc = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1041,3,[1041,3,1053,3]);
THWPSK_sfc_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1041,4,[1041,4,1053,4]);
THWPSK_mass = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',651,3,[651,3,663,3]);
THWPSK_mass_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',677,4,[677,4,689,4]);

%Region 320 Getz & wider MBL
GetzMBL_ice = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',248,3,[248,3,260,3]);
GetzMBL_ice_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',248,4,[248,4,260,4]);
GetzMBL_sfc = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1028,3,[1028,3,1040,3]);
GetzMBL_sfc_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',1028,4,[1028,4,1040,4]);
GetzMBL_mass = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',638,3,[638,3,650,3]);
GetzMBL_mass_SD = csvread('Antarcitc_BHM_mass_trends_2003_2015.csv',638,4,[638,4,650,4]);

% Concatenate GlobalMass BHA data corresponding to Amundsen Sea region and calculate sums 
CPWAIS_mass_data = horzcat(PIG_mass,THWPSK_mass,GetzMBL_mass);
CPWAIS_mass_total = sum(CPWAIS_mass_data,2);
CPWAIS_mass_data_SD = horzcat(PIG_mass_SD,THWPSK_mass_SD,GetzMBL_mass_SD);
CPWAIS_mass_total_SD = rssq(CPWAIS_mass_data_SD,2);
CPWAIS_ice_data = horzcat(PIG_ice,THWPSK_ice,GetzMBL_ice);
CPWAIS_ice_total = sum(CPWAIS_ice_data,2);
CPWAIS_ice_data_SD = horzcat(PIG_ice_SD,THWPSK_ice_SD,GetzMBL_ice_SD);
CPWAIS_ice_total_SD = rssq(CPWAIS_ice_data_SD,2);
CPWAIS_sfc_data = horzcat(PIG_sfc,THWPSK_sfc,GetzMBL_sfc);
CPWAIS_sfc_total = sum(CPWAIS_sfc_data,2);
CPWAIS_sfc_data_SD = horzcat(PIG_sfc_SD,THWPSK_sfc_SD,GetzMBL_sfc_SD);
CPWAIS_sfc_total_SD = rssq(CPWAIS_sfc_data_SD,2);
clearvars -regexp ^PIG_ ^THW ^Getz % clear now unneeded variables 

% Plot GlobalMass mass trends for cental Pacific-facing WAIS 
red = rgb('scarlet'); % Custom colours for plot
deepred = [37 163 111]./255; % Custom colours for plot
gray = rgb('steel'); % Custom colours for plot
blue = rgb('royal blue'); % Custom colours for plot

figure;
dynamics = shadedErrorBar(time,CPWAIS_ice_total,CPWAIS_ice_total_SD,'lineprops',{'b','MarkerFaceColor','g'})
set(dynamics.edge,'LineWidth',1)
dynamics.mainLine.LineWidth = 1;
dynamics.patch.FaceColor = blue;
hold on

ax2 = plot(time, CPWAIS_ice_total,'linewidth',1.5,'color',blue,'DisplayName','Ice dynamics');
sfc = shadedErrorBar(time,CPWAIS_sfc_total,CPWAIS_sfc_total_SD,'lineprops',{'k','MarkerFaceColor','g'})
set(sfc.edge,'LineWidth',1)
sfc.mainLine.LineWidth = 1;
sfc.patch.FaceColor = gray;

ax3 = plot(time, CPWAIS_sfc_total,'linewidth',1.5,'color',gray,'DisplayName','Surface processes');

dm = shadedErrorBar(time,CPWAIS_mass_total,CPWAIS_mass_total_SD,'lineprops',{'r','MarkerFaceColor','g'});
set(dm.edge,'LineWidth',1)
dm.mainLine.LineWidth = 1;
dm.patch.FaceColor = red;
hold on
ax1 = plot(time, CPWAIS_mass_total,'linewidth',2,'color',red,'DisplayName','Total mass change');
xlabel('Year','fontweight','bold');
ylabel('Mass Trend (Gt yr^{-1})','fontweight','bold');
xlim([2002.5 2015.5]);
grid on
legend([ax3 ax2 ax1],'location','southwest');
title('GlobalMass Amundsen Sector'); 

%% Load IMBIE data corresponding to WAIS  
IMBIE_time = 1992:1:2015; % Define IMBIE time 
IMBIE_Gtyr = csvread('FigS8_IMBIE_WAIS_data_Gtyr.csv',1,0);

figure
imbie = shadedErrorBar(IMBIE_time(12:end),IMBIE_Gtyr(12:end,2),IMBIE_Gtyr(12:end,3),'lineprops',{'r','MarkerFaceColor',deepred});
set(imbie.edge,'LineWidth',1)
imbie.mainLine.LineWidth = 2;
imbie.patch.FaceColor = red;
hold on
ax0 = plot(IMBIE_time(12:end)',IMBIE_Gtyr(12:end,2),'color',red,'Linewidth',2,'DisplayName','Total Mass Change');
xlabel('Year','fontweight','bold');
ylabel('Mass Trend (Gt yr^{-1})','fontweight','bold');
xlim([2002.5 2015.5]);
grid on
legend([ax0],'location','southwest');
title('IMBIE WAIS');
