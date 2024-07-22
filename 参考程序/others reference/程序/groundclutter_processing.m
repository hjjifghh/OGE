function psd_data=groundclutter_processing(psd_data)
%   UNTITLED Summary of this function goes here
%   Detailed explanation goes here%   3点槽口滤波
for i=1:127;
y1=psd_data(256,i);  %%%槽口左端所有高度上的值
y2=psd_data(258,i);  %%%槽口右端所有高度上的值
y=(y1+y2)/2;  
psd_data(257,i)=y;
end
end