%后端流程整合
clear;
clc;
close all;

 % 获取当前Unix时间戳
    unixTimestamp = now;
    % 转换为datetime对象
    currentDateTime = datetime('now', 'TimeZone', 'UTC');
    %deltaSeconds = seconds(2);
    % 格式化输出
    formattedDateTime = datestr(currentDateTime, 'yyyy-mm-dd-HH-MM-SS');
% 指定文件夹路径
folder_path = 'E:\zyq2024\test2\zyq\20240401'; 

% 获取文件夹下所有的 .txt 文件列表
files = dir(fullfile(folder_path, '*.txt'));

% 遍历每个 .txt 文件
for i = 1:length(files)
    % 构建完整的文件路径
    filepath = fullfile(folder_path, files(i).name);

    disp(filepath)

    command="python libfix.py "+filepath+" "+files(i).name+" "+formattedDateTime;

    [status,cmdout] = system(command,'-echo');
    %disp(cmdout); %好像不需要单独写显示 
    new_filepath = filepath(1:end-length(files(i).name)) + "Processed_"+formattedDateTime+"\";
    completion(new_filepath + files(i).name(1:end-4) + "_Processed.txt");
    draw(new_filepath + files(i).name(1:end-4) + "_Processed.txt",new_filepath + files(i).name(1:end-4) + "_Processed.txt");
    draw(filepath,new_filepath+files(i).name);
    convert(new_filepath + files(i).name(1:end-4) + "_Processed.txt");
end

function draw(filepath,path)
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
    dataMatrix = readmatrix(filepath, 'CommentStyle', '#');

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



    % 找到 heights 小于30000的索引
idx_low = heights < 30000;
% 找到 heights 大于等于30000的索引
idx_high = heights >= 30000;

% 分割 rv1 到不同的部分
rv1_low = rv1(idx_low);
heights_low = heights(idx_low);
rv1_high = rv1(idx_high);
heights_high = heights(idx_high);

% 分割其他 rv 到不同的部分
rv2_low = rv2(idx_low);
rv2_high = rv2(idx_high);
rv3_low = rv3(idx_low);
rv3_high = rv3(idx_high);
rv4_low = rv4(idx_low);
rv4_high = rv4(idx_high);
rv5_low = rv5(idx_low);
rv5_high = rv5(idx_high);

% 创建图形窗口
fig=figure("Visible","off");

