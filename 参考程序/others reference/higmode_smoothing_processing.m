function data=higmode_smoothing_processing(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%%%   3点中值滤波处理

[row,column]=size(data);
for a=1:row;       %%%垂直平滑处理   也就是距离门平均
    for b=2:column-1;
        data(a,b)=(data(a,b-1)+data(a,b)+data(a,b+1))/3;    
    end 
end        
   
for i=1:column;                 %水平处理   三点FFT平均。
   for j=2:row-1;
       data(j,i)=(data(j-1,i)+data(j,i)+data(j+1,i))/3;
       
    end        
end    

end

