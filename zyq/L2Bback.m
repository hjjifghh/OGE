%Modified by zyq 8.13
clear;
clc;
close all;

% 打开文件并读取数据
fileID = fopen('L1B_ST_Processed.txt', 'r');
headerLines = 3; % 跳过前面的注释行和表头行
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
        data = strsplit(line,' '); 
        if numel(data) >= 11 % 确保数据行至少有11个元素（基于提供的列数）
            heights = [heights, str2double(data{1})];
            rv1 = [rv1, str2double(data{3})];
            rv2 = [rv2, str2double(data{6})];
            rv3 = [rv3, str2double(data{9})];
            rv4 = [rv4, str2double(data{12})];
            rv5 = [rv5, str2double(data{15})];
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
rv5(rv5>=2|rv5<-2)=0.5;

flag=0;
for i=1:length(rv1)
if abs(rv1(i))>=abs(rv2(i))+1|abs(rv1(i))<=abs(rv2(i))-1;
    if rv1(i)<0
m=(abs(rv1(i))+abs(rv2(i)))/2;
    
else
    m=-(abs(rv1(i))+abs(rv2(i)))/2;
end
rv1(i)=0-m;
rv2(i)=m;

end
if(isnan(rv1(i))||isnan(rv2(i)))
rv1(i)=NaN;
rv2(i)=NaN;
end
if abs(rv3(i))>=abs(rv4(i))+1|abs(rv3(i))<=abs(rv4(i))-1;
m=(abs(rv3(i))+abs(rv4(i)))/2;
rv3(i)=0-m;
rv4(i)=m;
end
if(isnan(rv3(i))||isnan(rv4(i)))
rv3(i)=NaN;
rv4(i)=NaN;
end
if(isnan(rv5(i))&&flag<3)
    flag=flag+1;
    
    m=i;
end
end

if m>0
for i=m:length(rv5) 
    rv5(i)=NaN;
end
end
% 绘制所有波束的径向速度随高度变化的曲线，同时处理NaN值

% 绘制所有波束的径向速度随高度变化的曲线，坐标轴交换
figure;
%hold on;
%plot(rv1, heights, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Beam 1', 'Marker', 'o');
%plot(rv2, heights, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2', 'Marker', 's');
%plot(rv3, heights, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3', 'Marker', '^');
%plot(rv4, heights, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Beam 4', 'Marker', 'x');
%plot(rv5, heights, 'c-', 'LineWidth', 1.5, 'DisplayName', 'Beam 5', 'Marker', 'd');
plot3(rv1,rv1,heights,'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2', 'Marker', 's');
plot3(rv1,rv2,heights,'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3', 'Marker', 'x');
quiver3(0,0,0,10,rv1(1),rv3(1),rv5(1)*200);
hold on;
for i=2:length(rv1)
quiver3(0,0,heights(i),(rv1(i)+rv2(i))*100,(rv3(i)+rv4(i))*100,rv5(i)*200,"- .",'LineWidth',0.7);
end
% 调整坐标轴显示范围以适应数据
xlim([min([rv1,rv2,rv3,rv4,rv5]), max([rv1,rv2,rv3,rv4,rv5])]);
%ylim([min([rv1,rv2,rv3,rv4,rv5]), max(rv5)]);
% 设置图表属性
xlabel('Radial Velocity (m/s)');
zlabel('Height (m)');
title('Height vs. Radial Velocity for Different Beams');
%legend('show');
grid on;

% 保持坐标轴调整状态并显示图表
hold off;

figure;
hold on;
for i=2:length(rv1)
 quiver(0,heights(i),rv5(i)*900*(-1.4),rv5(i)*900*1.4,'LineWidth',1);
end
grid on;

% 保持坐标轴调整状态并显示图表
hold off;