% 绘制 Beams 的低高度部分
plot(rv1_low, heights_low, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Beam 1 (low)', 'Marker', 'o');
hold on;
plot(rv2_low, heights_low, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Beam 2 (low)', 'Marker', 's');
plot(rv3_low, heights_low, 'g-', 'LineWidth', 1.5, 'DisplayName', 'Beam 3 (low)', 'Marker', '^');
plot(rv4_low, heights_low, 'm-', 'LineWidth', 1.5, 'DisplayName', 'Beam 4 (low)', 'Marker', 'x');
plot(rv5_low, heights_low, 'c-', 'LineWidth', 1.5, 'DisplayName', 'Beam 5 (low)', 'Marker', 'd');

% 绘制 Beams 的高高度部分
plot(rv1_high, heights_high, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Beam 1 (high)', 'Marker', 'o');
plot(rv2_high, heights_high, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Beam 2 (high)', 'Marker', 's');
plot(rv3_high, heights_high, 'g--', 'LineWidth', 1.5, 'DisplayName', 'Beam 3 (high)', 'Marker', '^');
plot(rv4_high, heights_high, 'm--', 'LineWidth', 1.5, 'DisplayName', 'Beam 4 (high)', 'Marker', 'x');
plot(rv5_high, heights_high, 'c--', 'LineWidth', 1.5, 'DisplayName', 'Beam 5 (high)', 'Marker', 'd');

% 添加图例
%legend show;

persistent a;
persistent b;
persistent c;
persistent d;
    % 调整坐标轴显示范围以适应数据
    if (filepath==path)
        xlim([min([rv1,rv2,rv3,rv4,rv5],[], 'all'), max([rv1,rv2,rv3,rv4,rv5],[], 'all')]);
        ylim([min(heights, [],'all'), max(heights,[], 'all')]);
        a=min(heights, [],'all');
        b=max(heights,[], 'all');
        c=min([rv1,rv2,rv3,rv4,rv5],[], 'all');
        d=max([rv1,rv2,rv3,rv4,rv5],[], 'all');
    else
        ylim([a, b]);  
        xlim([c, d]);
    end

    % 设置图表属性
    xlabel('Radial Velocity (m/s)');
    ylabel('Height (m)');
    gap=' ';
    title([time gap freq]);
    %legend('show');
    %grid on;

    % 保持坐标轴调整状态并显示图表
    %hold off;
    path = native2unicode(path, 'utf8');
    % 构建 PNG 文件路径
    % 使用 fileparts 函数获取文件名和扩展名
    [file_path, name, folder_path] = fileparts(path);

    % 构建新的文件路径
    % 注意：这里我们假设文件名中不含空格
    new_file_namepng = file_path+"\"+name+ '.png';
    new_file_namefig = file_path+"\"+name+ '.fig';

    % 保存当前图形窗口
    saveas(fig,new_file_namepng);
    %saveas(fig,new_file_namefig);
end

function completion(filepath) %缺失值的修补
    fileID = fopen(filepath, 'r');
    headerLines = 3; % 跳过前面的注释行和表头行
    fgets(fileID, headerLines); % 跳过前22行
    % 初始化变量存储数据
    heights = [];
    rv1 = [];
    rv2 = [];
    rv3 = [];
    rv4 = [];
    rv5 = [];
    r2 = [];
    r4 = [];
    r5 = [];
    r7= [];
    r8 = [];
    r10 = [];
    r11 = [];
    r13= [];
    r14= [];
    r16 = [];
    % 读取数据直到文件结束
    while ~feof(fileID)
        line = fgetl(fileID);
        if ~isempty(line) && ~ismember(line(1), {'#', '%'}) % 确保不是注释行或空行
            data = strsplit(line,' '); 
            if numel(data) >= 11 % 确保数据行至少有11个元素（基于提供的列数）
                heights = [heights, str2double(data{2})];
                r2=[r2, str2double(data{3})];
                rv1 = [rv1, str2double(data{4})];
                 r4=[r4, str2double(data{5})];
                  r5=[r2, str2double(data{6})];
                rv2 = [rv2, str2double(data{7})];
                 r7=[r2, str2double(data{8})];
                  r8=[r2, str2double(data{9})];
                rv3 = [rv3, str2double(data{10})];
                 r10=[r10, str2double(data{11})];
                  r11=[r11, str2double(data{12})];
                rv4 = [rv4, str2double(data{13})];
                 r13=[r2, str2double(data{14})];
                r14=[r2, str2double(data{15})];
                rv5 = [rv5, str2double(data{16} )];
                 r16=[r2, str2double(data{17})];
            end
        end
    end
    fclose(fileID);

    len=0;
    pre=0;
    aft=0;
    flag1=0;
    flag3=0;
    %对垂直的处理，遇到了nan，就和周围层直线
    for i=2:length(rv5)
        if isnan(rv5(i))
            aft=i;
        end
    if ~isnan(rv5(i))
        if pre>=aft
        pre=i;
        else
            if pre>=1
            for j=pre+1:aft

            rv5(j)=rv5(j-1)+((rv5(aft+1)-rv5(pre))/(aft-pre));
            end
            end   
            pre=i;
        end
    end
    end
    for i=2:length(rv1)
    if(isnan(rv1(i))||isnan(rv2(i)))
    if(isnan(rv1(i))&&isnan(rv2(i)))
        flag1=1;
    else
    if(isnan(rv1(i)))
    rv1(i)=-rv2(i);
    else
    rv2(i)=-rv1(i);
    end

    end
    end
    end
    for i=2:length(rv3)
    if(isnan(rv3(i))||isnan(rv4(i)))
    if(isnan(rv3(i))&&isnan(rv4(i)))
        flag3=1;
    else
    if(isnan(rv3(i)))
    rv3(i)=-rv4(i);
    else
    rv4(i)=-rv3(i);
    end
    end
    end
    end
    pre=0;
    aft=0;
    if(flag1)
        for i=2:length(rv1)
      if isnan(rv1(i))
            aft=i;
        end
    if ~isnan(rv1(i))
        if pre>=aft
        pre=i;
        else
            if pre>=1
            for j=pre+1:aft
            rv1(j)=rv1(j-1)+((rv1(aft+1)-rv1(pre))/(2*(aft-pre)));
             rv2(j)=rv2(j-1)+((rv2(aft+1)-rv2(pre))/(2*(aft-pre)));
            end
            end   
            pre=i;
        end
    end
    end
      flag1=0;
    end
    pre=0;
    aft=0;
    if(flag3)
          for i=2:length(rv1)
      if isnan(rv3(i))
            aft=i;
        end
    if ~isnan(rv3(i))
        if pre>=aft
        pre=i;
        else
            if pre>=1
            for j=pre+1:aft
            rv3(j)=rv3(j-1)+((rv3(aft+1)-rv3(pre))/(2*(aft-pre)));
                rv4(j)=rv4(j-1)+((rv4(aft+1)-rv4(pre))/(2*(aft-pre)));
            end
            end   
            pre=i;
        end
    end
    end
      flag3=0;
    end

    outputFileID = fopen(filepath, 'r+');
    for l1=1:33;
        fgetl(outputFileID);
    end
    for i = 2:length(heights)
        fprintf(outputFileID, '    %.1f    %.1f    %.2f    %.2f    %.1f    %.2f    %.2f    %.1f    %.2f    %.2f    %.1f    %.2f    %.2f    %.1f    %.2f    %.2f\n', heights(i), r2(i),rv1(i), r4(i),r5(i),rv2(i), r7(i), r8(i),rv3(i), r10(i),r11(i),rv4(i), r13(i), r14(15),rv5(i), r16(i));
    end
    % 关闭输出文件
       fprintf(outputFileID, '                                                                                                                                                                                                                                                                                                                                                                                ');
    fclose(outputFileID);
end

function convert(filepath) %转换为L2数据
    % 打开文件并读取数据
    fileID = fopen(filepath, 'r');

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

    % 关闭文件
    fclose(fileID);

    % 打开文件并读取数据
    fileID = fopen(filepath, 'r');

    % 读取文件前32行
    fileContent = cell(32, 1);
    for i = 1:32
        fileContent{i} = fgets(fileID);
    end

    % 创建输出文件
    path = native2unicode(filepath, 'utf8');
    % 构建 PNG 文件路径
    % 使用 fileparts 函数获取文件名和扩展名
    [file_path, name, folder_path] = fileparts(path);

    % 构建新的文件路径
    % 注意：这里我们假设文件名中不含空格
    %new_file_name = file_path+"\"+name+ '-L2.txt'
    new_file_name = filepath+"-L2.txt"
    outputFileID = fopen(new_file_name, 'w');

    % 写入文件前32行到输出文件
    for i = 1:32
        fprintf(outputFileID, '%s', fileContent{i});
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

    % 关闭文件
    fclose(fileID);

    % 写入处理后的数据到输出文件
    fprintf(outputFileID, '   Height Horiz_WS Horiz_WD Verti_V     Cn2      Credi\n');
    for i = 1:length(heights)
        fprintf(outputFileID, '    %d    %.2f    %.2f    %.2f    %.2f    %d\n', heights(i), ss(i), sd_degrees(i), w(i), Cn2(i), Credi(i));
    end
    % 关闭输出文件
    fclose(outputFileID);
end