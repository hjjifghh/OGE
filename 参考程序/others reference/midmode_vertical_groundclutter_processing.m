function psd_data=midmode_vertical_groundclutter_processing(psd_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here%   3��ۿ��˲�
v=5576000/(160*256*128*2);  %%%%
x1=-1*v;
x2=1*v;
for i=1:69
y1=psd_data(128,i);
y2=psd_data(130,i);
x=0;
y=(x-x1)/(x2-x1)*(y2-y1)+y1;
psd_data(129,i)=y;


end
end