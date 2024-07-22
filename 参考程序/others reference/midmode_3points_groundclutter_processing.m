function psd_data=midmode_3points_groundclutter_processing(psd_data)
%UNTITLED Summary of this function goes here 
%   Detailed explanation goes here%   5µã²Û¿ÚÂË²¨ 
[m,n]=size(psd_data);
v=5576000/(320*m*64*2);
 x1=-v;
 x2=v;
%x1=-v;
%x2=v;
for i=1:n;
y1=psd_data(m/2,i);
y2=psd_data(m/2+2,i);
%y1=psd_data(128,i);
%y2=psd_data(130,i);
     x=0;
      y=(x-x1)/(x2-x1)*(y2-y1)+y1;
     psd_data(m/2+1,i)=y;
end
end



