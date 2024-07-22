% 读取原始数据文件
filename = 'L1B ST.txt';
fileID = fopen(filename, 'r');
header = fgetl(fileID); % 读取首行注释
data = textscan(fileID, '%*s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f', 'HeaderLines', 2);
fclose(fileID);

% 提取并校验速度数据
heights = data{1}; % 高度
rv1 = data{2}; % Beam1的径向速度
rv2 = data{3}; % Beam2的径向速度
rv3 = data{4}; % Beam3的径向速度
rv4 = data{5}; % Beam4的径向速度
rv5 = data{6}; % Beam5的径向速度

% 校正数据
for i = 1:length(heights)
    % 理论上Beam1和Beam2，Beam3和Beam4的径向速度为相反数
    if isnan(rv1(i)) || isnan(rv2(i)) % 跳过无效值
        continue;
    elseif abs(rv1(i) + rv2(i)) > 1e-6 % 这里设定一个容差，用于判断是否需要矫正
        % 根据两个Beam的均值进行矫正，实际中可能需要更复杂的逻辑
        avgRv = (abs(rv1(i)) + abs(rv2(i))) / 2;
        rv1(i) = sign(rv1(i)) * avgRv;
        rv2(i) = -sign(rv2(i)) * avgRv;
    end
    if isnan(rv3(i)) || isnan(rv4(i))
        continue;
    elseif abs(rv3(i) + rv4(i)) > 1e-3
        avgRv = (abs(rv3(i)) + abs(rv4(i))) / 2;
        rv3(i) = sign(rv3(i)) * avgRv;
        rv4(i) = -sign(rv4(i)) * avgRv;
    end
end

% 平滑处理：这里简单示例，实际可能需要更精细的算法
for beam = 1:5
    rv = data{(beam+1)}; % 依次选择rv1到rv5
    for i = 2:length(heights)-1
        if isnan(rv(i)) % 跳过无效值
            continue;
        end
        % 简单的前向后向平滑
        rv(i) = (rv(i-1) + rv(i) + rv(i+1)) / 3;
    end
    data{(beam+1)} = rv; % 更新回原数据结构
end

% 写入新文件
newFilename = 'L1B_ST_Processed.txt';
fileID = fopen(newFilename, 'w');
fprintf(fileID, '%s\n', header); % 写入原始头部信息
fprintf(fileID, '%s\n', fgetl(fileID)); % 写入第二行注释
fprintf(fileID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
    'Height', 'SNR1', 'Rv1', 'SW1', 'SNR2', 'Rv2', 'SW2', 'SNR3', 'Rv3', 'SW3', 'SNR4', 'Rv4', 'SW4', 'SNR5', 'Rv5', 'SW5');
for i = 1:length(heights)
    fprintf(fileID, '%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n', ...
        heights(i), data{2}(i), data{3}(i), data{4}(i), data{5}(i), data{6}(i), data{7}(i), data{8}(i), data{9}(i), ...
        data{10}(i), data{11}(i), data{12}(i), data{13}(i), data{14}(i), data{15}(i), data{16}(i));
end
fclose(fileID);