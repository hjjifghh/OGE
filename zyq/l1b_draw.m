% 打开文件并读取数据
fileID = fopen('L1B_ST.txt', 'r');
headerLines = 32; % 跳过前面的注释行和表头行
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

% 绘制所有波束的径向速度随高度变化的曲线，同时处理NaN值

% 绘制所有波束的径向速度随高度变化的曲线，坐标轴交换
figure;
plot(rv1, heights, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Beam 1', 'Marker', 'o');
hold on;
plot(rv2, heights, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2', 'Marker', 's');
plot(rv3, heights, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3', 'Marker', '^');
plot(rv4, heights, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Beam 4', 'Marker', 'x');
plot(rv5, heights, 'c-', 'LineWidth', 1.5, 'DisplayName', 'Beam 5', 'Marker', 'd');

% 调整坐标轴显示范围以适应数据
xlim([min([rv1,rv2,rv3,rv4,rv5]), max([rv1,rv2,rv3,rv4,rv5])]);
ylim([min(heights), max(heights)/4]);

% 设置图表属性
xlabel('Radial Velocity (m/s)');
ylabel('Height (m)');
title('Height vs. Radial Velocity for Different Beams');
legend('show');
grid on;

% 保持坐标轴调整状态并显示图表
hold off;