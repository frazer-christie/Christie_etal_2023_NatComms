%% Plot_Christie_etal_2023_Fig4.m
% This code reads in ERA5 mSLP data, calculates seasonal anomalies and plots Fig. 4 of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
% The code is dependent on the following input datasets, functions and toolboxes, which either accompany this code or are available at 
% the links/references detailed below:

% MATLAB Mapping Toolbox
% seasonalanoms.m
% Antarctic Mapping Tools and associated add-ons (Greene et al., 2017; https://uk.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools)
% cmocean (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)


%% Code input
%Below, <> symbols denote user input prompt.

%% Code 
clear all; close all; 

addpath(genpath('<INSERT FILEPATH HERE>')); % add filepath to ERA5 dataset
filename = '<INSERT ERA5_DATA_FILE_CONTAINING_mSLP_RECORDS.nc HERE>'
era5_lat = double(ncread(filename,'latitude')); % read in the data 
era5_lon = double(ncread(filename,'longitude'));
temp = double(ncread(filename,'time'));
yeartemp = temp/24+datenum(1900,1,1); % define time
caldate = datestr(yeartemp); % define time
[year,month] = datevec(yeartemp); % define time
clear caldate temp yeartemp % clear now unneeded variables 

% Load ERA5 mSLP data 
slp = double(ncread(filename,'msl')); 
slp = slp(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)

%% Calculate seasonal mean mSLP anomalies  
slpanom = seasonalanoms(slp,year(1:444),month(1:444)); % Calculate mSLP anomalies using year/month indexes equal to that inputted above

%Define seasons, and preallocate arrays to record data. 
year_annual = 1979:1:2015; % Year increments in integer years
dataMAM = ones(1440,721,37)*NaN;
MAM = 3:5;
dataJJA = ones(1440,721,37)*NaN;
JJA = 6:8;
dataSON = ones(1440,721,37)*NaN;
SON = 9:11;
dataDJF = ones(1440,721,36)*NaN;
DJF = 12:14;

%Calculate seasonal data
for i = 1:length(year_annual)
    autumn = MAM+12*(i-1);
    dataMAM(:,:,i)= mean(slpanom(:,:,autumn),3,'omitnan');
end

for i = 1:length(year_annual)
    winter = JJA+12*(i-1);
    dataJJA(:,:,i)= mean(slpanom(:,:,winter),3,'omitnan');
end

for i = 1:length(year_annual)
    spring = SON+12*(i-1);
    dataSON(:,:,i)= mean(slpanom(:,:,spring),3,'omitnan');
end

for i = 1:length(year_annual)-1 % Minus 1 as one less complete DJF cycle in year timeseries
    summer = DJF+12*(i-1);
    dataDJF(:,:,i)= mean(slpanom(:,:,summer),3,'omitnan');
end

%% Plot seasonal anomaly differences between 2003-2008 and 2010-2015
%Plot Summer difference
figure;
SLP_0308_DJF = mean(dataDJF(:,:,25:29),3); % Calculate mean SLP across years 2003-2008 
SLP_1015_DJF = mean(dataDJF(:,:,32:36),3); % Calculate mean SLP across years 2010-2015 
SLP_difference_DJF = SLP_1015_DJF-SLP_0308_DJF;

subsubplot(2,2,2,'vpad',0.05,'hpad',0.001);
title({'Austral Summer (DJF)'});
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[-180 180],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,squeeze(SLP_difference_DJF'),'levelstep',10);
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchgl');
bedmap2('patchshelves');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
cmocean('balance',80);
caxis([-400 400]); 

%Plot Autumn difference
SLP_0308_MAM = mean(dataMAM(:,:,25:29),3); % Calculate mean SLP across years 2003-2008 
SLP_1015_MAM = mean(dataMAM(:,:,32:36),3); % Calculate mean SLP across years 2010-2015 
SLP_difference_MAM = SLP_1015_MAM-SLP_0308_MAM;

subsubplot(2,2,3,'vpad',0.05,'hpad',0.001);
title({'Austral Autumn (MAM)'});
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[-180 180],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,squeeze(SLP_difference_MAM'),'levelstep',10);
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchgl');
bedmap2('patchshelves');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
cmocean('balance',80);
caxis([-400 400]);  

%Plot Winter difference
SLP_0308_JJA = mean(dataJJA(:,:,25:29),3); % Calculate mean SLP across years 2003-2008 
SLP_1015_JJA = mean(dataJJA(:,:,32:36),3); % Calculate mean SLP across years 2010-2015  
SLP_difference_JJA = SLP_1015_JJA-SLP_0308_JJA;

subsubplot(2,2,4,'vpad',0.05,'hpad',0.001);
title({'Austral Winter (JJA)'});
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[-180 180],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,squeeze(SLP_difference_JJA'),'levelstep',10);
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchgl');
bedmap2('patchshelves');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
cmocean('balance',80);
caxis([-400 400]);  

%Plot Spring difference
SLP_0308_SON = mean(dataSON(:,:,25:29),3); % Calculate mean SLP across years 2003-2008 
SLP_1015_SON = mean(dataSON(:,:,32:36),3); % Calculate mean SLP across years 2010-2015 
SLP_difference_SON = SLP_1015_SON-SLP_0308_SON;


subsubplot(2,2,1,'vpad',0.05,'hpad',0.001);
title({'Austral Spring (SON)'});
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[-180 180],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,squeeze(SLP_difference_SON'),'levelstep',10);
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchgl');
bedmap2('patchshelves');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
cmap = rgbmap('deep blue','deep blue','blue','cerulean','silver','faded red','scarlet','maroon','maroon',60);
cmocean('balance',80);
caxis([-400 400]);    

%Plot colorbar for figure 
figure;
c = colorbar('eastoutside');
cmocean('balance',80);
caxis([-400 400]);    
c.Label.String = '\bf \fontsize{11} Change in anomalous SLP (Pa)';