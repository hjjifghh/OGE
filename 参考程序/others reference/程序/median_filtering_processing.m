function psd_data=median_filtering_processing(psd_data)
% 中值滤波：随机脉冲杂波抑制
% 此处显示详细说明
for i = 1:127
    for iii = 1:510
        ThreePoints = [psd_data(iii,i),psd_data(iii+1,i),psd_data(iii+2,i)];  %%%% 中值滤波：随机脉冲杂波抑制
        psd_data(iii,i) = median(ThreePoints);
    end
end
end

