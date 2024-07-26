% 打开文件并读取数据
fileID = fopen('OQZQB_MSTR01_PSPP_L1B_30M_20240401000000_V01.00_M.TXT', 'r');

angle=0.0;
% 正则表达式用于匹配EleAngle后面紧跟的浮点数
regex = 'EleAngle=([\d.]+)'; % 匹配EleAngle后面紧跟的浮点数

% 读取并解析文件直到找到EleAngle值
while ~feof(fileID)
    line = fgets(fileID);
    if ~isempty(line)
        matches = regexp(line, regex, 'tokens'); % 使用'tokens'选项获取匹配的值
        if ~isempty(matches)
            angle = str2double(matches{1}{1}); % 提取第一个匹配项并转换为浮点数
            break; % 找到EleAngle后退出循环
        end
    end
end


% 初始化变量存储数据
heights = [];
u = [];
v = [];
w = [];
Cn2 = [];
Credi = [];

% 读取数据直到文件结束
while ~feof(fileID)
    line = fgetl(fileID);
    if ~isempty(line) && ~ismember(line(1), {'#', '%'}) % 确保不是注释行或空行
        data = strsplit(line, ' '); 
        if numel(data) >= 11 % 确保数据行至少有11个元素（基于提供的列数）
            height = str2double(data{2})
            rv1 = str2double(data{4})
            rv2 = str2double(data{7})
            rv3 = str2double(data{10})
            rv4 = str2double(data{13})
            rv5 = str2double(data{16})
            
            % 检查转换是否成功，如果任何一个转换失败，则跳过该行
            if isnan(height) || isnan(rv1) || isnan(rv2) || isnan(rv3) || isnan(rv4) || isnan(rv5)
                continue;
            end
            
            heights(end+1) = height;
            u(end+1) = abs((rv1 - rv2) / 2 / sin(angle* (pi / 180)));
            v(end+1) = abs((rv4 - rv3) / 2 / sin(angle* (pi / 180)));
            w(end+1) = rv5;
            Cn2(end+1) = -142.39; % 假设Cn2的值是固定的，这里用一个示例值代替
            Credi(end+1) = 100;   % 假设Credi的值是固定的，这里用一个示例值代替
        end
    end
end
fclose(fileID);

% 创建输出文件
outputFileID = fopen('output_data.txt', 'w');

% 写入数据到输出文件
fprintf(outputFileID, 'Height Horiz_WS Horiz_WD Verti_V     Cn2 Credi\n');
for i = 1:length(heights)
    fprintf(outputFileID, '%d    %.2f    %.2f    %.2f    %.2f   %d\n', heights(i), u(i), v(i), w(i), Cn2(i), Credi(i));
end

% 关闭输出文件
fclose(outputFileID);