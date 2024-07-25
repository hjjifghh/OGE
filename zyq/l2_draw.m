%%%基于L2绘制纬向、经向、垂直风速与高度的关系%%%
%%%v0.1 zyq 24.7.25%%%

%初始化
clear;
clc;
close all;

% 提取频率和时间
filepath='E:\郑亦奇2024\test2\参考程序\QZ_L2&solution\mini\OQZQB_MSTR01_AWCN_L2_30M_20240401000000_V01.00_M.TXT';
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

% 过滤缺失值
dataMatrix(dataMatrix == -99999999 | dataMatrix == -9999999) = NaN;

% 过滤可信度小于80的行
validRows = ~isnan(dataMatrix(:, 6)) & (dataMatrix(:, 6) >= 80);
dataMatrix= dataMatrix(validRows, :);

% 提取所需的列
    sh = dataMatrix(:,1); %高度
    ss = dataMatrix(:,2); %风速（无方向）
    sd = dataMatrix(:,3); %风向角度，单位是角度
    sv = dataMatrix(:,4); % 垂直风
 
 %风速风向换算
sx = ss.*sin((sd-180)*pi/180); %纬向风，注意角度向弧度的转换
sy = ss.*cos((sd-180)*pi/180); %经向风

%绘图
figure;
til = tiledlayout(1,3);   %创建三行一列的布局（纬向风、经向风、垂直风）

% 绘制纬向风
nexttile
plot( sx,sh, 'DisplayName', '纬向风');
ylabel('高度 (km)');
xlabel('风速 (m/s)');
title('纬向风速与高度的关系');
grid on;
legend;

% 绘制经向风
nexttile
plot(sy, sh, 'DisplayName', '经向风');
ylabel('高度 (km)');
xlabel('风速 (m/s)');
title('经向风速与高度的关系');
grid on;
legend;

% 绘制垂直风
nexttile
plot( sv, sh,'DisplayName', '垂直风');
ylabel('高度 (km)');
xlabel('风速 (m/s)');
title('垂直风速与高度的关系');
grid on;
legend;
