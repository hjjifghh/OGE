function psd_data=lowmode_smoothing_processing(psd_data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%   3����ֵ�˲�����
%for i=1:129;                 %����Ҫ��ֱƽ������������
 %   for j=2:255;
  %      psd_data(j,i)=(psd_data(j-1,i)+psd_data(j,i)+psd_data(j+1,i))/3;
   %     
    %end        
% end
for a=1:256;
    for b=2:128;
        psd_data(a,b)=(psd_data(a,b-1)+psd_data(a,b)+psd_data(a,b+1))/3;    
    end 
end        
    


end

