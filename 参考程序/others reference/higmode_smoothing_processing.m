function data=higmode_smoothing_processing(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%   3����ֵ�˲�����

[row,column]=size(data);
for a=1:row;       %%%��ֱƽ������   Ҳ���Ǿ�����ƽ��
    for b=2:column-1;
        data(a,b)=(data(a,b-1)+data(a,b)+data(a,b+1))/3;    
    end 
end        
   
for i=1:column;                 %ˮƽ����   ����FFTƽ����
   for j=2:row-1;
       data(j,i)=(data(j-1,i)+data(j,i)+data(j+1,i))/3;
       
    end        
end    

end

