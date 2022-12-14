%% Plot_Christie_etal_2023_Fig3a.m
% This code reads in CMEMS GREP data, extracts data over the area of interest and plots Fig. 3a of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
%The code is dependent on the following input datasets, functions and toolboxes, which either accompany this code or are available at 
% the links/references detailed below:

% Fig3_BellingshausenCS_point_mask.csv (provided with code)
% Antarctic Mapping Tools and associated add-ons (Greene et al., 2017; https://uk.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools)
% cmocean (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)


%% Code input
%Below, <> symbols denote user input prompt.


%% Code 
clear all; close all; 
addpath(genpath('<INSERT FILEPATH HERE>'));

%  Read in area of interest bounding box coordinates (EPSG:3031) and convert to lat/long
roi_points = csvread('Fig3_BellingshausenCS_point_mask.csv',1,0); %Bellingshausen Sea continetal shelf mask. Points in Polar Stereographic.

[roi_lat, roi_lon] = ps2ll(roi_points(:,1),roi_points(:,2)); %Convert to lat/long
clear roi_points % clear now unneeded variables 

% Load GREP grid and find all cells falling within area of interest 
lat = double(ncread('<INSERT_FILE_NAME_HERE.nc>','latitude'));
lon = double(ncread('<INSERT_FILE_NAME_HERE.nc>','longitude'));
[lati, loni] = meshgrid(lat,lon);
[maskin, maskout] = inpolygon(lati,loni,roi_lat,roi_lon); % Use MATLAB 'maskin' function to find cells

masknan_in = double(maskin); % Generate logical mask containing RoI PM grid cells N.B. Logical values (1,0) cannot be converted to NaN, but doubles can.
masknan_in(masknan_in==0) = NaN; % Convert zeroes to NaN.

%Load GREP potential temperature data, and clip to mask limits
T = ncread('<INSERT_FILE_NAME_HERE.nc>','thetao_mean');
T = T.*masknan_in; 

%Load GREP salinity data, and clip to mask limits
S = ncread('<INSERT_FILE_NAME_HERE.nc>','so_mean');
S = S.*masknan_in;

%Load Depth and Time Info
depth = ncread('<INSERT_FILE_NAME_HERE.nc>','depth');
time = (2001:1/12:2015.99)';

% Plot hovmoller plot of temp, salinity and depth
Sprofile_shelf_timeseries = median(median(S(:,:,:,:),1,'omitnan'),2,'omitnan'); % First, calculate salinity timeseries for superimposing over Temp timeseries below. Average over lon, then lat
Tprofile_shelf_timeseries = median(median(T(:,:,:,:),1,'omitnan'),2,'omitnan'); % Next, do same for potential temperature.

figure
contourf(time,-depth,squeeze(Tprofile_shelf_timeseries),'levels',.01,'linewidth',0.1,'linecolor',[0.4 0.4 0.4],'edgecolor','none') 
colorbar('eastoutside');
cmocean('balance',40);
caxis([-1.6 1.6]);
ylim([-800 -20]);
ax = gca;
set(ax,'xticklabel',[])
hold on
contour(time,-depth,squeeze(Sprofile_shelf_timeseries),[34.62,34.62],'linewidth',1.5,'linecolor',[0.2 0.2 0.2],'linestyle','-'); %UCDW (mCDW) limit following http://www.ccpo.odu.edu/~klinck/Reprints/PDF/dinnimanJClim2012.pdf
contour(time,-depth,squeeze(Tprofile_shelf_timeseries),[0,0],'linewidth',1.5,'linecolor',[0.6 0.6 0.6],'linestyle','-'); %zero degree thermocline
hline = yline(-316); %mean depth of GL at region of interest from IBCSO (Arndt et al., 2013)
hline.Color='w';
hline.LineWidth=1;
patchx = [2003 2008 2008 2003];
patchy = [-1000 -1000 0 0];
patch(patchx,patchy,[0.8 0.8 0.8],'edgecolor','none','linestyle','--','linewidth',1,'facealpha',0.25);
patchx = [2010 2015 2015 2010];
patchy = [-1000 -1000 0 0];
patch(patchx,patchy,[0.8 0.8 0.8],'edgecolor','none','linestyle','--','linewidth',1,'facealpha',0.25);
grid on
ylabel('Depth (m)','fontweight','bold');


% Next, calculate mean T >0oC and >mean GL depth for both periods
GL_depth = 316; %mean depth of GL at region of interest from IBCSO (Arndt et al., 2013)
depth_tmask = depth<=GL_depth; %First, find all depths lower than mean depth of GL (note: depth is positive in GREP model notation)

%Now mask all data colder than 0oC (the surface layer) 
T_warm_watermask = Tprofile_shelf_timeseries;
T_warm_watermask(T_warm_watermask<0) = NaN; 

%Then extract all heights above mean GL depth 
T_warm_water_depth_masked = squeeze(T_warm_watermask(:,:,depth_tmask,:));

% Calculate mean temperature for each time period
Tmedian_20032008 = round(mean(mean(T_warm_water_depth_masked(:,25:85),'omitnan')),2); 
Tmedian_20102015 = round(mean(mean(T_warm_water_depth_masked(:,109:169),'omitnan')),2); 
Tmedian_20102014 = round(mean(mean(T_warm_water_depth_masked(:,109:157),'omitnan')),2); % clipped to 2014 to negate effect of unrealistic dip seen during c. 2015
deltaTmedian0315 = round(Tmedian_20102015-Tmedian_20032008,2); % Change in meanT 
deltaTmedian0314 = round(Tmedian_20102014-Tmedian_20032008,2);



