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

% 绘制所有波束的径向速度随高度变化的曲线
% 过滤缺失值（这里以-9999999作为缺失值的标记，根据实际情况调整）
rv1(rv1 == -9999999) = NaN;
rv2(rv2 == -9999999) = NaN;
rv3(rv3 == -9999999) = NaN;
rv4(rv4 == -9999999) = NaN;
rv5(rv5 == -9999999) = NaN;

% 绘制所有波束的径向速度随高度变化的曲线，坐标轴交换
figure;
plot(rv1, heights, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Beam 1', 'Marker', 'o');
hold on;
plot(rv2, heights, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2', 'Marker', 's');
plot(rv3, heights, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3', 'Marker', '^');
plot(rv4, heights, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Beam 4', 'Marker', 'x');
plot(rv5, heights, 'c-', 'LineWidth', 1.5, 'DisplayName', 'Beam 5', 'Marker', 'd');

% 计算有效的径向速度范围，排除NaN值
valid_rv = [rv1; rv2; rv3; rv4; rv5]; % 合并所有径向速度
valid_rv = valid_rv(~isnan(valid_rv)); % 过滤NaN值

% 计算有效的高度范围，排除NaN值
valid_heights = heights(~isnan(heights)); % 过滤NaN值

% 调整坐标轴显示范围以适应数据
if ~isempty(valid_rv) % 确保有效数据不为空
    xlim([min(valid_rv), max(valid_rv)]);
else
    xlim([-1, 1]); % 如果没有有效数据，设置默认范围
end

if ~isempty(valid_heights) % 确保有效高度数据不为空
    ylim([min(valid_heights), max(valid_heights)/4]);
else
    ylim([0, 1]); % 如果没有有效高度数据，设置默认范围
end

% 设置图表属性
xlabel('Radial Velocity (m/s)');
ylabel('Height (m)');
title('Height vs. Radial Velocity for Different Beams');
legend('show');
grid on;

% 保持坐标轴调整状态并显示图表
hold off;