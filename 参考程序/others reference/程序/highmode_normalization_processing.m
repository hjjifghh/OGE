function psd_data=highmode_normalization_processing(psd_data)
%   UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   归一化处理

for j=1:127;
    psd_row=psd_data(:,j);
    psd_data_max=max(psd_row);
    psd_data_min=min(psd_row);
    for i=1:512;
        psd_data(i,j)=(psd_data(i,j)-psd_data_min)/(psd_data_max-psd_data_min);
    end      
end
end