%% Plot_Christie_etal_2023_FigS7c.m
% This code reads in JRA-55 wind and ECMWF sea ice data, calculates Ekman vertical velocity anomalies and plots Fig. S7c of Christie et al. (Nature Communications, 2023)
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023

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
clear all; close all
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to JRA-55 data
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to ERA5 data (for time definition below)
addpath(genpath('<INSERT FILEPATH HERE>')) % Add path to sea ice data

% Load and concatenate u10 and v10 data into two single matrices (here, I call the monthly records contained in annual .nc files obtained directly from the JRA-55 data source) 
u10_1979 = ncread('anl_surf.033_ugrd.reg_tl319.197901_197912.nc','UGRD_GDS4_HTGL_S123');
u10_1980 = ncread('anl_surf.033_ugrd.reg_tl319.198001_198012.nc','UGRD_GDS4_HTGL_S123');
u10_1981 = ncread('anl_surf.033_ugrd.reg_tl319.198101_198112.nc','UGRD_GDS4_HTGL_S123');
u10_1982 = ncread('anl_surf.033_ugrd.reg_tl319.198201_198212.nc','UGRD_GDS4_HTGL_S123');
u10_1983 = ncread('anl_surf.033_ugrd.reg_tl319.198301_198312.nc','UGRD_GDS4_HTGL_S123');
u10_1984 = ncread('anl_surf.033_ugrd.reg_tl319.198401_198412.nc','UGRD_GDS4_HTGL_S123');
u10_1985 = ncread('anl_surf.033_ugrd.reg_tl319.198501_198512.nc','UGRD_GDS4_HTGL_S123');
u10_1986 = ncread('anl_surf.033_ugrd.reg_tl319.198601_198612.nc','UGRD_GDS4_HTGL_S123');
u10_1987 = ncread('anl_surf.033_ugrd.reg_tl319.198701_198712.nc','UGRD_GDS4_HTGL_S123');
u10_1988 = ncread('anl_surf.033_ugrd.reg_tl319.198801_198812.nc','UGRD_GDS4_HTGL_S123');
u10_1989 = ncread('anl_surf.033_ugrd.reg_tl319.198901_198912.nc','UGRD_GDS4_HTGL_S123');
u10_1990 = ncread('anl_surf.033_ugrd.reg_tl319.199001_199012.nc','UGRD_GDS4_HTGL_S123');
u10_1991 = ncread('anl_surf.033_ugrd.reg_tl319.199101_199112.nc','UGRD_GDS4_HTGL_S123');
u10_1992 = ncread('anl_surf.033_ugrd.reg_tl319.199201_199212.nc','UGRD_GDS4_HTGL_S123');
u10_1993 = ncread('anl_surf.033_ugrd.reg_tl319.199301_199312.nc','UGRD_GDS4_HTGL_S123');
u10_1994 = ncread('anl_surf.033_ugrd.reg_tl319.199401_199412.nc','UGRD_GDS4_HTGL_S123');
u10_1995 = ncread('anl_surf.033_ugrd.reg_tl319.199501_199512.nc','UGRD_GDS4_HTGL_S123');
u10_1996 = ncread('anl_surf.033_ugrd.reg_tl319.199601_199612.nc','UGRD_GDS4_HTGL_S123');
u10_1997 = ncread('anl_surf.033_ugrd.reg_tl319.199701_199712.nc','UGRD_GDS4_HTGL_S123');
u10_1998 = ncread('anl_surf.033_ugrd.reg_tl319.199801_199812.nc','UGRD_GDS4_HTGL_S123');
u10_1999 = ncread('anl_surf.033_ugrd.reg_tl319.199901_199912.nc','UGRD_GDS4_HTGL_S123');
u10_2000 = ncread('anl_surf.033_ugrd.reg_tl319.200001_200012.nc','UGRD_GDS4_HTGL_S123');
u10_2001 = ncread('anl_surf.033_ugrd.reg_tl319.200101_200112.nc','UGRD_GDS4_HTGL_S123');
u10_2002 = ncread('anl_surf.033_ugrd.reg_tl319.200201_200212.nc','UGRD_GDS4_HTGL_S123');
u10_2003 = ncread('anl_surf.033_ugrd.reg_tl319.200301_200312.nc','UGRD_GDS4_HTGL_S123');
u10_2004 = ncread('anl_surf.033_ugrd.reg_tl319.200401_200412.nc','UGRD_GDS4_HTGL_S123');
u10_2005 = ncread('anl_surf.033_ugrd.reg_tl319.200501_200512.nc','UGRD_GDS4_HTGL_S123');
u10_2006 = ncread('anl_surf.033_ugrd.reg_tl319.200601_200612.nc','UGRD_GDS4_HTGL_S123');
u10_2007 = ncread('anl_surf.033_ugrd.reg_tl319.200701_200712.nc','UGRD_GDS4_HTGL_S123');
u10_2008 = ncread('anl_surf.033_ugrd.reg_tl319.200801_200812.nc','UGRD_GDS4_HTGL_S123');
u10_2009 = ncread('anl_surf.033_ugrd.reg_tl319.200901_200912.nc','UGRD_GDS4_HTGL_S123');
u10_2010 = ncread('anl_surf.033_ugrd.reg_tl319.201001_201012.nc','UGRD_GDS4_HTGL_S123');
u10_2011 = ncread('anl_surf.033_ugrd.reg_tl319.201101_201112.nc','UGRD_GDS4_HTGL_S123');
u10_2012 = ncread('anl_surf.033_ugrd.reg_tl319.201201_201212.nc','UGRD_GDS4_HTGL_S123');
u10_2013 = ncread('anl_surf.033_ugrd.reg_tl319.201301_201312.nc','UGRD_GDS4_HTGL_S123');
u10_2014 = ncread('anl_surf.033_ugrd.reg_tl319.201401_201412.nc','UGRD_GDS4_HTGL_S123');
u10_2015 = ncread('anl_surf.033_ugrd.reg_tl319.201501_201512.nc','UGRD_GDS4_HTGL_S123');
u10_2016 = ncread('anl_surf.033_ugrd.reg_tl319.201601_201612.nc','UGRD_GDS4_HTGL_S123');
u10_2017 = ncread('anl_surf.033_ugrd.reg_tl319.201701_201712.nc','UGRD_GDS4_HTGL_S123');
u10_2018 = ncread('anl_surf.033_ugrd.reg_tl319.201801_201812.nc','UGRD_GDS4_HTGL_S123');
u10_2019 = ncread('anl_surf.033_ugrd.reg_tl319.201901_201912.nc','UGRD_GDS4_HTGL_S123');
u10_2020 = ncread('anl_surf.033_ugrd.reg_tl319.202001_202012.nc','UGRD_GDS4_HTGL_S123');

