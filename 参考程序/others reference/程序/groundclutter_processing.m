function psd_data=groundclutter_processing(psd_data)
%   UNTITLED Summary of this function goes here
%   Detailed explanation goes here%   3��ۿ��˲�
for i=1:127;
y1=psd_data(256,i);  %%%�ۿ�������и߶��ϵ�ֵ
y2=psd_data(258,i);  %%%�ۿ��Ҷ����и߶��ϵ�ֵ
y=(y1+y2)/2;  
psd_data(257,i)=y;
end
end