%% Plot_Christie_etal_2023_FigS7b.m
% This code reads in ERA-Interim wind and ECMWF sea ice data, calculates Ekman vertical velocity anomalies and plots Fig. S7b of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, NJanuary 2023

%% Dependancies
%The code is dependent on the following functions and toolboxes, which either accompany this code or are available at 
% the links/references detailed below:

% MATLAB Mapping Toolbox
% seasonalanoms.m
% Antarctic Mapping Tools and associated add-ons (Greene et al., 2017; https://uk.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools)
% cmocean (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)


%% Code input
%Below, <> symbols denote user input prompt.


%% Code 
clear all; close all;
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to ERA-Interim data
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to sea ice data
filename = '<INSERT_ERA-Interim_DATA_FILE_CONTAINING_WIND_RECORDS.nc HERE>'; 
erai_lat = double(ncread(filename,'latitude')); % read in the data 
erai_lon = double(ncread(filename,'longitude'));
[lat_eraimesh, lon_eraimesh] = meshgrid(erai_lat, erai_lon); % mesh lat/lon grid for later use in Ekman calculations
temp = double(ncread(filename,'time')); 
yeartemp = temp/24+datenum(1900,1,1); % define time
caldate = datestr(yeartemp); % define time 
[year,month] = datevec(yeartemp); % define time
clear temp yeartemp caldate % clear now unneeded variables 

% Load ERA-Interim wind data 
u10 = double(ncread(filename,'u10')); 
u10 = u10(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
v10 = double(ncread(filename,'v10'));
v10 = v10(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)

% Load and clip ECMWF sea ice data records to time of interest (here, I use the ERA5 siconc output which is derived from the passive microwave observations (Fetterer, 2017), and then resize data to match ERA-I
% grid dimensions
ci = double(ncread('INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE','siconc'));
era5_lat = double(ncread('INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE','latitude'));
era5_lon = double(ncread('INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE','longitude'));
ci = ci(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
ci_resamp = imresize3(ci,[480 241 444],'nearest'); % Resize to ERA-I dimensions. Use nearest neighbour interpolation to avoid manipulating values and preserve spatial coverage as much as possible (although edge effects will by default now exist along coastal boundary) 
ci_resamp(ci_resamp>1) = 1; % If using any other interpolation method than 'nearest', convert all interpolated data values falling >1 to 1. 


% figure; subplot(2,1,1);imagesc(ci(:,:,10)'); caxis([.7 1]); title('ERA5 SIC grid') % Optionally plot raw SIC grid
% subplot(2,1,2);imagesc(ci_resamp(:,:,10)'); caxis([.7 1]); title('resized SIC grid - nearest') % Optionally plot resized SIC grid

%% Calculate Ekman and Ekman anomaly
ekman = ekman(lat_eraimesh, lon_eraimesh, u10, v10,'ci',ci_resamp,'rho',1027.5); %Optionally parameterise drag coefficient to account for sea ice records read in above
ekmanm = ekman*60*60*24*365.25; % Output in m s-1. Convert to m yr-1
ekmananom = seasonalanoms(ekmanm,year(1:444),month(1:444)); % times stated above

%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_0308= mean(ekmananom(:,:,289:349),3,'omitnan'); %jan 2003 to jan 2008 (289:349)

%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_1015 = mean(ekmananom(:,:,373:433),3,'omitnan'); %jan 2010 to jan 2015 (373:432) 

%Calc Ekman anomaly difference
DifferenceEkman_anom = mean_ekman_anom_1015 - mean_ekman_anom_0308;

%% Plot Ekman anomaly difference map 
figure;
mapzoom(-72,-113,2750);
surfm(erai_lat,erai_lon,DifferenceEkman_anom);
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
title('ERA-I');