u10_alltimes = cat(3, u10_1979, u10_1980,u10_1981,u10_1982,u10_1983,u10_1984,u10_1985,u10_1986,u10_1987,u10_1988,u10_1989,...
    u10_1990,u10_1991,u10_1992,u10_1993,u10_1994,u10_1995,u10_1996,u10_1997,u10_1998,u10_1999,u10_2000,u10_2001,u10_2002,...
    u10_2003,u10_2004,u10_2005,u10_2006,u10_2007,u10_2008,u10_2009,u10_2010,u10_2011,u10_2012,u10_2013,u10_2014,u10_2015,...
    u10_2016,u10_2017,u10_2018,u10_2019,u10_2020);

clear u10_19* u10_20* % clear now unneeded variables 


v10_1979 = ncread('anl_surf.034_vgrd.reg_tl319.197901_197912.nc','VGRD_GDS4_HTGL_S123');
v10_1980 = ncread('anl_surf.034_vgrd.reg_tl319.198001_198012.nc','VGRD_GDS4_HTGL_S123');
v10_1981 = ncread('anl_surf.034_vgrd.reg_tl319.198101_198112.nc','VGRD_GDS4_HTGL_S123');
v10_1982 = ncread('anl_surf.034_vgrd.reg_tl319.198201_198212.nc','VGRD_GDS4_HTGL_S123');
v10_1983 = ncread('anl_surf.034_vgrd.reg_tl319.198301_198312.nc','VGRD_GDS4_HTGL_S123');
v10_1984 = ncread('anl_surf.034_vgrd.reg_tl319.198401_198412.nc','VGRD_GDS4_HTGL_S123');
v10_1985 = ncread('anl_surf.034_vgrd.reg_tl319.198501_198512.nc','VGRD_GDS4_HTGL_S123');
v10_1986 = ncread('anl_surf.034_vgrd.reg_tl319.198601_198612.nc','VGRD_GDS4_HTGL_S123');
v10_1987 = ncread('anl_surf.034_vgrd.reg_tl319.198701_198712.nc','VGRD_GDS4_HTGL_S123');
v10_1988 = ncread('anl_surf.034_vgrd.reg_tl319.198801_198812.nc','VGRD_GDS4_HTGL_S123');
v10_1989 = ncread('anl_surf.034_vgrd.reg_tl319.198901_198912.nc','VGRD_GDS4_HTGL_S123');
v10_1990 = ncread('anl_surf.034_vgrd.reg_tl319.199001_199012.nc','VGRD_GDS4_HTGL_S123');
v10_1991 = ncread('anl_surf.034_vgrd.reg_tl319.199101_199112.nc','VGRD_GDS4_HTGL_S123');
v10_1992 = ncread('anl_surf.034_vgrd.reg_tl319.199201_199212.nc','VGRD_GDS4_HTGL_S123');
v10_1993 = ncread('anl_surf.034_vgrd.reg_tl319.199301_199312.nc','VGRD_GDS4_HTGL_S123');
v10_1994 = ncread('anl_surf.034_vgrd.reg_tl319.199401_199412.nc','VGRD_GDS4_HTGL_S123');
v10_1995 = ncread('anl_surf.034_vgrd.reg_tl319.199501_199512.nc','VGRD_GDS4_HTGL_S123');
v10_1996 = ncread('anl_surf.034_vgrd.reg_tl319.199601_199612.nc','VGRD_GDS4_HTGL_S123');
v10_1997 = ncread('anl_surf.034_vgrd.reg_tl319.199701_199712.nc','VGRD_GDS4_HTGL_S123');
v10_1998 = ncread('anl_surf.034_vgrd.reg_tl319.199801_199812.nc','VGRD_GDS4_HTGL_S123');
v10_1999 = ncread('anl_surf.034_vgrd.reg_tl319.199901_199912.nc','VGRD_GDS4_HTGL_S123');
v10_2000 = ncread('anl_surf.034_vgrd.reg_tl319.200001_200012.nc','VGRD_GDS4_HTGL_S123');
v10_2001 = ncread('anl_surf.034_vgrd.reg_tl319.200101_200112.nc','VGRD_GDS4_HTGL_S123');
v10_2002 = ncread('anl_surf.034_vgrd.reg_tl319.200201_200212.nc','VGRD_GDS4_HTGL_S123');
v10_2003 = ncread('anl_surf.034_vgrd.reg_tl319.200301_200312.nc','VGRD_GDS4_HTGL_S123');
v10_2004 = ncread('anl_surf.034_vgrd.reg_tl319.200401_200412.nc','VGRD_GDS4_HTGL_S123');
v10_2005 = ncread('anl_surf.034_vgrd.reg_tl319.200501_200512.nc','VGRD_GDS4_HTGL_S123');
v10_2006 = ncread('anl_surf.034_vgrd.reg_tl319.200601_200612.nc','VGRD_GDS4_HTGL_S123');
v10_2007 = ncread('anl_surf.034_vgrd.reg_tl319.200701_200712.nc','VGRD_GDS4_HTGL_S123');
v10_2008 = ncread('anl_surf.034_vgrd.reg_tl319.200801_200812.nc','VGRD_GDS4_HTGL_S123');
v10_2009 = ncread('anl_surf.034_vgrd.reg_tl319.200901_200912.nc','VGRD_GDS4_HTGL_S123');
v10_2010 = ncread('anl_surf.034_vgrd.reg_tl319.201001_201012.nc','VGRD_GDS4_HTGL_S123');
v10_2011 = ncread('anl_surf.034_vgrd.reg_tl319.201101_201112.nc','VGRD_GDS4_HTGL_S123');
v10_2012 = ncread('anl_surf.034_vgrd.reg_tl319.201201_201212.nc','VGRD_GDS4_HTGL_S123');
v10_2013 = ncread('anl_surf.034_vgrd.reg_tl319.201301_201312.nc','VGRD_GDS4_HTGL_S123');
v10_2014 = ncread('anl_surf.034_vgrd.reg_tl319.201401_201412.nc','VGRD_GDS4_HTGL_S123');
v10_2015 = ncread('anl_surf.034_vgrd.reg_tl319.201501_201512.nc','VGRD_GDS4_HTGL_S123');
v10_2016 = ncread('anl_surf.034_vgrd.reg_tl319.201601_201612.nc','VGRD_GDS4_HTGL_S123');
v10_2017 = ncread('anl_surf.034_vgrd.reg_tl319.201701_201712.nc','VGRD_GDS4_HTGL_S123');
v10_2018 = ncread('anl_surf.034_vgrd.reg_tl319.201801_201812.nc','VGRD_GDS4_HTGL_S123');
v10_2019 = ncread('anl_surf.034_vgrd.reg_tl319.201901_201912.nc','VGRD_GDS4_HTGL_S123');
v10_2020 = ncread('anl_surf.034_vgrd.reg_tl319.202001_202012.nc','VGRD_GDS4_HTGL_S123');

