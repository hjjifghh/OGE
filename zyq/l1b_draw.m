clear;
clc;
close all;

% 打开文件并读取数据
filepath='L1B ST.txt';

% 初始化变量存储数据
heights = [];
rv1 = [];
rv2 = [];
rv3 = [];
rv4 = [];
rv5 = [];

fileID = fopen(filepath);

for i = 1:9
    fg = fgetl(fileID);
end
time = fg(17:32);
for i = 1:5
    fg = fgetl(fileID);
end
freq = fg(19:26);

fclose(fileID);

% 使用 readmatrix 读取数据
dataMatrix = readmatrix(filepath, 'HeaderLines', 32, 'CommentStyle', '#');

% 提取所需的列
heights = dataMatrix(:, 1);
rv1 = dataMatrix(:, 3);
rv2 = dataMatrix(:, 6);
rv3 = dataMatrix(:, 9);
rv4 = dataMatrix(:, 12);
rv5 = dataMatrix(:, 15);

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
xlim([min([rv1,rv2,rv3,rv4,rv5],[], 'all'), max([rv1,rv2,rv3,rv4,rv5],[], 'all')]);
ylim([min(heights, [],'all'), max(heights,[], 'all')/4]);

% 设置图表属性
xlabel('Radial Velocity (m/s)');
ylabel('Height (m)');
gap=' '
title([time gap freq]);
legend('show');
grid on;

% 保持坐标轴调整状态并显示图表
hold off;