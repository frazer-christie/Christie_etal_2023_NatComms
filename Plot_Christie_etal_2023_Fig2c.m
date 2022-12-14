%% Plot_Christie_etal_2023_Fig2c.m
% This code reads in ERA5 wind and sea ice data, calculates Ekman vertical velocity anomalies and plots Fig. 2c of Christie et al. (Nature Communications, 2023)
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
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to ERA5 data
filename = '<INSERT_ERA5_DATA_FILE_CONTAINING_WIND_AND_SEA_ICE_RECORDS.nc HERE>'; 
era5_lat = double(ncread(filename,'latitude')); % read in grid lat data 
era5_lon = double(ncread(filename,'longitude')); % read in grid lon data
[lat_era5mesh, lon_era5mesh] = meshgrid(era5_lat, era5_lon); % mesh lat/lon grid for later use in Ekman calculations
temp = double(ncread(filename,'time')); 
yeartemp = temp/24+datenum(1900,1,1); % define time
caldate = datestr(yeartemp); % define time 
[year,month] = datevec(yeartemp); % define time
clear temp yeartemp caldate % clear now unneeded variables 

% Load ERA5 wind and sea ice data 
u10 = double(ncread(filename,'u10')); 
u10 = u10(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
v10 = double(ncread(filename,'v10'));
v10 = v10(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
ci = double(ncread(filename,'siconc')); 
ci = ci(:,:,1:444);% times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)

%% Calculate Ekman and Ekman anomaly 
ekman = ekman(lat_era5mesh, lon_era5mesh, u10, v10,'ci',ci,'rho',1027.5); %Optionally parameterise drag coefficient to account for sea ice records read in above
ekmanm = ekman*60*60*24*365.25; % Output in m s-1. Convert to m yr-1
ekmananom = seasonalanoms(ekmanm,year(1:444),month(1:444)); % Calculate Ekman anomalies using year/month indexes equal to that inputted above
      
%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_0308= mean(ekmananom(:,:,289:349),3,'omitnan'); %jan 2003 to jan 2008 (289:349)

%Calculate mean 2003-2008 Ekman anomaly
mean_ekman_anom_1015 = mean(ekmananom(:,:,373:433),3,'omitnan'); %jan 2010 to jan 2015 (373:432) 

%Calc Ekman anomaly difference
DifferenceEkman_anom = mean_ekman_anom_1015 - mean_ekman_anom_0308;
DifferenceEkman_anom_resamp=imresize(DifferenceEkman_anom,[2884,5760],'bilinear'); % Upsample using bilinear interpretation to grid size 2884,5760.

%% Plot Ekman anomaly difference map
figure;
mapzoom(-72,-113,2750);
surfm(era5_lat,era5_lon,DifferenceEkman_anom_resamp);
hold on
bedmap2('patchshelves');
bedmap2('patchgl');
ibcso('contour',[-500 -500],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-1000 -1000],'color','k','ocean','linewidth',1.25);
ibcso('contour',[-1500 -1500],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-2000 -2000],'color',[0.4 0.4 0.4],'ocean');
ibcso('contour',[-2500 -2500],'color',[0.4 0.4 0.4],'ocean');
antmap('graticlue','lats',-85:5:-50,'lons',-135:10:115,'color',.4*[1 1 1],'oceancolor','c');
cmocean('balance',40);
caxis([-10 10]);
c = colorbar('eastoutside');
c.Label.String = '\bf \fontsize{11} Change in Ekman vertical velocity (m yr^{-1})';