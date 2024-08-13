% 打开文件并读取数据
fileID = fopen('OQZQB_MSTR01_PSPP_L1B_30M_20240401000000_V01.00_M_Processed.txt', 'r');

% 初始化变量
angle = 0.0;
heights = [];
u = [];
v = [];
w = [];
Cn2 = [];
Credi = [];

% 正则表达式用于匹配EleAngle后面紧跟的浮点数
regex = 'EleAngle=([\d.]+)';

% 读取并解析文件直到找到EleAngle值
while ~feof(fileID)
    line = fgets(fileID);
    if ~isempty(line)
        matches = regexp(line, regex, 'tokens');
        if ~isempty(matches)
            angle = str2double(matches{1}{1});
            break;
        end
    end
end

% 检查是否成功读取EleAngle
if isnan(angle)
    error('无法找到EleAngle值。');
end


% 读取数据直到文件结束
while ~feof(fileID)
    line = fgetl(fileID);
    if ~isempty(line) && ~ismember(line(1), {'#', '%'})
        % 去除注释和空格
        line = strrep(line, '#', '');
        line = strrep(line, '%', '');
        line = strtrim(line);
        
        % 将行分割为数据字段
        data = strsplit(line, ' ');
        
        % 检查数据字段数量是否足够
        if numel(data) >= 11
            try
                height = str2double(data{1});
                rv1 = str2double(data{3});
                rv2 = str2double(data{6});
                rv3 = str2double(data{9});
                rv4 = str2double(data{12});
                rv5 = str2double(data{15});
                
                % 处理缺失数据
                if isnan(height) || isnan(rv1) || isnan(rv2) || isnan(rv3) || isnan(rv4) || isnan(rv5)
                    continue;
                end
                
                heights(end+1) = height;
                u(end+1) = abs((rv1 - rv2) / 2 / sin(angle * (pi / 180)));
                v(end+1) = abs((rv4 - rv3) / 2 / sin(angle * (pi / 180)));
                w(end+1) = rv5;
                ss = sqrt(u.^2 + v.^2);        % 风速
                sd = 2*pi-atan2(u, v);         % 风向
                sd_degrees = rad2deg(sd);
                
                Cn2(end+1) = -142.39; % 假设Cn2的值是固定的
                Credi(end+1) = 100;   % 假设Credi的值是固定的
                
            catch
                % 如果在处理数据时出现错误，则跳过该行
                continue;
            end
        end
    end
end
fclose(fileID);

% 创建输出文件
outputFileID = fopen('output_data.txt', 'w');

% 写入数据到输出文件
fprintf(outputFileID, 'Height Horiz_WS Horiz_WD Verti_V     Cn2 Credi\n');
for i = 1:length(heights)
    fprintf(outputFileID, '%.2f    %.2f    %.2f    %.2f    %.2f   %d\n', heights(i), ss(i), sd_degrees(i), w(i), Cn2(i), Credi(i));
end

% 关闭输出文件
fclose(outputFileID);