%% Plot_Christie_etal_2023_Fig2ab.m
% This code reads in ERA5 mSLP data, calculates anomalies and plots Fig. 2a and b of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

%% Dependancies
%The code is dependent on the following functions and toolboxes, which either accompany this code or are available at 
% the links/references detailed below:

% MATLAB Mapping Toolbox
% seasonalanoms.m
% Antarctic Mapping Tools and associated add-ons (Greene et al., 2017; https://uk.mathworks.com/matlabcentral/fileexchange/47638-antarctic-mapping-tools)
% Climate Data Tools (Greene et al., 2019; https://uk.mathworks.com/matlabcentral/fileexchange/70338-climate-data-toolbox-for-matlab)
% cmocean (https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps)
% circlem (https://uk.mathworks.com/matlabcentral/fileexchange/48122-circlem)

%% Code input
%Below, <> symbols denote user input prompt.

%% Code 
clear all; close all;
addpath(genpath('<INSERT FILEPATH HERE>')) %Add path to ERA5 data
filename = '<INSERT_ERA5_DATA_FILE.nc HERE>'
era5_lat = double(ncread(filename,'latitude')); 
era5_lon = double(ncread(filename,'longitude'));
temp = double(ncread(filename,'time')); 
yeartemp = temp/24+datenum(1900,1,1); %define time
caldate = datestr(yeartemp); %define time 
[year,month] = datevec(yeartemp); %define time

%Load SLP data 
slp = double(ncread(filename,'msl')); % Load mSLP data 
slp = slp(:,:,1:444); %times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
slpanom = seasonalanoms(slp,year(1:444),month(1:444)); % Calculate mSLP anomalies using year/month indexes equal to that inputted above
      
%Calculate mean 2003-2008 mSLP anomaly 
meanSLP0308 = mean(slpanom(:,:,289:349),3,'omitnan'); %jan 2003 to jan 2008 (289:349)

%Calculate mean 2010-2015 mSLP anomaly 
meanSLP1015 = mean(slpanom(:,:,373:433),3,'omitnan'); %jan 2010 to jan 2015 (373:432)    

%Calculate difference
DifferenceSLP = meanSLP1015 - meanSLP0308;

%Plot mean mSLP 2003-2008
figure; 
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[1 360],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,meanSLP0308','levelstep',10);
set(gca,'Color',[217 217 217]./255);
hold on
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchshelves');
bedmap2('patchgl');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
c = colorbar('southoutside');
c.Label.String = '\bf \fontsize{11} Mean SLP anomaly (Pa)';
cmocean('balance',40);
caxis([-100 100])

%Plot mean mSLP 2010-2015
figure; 
axesm('eqdazim','MapLatLimit',[-90 -50],'FLatLimit',[],'MapLonLimit',[1 360],'FLonLimit',[-180 180],'Origin',[-90 180]);
contourm(era5_lat,era5_lon,meanSLP1015','levelstep',10);
set(gca,'Color',[217 217 217]./255);
hold on
bordersm('countries','facecolor',.6*[1 1 1],'edgecolor',.3*[1 1 1]);
bedmap2('patchshelves');
bedmap2('patchgl');
ibcso('contour',[-1000 -1000],'color',.3*[1 1 1],'ocean','linewidth',1);
c = colorbar('southoutside');
c.Label.String = '\bf \fontsize{11} Mean SLP anomaly (Pa)';
cmocean('balance',40);
caxis([-100 100])
gradientlat = -71.2;
gradientlon = 243.8;
plotm(gradientlat, gradientlon,'s','color','k','markerfacecolor','k','linewidth',1);
ASLlat = -65.7;
ASLlon = 245;
hold on
plotm(ASLlat, ASLlon,'+','color','k','markerfacecolor','k','linewidth',1.25);
circlem(ASLlat, ASLlon, 1000,'linestyle','--','linewidth',1.5);