v10_alltimes = cat(3, v10_1979, v10_1980,v10_1981,v10_1982,v10_1983,v10_1984,v10_1985,v10_1986,v10_1987,v10_1988,v10_1989,...
    v10_1990,v10_1991,v10_1992,v10_1993,v10_1994,v10_1995,v10_1996,v10_1997,v10_1998,v10_1999,v10_2000,v10_2001,v10_2002,...
    v10_2003,v10_2004,v10_2005,v10_2006,v10_2007,v10_2008,v10_2009,v10_2010,v10_2011,v10_2012,v10_2013,v10_2014,v10_2015,...
    v10_2016,v10_2017,v10_2018,v10_2019,v10_2020);

clear v10_19* v10_20* % clear now unneeded variables 

u10 = u10_alltimes(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
v10 = v10_alltimes(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)

lat = double(ncread('anl_surf.034_vgrd.reg_tl319.202001_202012.nc','g4_lat_1')); % read in grid lat data
lon = double(ncread('anl_surf.034_vgrd.reg_tl319.202001_202012.nc','g4_lon_2')); % read in grid lon data
[lati,loni] = meshgrid(lat,lon); % Mesh lat/lon for later use in Ekman calculations
time = (1979:1/12:2020.99)'; % Define time

% Inherit ERA5 time information for seasonal anomaly calculation (there are many ways in which this could be done, but for simplictly I use a standarised method to that associated with the ERA5 codes) 
filename = '<INSERT_ERA5_DATA_FILE_CONTAINING_TIME_RECORDS.nc HERE>'
temp = double(ncread(filename,'time'));
yeartemp = temp/24+datenum(1900,1,1); % this is matlab days since 1900nc
caldate = datestr(yeartemp); % This creates a list of dates, in string format
[year,month] = datevec(yeartemp);% This gives you what you actually want!  The year and month.
clear temp yeartemp caldate % clear now unneeded variables 

% Load and clip ECMWF sea ice data records to time of interest (here, I use the ERA5 siconc output which is derived from the passive microwave observations (Fetterer, 2017), and then resize data to match JRA-55 grid dimensions
ci = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','siconc'));
era5_lat = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','latitude'));
era5_lon = double(ncread('<INSERT_ERA5_DATA_FILE_SEAICE_RECORDS_AND_GRID_INFO.nc HERE>','longitude'));
ci = ci(:,:,1:444); % times in dataset spanning Jan 1979 to end 2015 (will need changed according to user file contents)
ci_resamp = imresize3(ci,[640 320 444],'nearest'); %Resize to JRA-55 dimensions. Use nearest to avoid incorrect values and preserve spatial coverage as much as possible (although edge effects will by default now exist along coastal boundary) 
ci_resamp(ci_resamp>1) = 1; %If using any other interpolation method than 'nearest', convert all inteprolated data values falling >1 to 1. 

% figure; subplot(2,1,1);imagesc(ci(:,:,10)'); caxis([.7 1]); title('ERA5 SIC grid') % Optionally plot raw SIC grid
% subplot(2,1,2);imagesc(ci_resamp(:,:,10)'); caxis([.7 1]); title('resized SIC grid - nearest') % Optionally plot resized SIC grid

%% Calculate Ekman and Ekman anomaly
ekman = ekman(lat, lon, u10, v10,'ci',ci_resamp,'rho',1027.5); %Optionally parameterise drag coefficient to account for sea ice records read in above
ekmanm = ekman*60*60*24*365.25; % Output in sec-1. Convert to m yr-1
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
title('JRA-55');
