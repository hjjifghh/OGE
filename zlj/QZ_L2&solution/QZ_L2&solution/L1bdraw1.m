% 打开文件并读取数据
fileID = fopen('L1B ST.txt', 'r');
headerLines = 22; % 跳过前面的注释行和表头行
fgets(fileID, headerLines); % 跳过前22行

% 初始化变量存储数据
heights = [];
rv1 = [];
rv2 = [];
rv3 = [];
rv4 = [];
rv5 = [];

% 读取数据直到文件结束
while ~feof(fileID)
    line = fgetl(fileID);
    if ~isempty(line) && ~ismember(line(1), {'#', '%'}) % 确保不是注释行或空行
        data = strsplit(line, ' '); 
        if numel(data) >= 11 % 确保数据行至少有11个元素（基于提供的列数）
            heights = [heights, str2double(data{2})];
            rv1 = [rv1, str2double(data{4})];
            rv2 = [rv2, str2double(data{7})];
            rv3 = [rv3, str2double(data{10})];
            rv4 = [rv4, str2double(data{13})];
            rv5 = [rv5, str2double(data{16})];
        end
    end
end
fclose(fileID);

% 过滤缺失值（这里以-9999999作为缺失值的标记，根据实际情况调整）
rv1(rv1 == -9999999) = NaN;
rv2(rv2 == -9999999) = NaN;
rv3(rv3 == -9999999) = NaN;
rv4(rv4 == -9999999) = NaN;
rv5(rv5 == -9999999) = NaN;

% 对径向速度进行平滑处理
windowSize = 5; % 窗口大小可以根据需要调整
rv1_smooth = smoothdata(rv1, 'movmean', windowSize);
rv2_smooth = smoothdata(rv2, 'movmean', windowSize);
rv3_smooth = smoothdata(rv3, 'movmean', windowSize);
rv4_smooth = smoothdata(rv4, 'movmean', windowSize);
rv5_smooth = smoothdata(rv5, 'movmean', windowSize);

% 移除无效值
valid_indices = ~isnan(heights); % 找到有效的高度索引
heights_valid = heights(valid_indices);

% 对所有径向速度数组进行相同的索引处理
rv1_smooth_valid = rv1_smooth(valid_indices);
rv2_smooth_valid = rv2_smooth(valid_indices);
rv3_smooth_valid = rv3_smooth(valid_indices);
rv4_smooth_valid = rv4_smooth(valid_indices);
rv5_smooth_valid = rv5_smooth(valid_indices);

% 插值处理，使用线性插值填补NaN值
heights_interp = linspace(min(heights_valid), max(heights_valid), 100); % 创建插值高度
rv1_interp = interp1(heights_valid, rv1_smooth_valid, heights_interp, 'linear', 'extrap');
rv2_interp = interp1(heights_valid, rv2_smooth_valid, heights_interp, 'linear', 'extrap');
rv3_interp = interp1(heights_valid, rv3_smooth_valid, heights_interp, 'linear', 'extrap');
rv4_interp = interp1(heights_valid, rv4_smooth_valid, heights_interp, 'linear', 'extrap');
rv5_interp = interp1(heights_valid, rv5_smooth_valid, heights_interp, 'linear', 'extrap');

% 绘制所有波束的径向速度随高度变化的曲线
figure;
plot(rv1_interp, heights_interp, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Beam 1', 'Marker', 'o');
hold on;
plot(rv2_interp, heights_interp, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2', 'Marker', 's');
plot(rv3_interp, heights_interp, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3', 'Marker', '^');
plot(rv4_interp, heights_interp, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Beam 4', 'Marker', 'x');
plot(rv5_interp, heights_interp, 'c-', 'LineWidth', 1.5, 'DisplayName', 'Beam 5', 'Marker', 'd');

% 设置坐标轴显示范围
xlim([-100, 100]); % 根据需要调整X轴范围
ylim([min(heights_valid), max(heights_valid)]); % 根据高度数据调整Y轴范围

% 设置图表属性
xlabel('Radial Velocity (m/s)');
ylabel('Height (m)');
title('Height vs. Radial Velocity for Different Beams');
legend('show');
grid on;

% 保持坐标轴调整状态并显示图表
hold off;