function psd_data=higmode_vertical_groundclutter_processing(psd_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here%   5µã²Û¿ÚÂË²¨
v=5576000/(1280*512*8*2);
x1=-v;
x2=v;
for i=1:129;
y1=psd_data(256,i);
y2=psd_data(258,i);
% x=-v;
% y=(x-x1)/(x2-x1)*(y2-y1)+y1;
% psd_data(256,i)=y;
% 
% x=v;
% y=(x-x1)/(x2-x1)*(y2-y1)+y1;
% psd_data(258,i)=y;

x=0;
y=(x-x1)/(x2-x1)*(y2-y1)+y1;
psd_data(257,i)=y;
end
end
