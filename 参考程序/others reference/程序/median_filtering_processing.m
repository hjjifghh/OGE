function psd_data=median_filtering_processing(psd_data)
% ��ֵ�˲�����������Ӳ�����
% �˴���ʾ��ϸ˵��
for i = 1:127
    for iii = 1:510
        ThreePoints = [psd_data(iii,i),psd_data(iii+1,i),psd_data(iii+2,i)];  %%%% ��ֵ�˲�����������Ӳ�����
        psd_data(iii,i) = median(ThreePoints);
    end
end
end

