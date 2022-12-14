%% seasonal_anoms.m
% This function removes the mean of month index (all times) from observed values in a 3D matrix to generate the anomaly. NaN values are omitted by default. 
% Code written by Frazer Christie, Scott Polar Research Institute, University of Cambridge, January 2023, with initial input from Eric Steig. 

function Xanom = seasonalanoms_omitnan(X,year,month)% X can be any 3-D matrix (lat,long,time) 
for i = 1:12 %month index
    k = find(month == i); %month iteration
    tempmean = mean(X(:,:,k),3,'omitnan'); %mean of month index all times 
    tempmean = repmat(tempmean,[1,1,length(k)]); % For use in versions of MATLAB <2016. Replicates mean value of i = 1 for each month defined in k. v2016 onwards does this automatically.  
    Xanom(:,:,k)=X(:,:,k)-tempmean; %observed value - mean.
end

    