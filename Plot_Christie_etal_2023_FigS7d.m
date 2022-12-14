%% Plot_Christie_etal_2023_FigS7d.m
% This code reads in MERRA2 wind and ECMWF sea ice data, calculates Ekman vertical velocity anomalies and plots Fig. S7d of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
%The code is dependent on the following functions and toolboxes, which either accompany this code or are availble at 
% the links/references detailed below:

% MATLAB Mapping Toolbox
% seasonalanoms.m
% Antarctic Mapping Tools and associated add-ons (Greene et al., 2017; https://uk.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools)
% cmocean (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)


%% Code input
%Below, <> symbols denote user input prompt.


%% Code 
clear all; close all; 
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to MERRA2 data
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to ERA5 data (for time definition below)
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to sea ice data

merra_time = (1980:1/12:2020.99)'; % Define MERRA2 time 
u10 = ncread('<INSERT_MERRA2_DATA_FILE_CONTAINING_WIND_RECORDS.nc HERE','INSERT_MERRA2_U10_VARIABLE_NAME_HERE>');
u10 = u10(:,:,1:480); %Initially clip to end of 2019 to match ERA5 records
v10 = ncread('<INSERT_ERA5_DATA_FILE_CONTAINING_WIND_AND_SEA_ICE_RECORDS.nc HERE','INSERT_MERRA2_U10_VARIABLE_NAME_HERE>');
v10 = v10(:,:,1:480); %Initially clip to end of 2019 to match ERA5 records
lat = ncread('Merra2_v10_Jan1980Dec2020.nc','lat'); % read in grid lat data
lon = ncread('Merra2_v10_Jan1980Dec2020.nc','lon'); % read in grid lon data
[lati, loni] = meshgrid(lat,lon);  % Mesh MERRA2 lat/lon grid for ekman anomaly calculation below. 

% Inherit ERA5 time information for seasonal anomaly calculation (there are many ways in which this could be done, but for simplictly I use a standarised method to that associated with the ERA5 codes) 
filename = '<INSERT_ERA5_DATA_FILE_CONTAINING_TIME_RECORDS.nc HERE>'
temp = double(ncread(filename,'time'));
yeartemp = temp/24+datenum(1900,1,1); % this is matlab days since 1900nc
caldate = datestr(yeartemp); % This creates a list of dates, in string format
[yearERA5,month] = datevec(yeartemp);% This gives you what you actually want!  The year and month.
clear temp yeartemp caldate % clear now unneeded variables 

year = yearERA5(13:end); % Clip ERA5 times to beginning of MERRA2 dataset times (Jan 1980 onwards)
month = month(13:end); % Clip ERA5 times to beginning of MERRA2 dataset times (Jan 1980 onwards)

u10 = u10(:,:,1:432); % Clip dataset to span January 1980 (as close to ERA times as possible) to end 2015 
v10 = v10(:,:,1:432); % Clip dataset to span January 1980 (as close to ERA times as poss) to end 2015

% Load and clip ECMWF sea ice data records to time of interest (here, I use the ERA5 siconc output which is derived from the passive microwave observations (Fetterer, 2017), and then resize data to match MERRA2 grid dimensions
%Importantly, ECMWF sea ice records are centered around 180 degrees whereas the MERRA2 dataset is centered at 0 degrees. The below code also recenters the data. 
ci = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','siconc'));
era5_lat = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','latitude'));
era5_lon = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','longitude'));
ci = ci(:,:,13:444); % Clip sea ice dataset to match temporal extent of MERRA2 dataset (1980 onwards) and clip to end 2015

[latx,lonx,ci_x] = recenter(era5_lat,era5_lon,ci,'center',0); % Recenter/align the sea ice records to the grid structure of MERRA2. 
ci_resamp = imresize3(ci_x,[576 361 432],'nearest'); % Resize sea ice grid to MERRA2 dimensions. Use nearest to avoid incorrect values and preserve spatial coverage as much as possible (although edge effects will by default now exist along coastal boundary) 
ci_resamp(ci_resamp>1) = 1; %If using any other interpolation method than 'nearest', convert all inteprolated data values falling >1 to 1. 
ci_resamp2 = fliplr(ci_resamp); %Finally, flip sea ice records to align with orientation of MERRA2 grid (otherwise sea ice records from an incorrect location will be inputted into the calculation of Ekman below). 

% % Optionally check that the recentering and resampling has worked by comparing sea ice grid with MERRA2 U10 field (maps should look similar)
% figure; imagesc(u10(:,:,1)); title('raw u10'); 
% figure; imagesc(ci_resamp2(:,:,1)); caxis([.7 1]); title('ci resampled & recentered at 0 deg');

%% Calculate Ekman and Ekman anomaly
ekman = ekman(lati, loni, u10, v10,'ci',ci_resamp2,'rho',1027.5); %Optionally parameterise drag coefficient to account for sea ice records read in above
ekmanm = ekman*60*60*24*365.25; % Output in sec-1. Convert to m yr-1
ekmananom = seasonalanoms(ekmanm,year(1:432),month(1:432)); % MERRA2 times Jan 1980-Dec 2015 as above

%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_0308= mean(ekmananom(:,:,277:337),3,'omitnan'); %jan 2003 to jan 2008 

%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_1015 = mean(ekmananom(:,:,361:421),3,'omitnan'); %jan 2010 to jan 2015 

%Calc Ekman anomaly difference
DifferenceEkman_anom = mean_ekman_anom_1015 - mean_ekman_anom_0308;

%% Plot Ekman anomaly difference map 
figure;
mapzoom(-72,-113,2750);
surfm(lat,lon,DifferenceEkman_anom);
hold on
bedmap2('patchshelves');
bedmap2('patchgl');
ibcso('contour',[-500 -500],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-1000 -1000],'color','k','ocean','linewidth',1.25);
ibcso('contour',[-1500 -1500],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-2000 -2000],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-2500 -2500],'color',[0.4 0.4 0.4],'ocean');
antmap('graticlue','lats',-85:5:-50,'lons',-135:10:115,'color',.4*[1 1 1],'oceancolor','c');
c = colorbar('eastoutside');
c.Label.String = '\bf \fontsize{11} Change in Ekman vertical velocity(m yr^{-1})';
cmocean('balance',40);
caxis([-10 10]);
title('MERRA2');
