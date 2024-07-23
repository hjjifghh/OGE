% % % %% % by TMZG % % % % %
clear;
clc;
close all;

fol='E:\郑亦奇2024\test2\参考程序\QZ_L2&solution\20240401-0420';
f=fullfile(fol,'*.txt');%根据系统规则连接文件夹目录与文件名，这里的文件名是以通配符发方式实现的

files=dir(f); %导入数据。dir用于列出指定目录下的文件及其信息
nf=length(files); %数组的最大长度。获取files数组的长度即获取文件的总数

for k=1:nf %这里的1：nf是一个范围，并且两边都取得到
    
    fk=files(k).name; %第k个文件名字符向量
    
    % time 从文件名中提取和处理时间
    time(k) = string(fk(32:37));%提取32到37字符，注意这里是从1开始数的
    day(k) = str2double(fk(32:33));%函数的功能是变量类型的转换
    hour(k) = str2double(fk(34:35));
    minu(k) = str2double(fk(36:37));
    time_cal(k) = ((day(k)-1)*24 + hour(k) +minu(k)/60)/24;%转化为相对起始点的小时数，方便绘图

    % freq
    path = [fol,'\',fk]; %拼合当前文件名
   
    fileID = fopen(path);
    
    for i = 1:14
        fg = fgetl(fileID);
    end
    freq(k) = str2double(fg(19:23));
    
    fclose(fileID);
    
    % 
    T = readmatrix(path);%将数据读入矩阵
    T(1:2,:) = [];
    T(:,5:6) = [];

    hT = T(:,1); %提取第一列
    hTs(:,k) = hT(1:3); %存入前3个值为一列
    Tc{k} = T;%将每个文件的数据以矩阵的形式存入细胞数组
end

h_uniq = [unique(hTs','rows')]'%删除重复行，unique默认返回列向量形式，需要转置
hu_s = size(h_uniq,2) %仅查询第二维度的长度（即行的数量）
for k = 1:nf
    for i = 1:hu_s
        if freq(k)==50 && isequal(hTs(:,k),h_uniq(:,i))
           
           D(:,k) = {i,freq(k),time(k),time_cal(k),Tc{k}};

        elseif freq(k)==161 && isequal(hTs(:,k),h_uniq(:,i))
           
           D(:,k) = {i+hu_s,freq(k),time(k),time_cal(k),Tc{k}};

        elseif freq(k)==200 && isequal(hTs(:,k),h_uniq(:,i))
           
           D(:,k) = {i+2*hu_s,freq(k),time(k),time_cal(k),Tc{k}};

        end
    end
end

for j = 1:3*hu_s %按高度类型和频率重新组织数据

    fD{j} = D(:,cell2mat(D(1,:))==j);

end

fD(cellfun(@isempty,fD))=[];



%%%%

%for i = 1:length(fD)
i=2;
    st = cell2mat(fD{i}(4,:));

    lenf = cellfun(@length,fD{i}(5,:));% 将函数应用于每一个元胞元素
    [lenM,lenI] = max(lenf); % 最大值及索引

    % %
    for j = 1:length(st)

        A = fD{i}{5,j};
        A(A==-9999999) = -99999999;  %垂直风速
        As = A-9999; % 避风速0
        As(lenM,4) = 0;
        Ce{i,j} = As;

    end

    C = cell2mat(Ce(i,:))+9999; % 恢复
    C(C==-99999999 | C==9999) = NaN;
    Cs{i} = C;  


    % %
    n = 0:4:4*(length(st)-1);
    sh = C(:,4*(lenI-1)+1);
    ss = C(:,n+2);
    sd = C(:,n+3);
    sv = C(:,n+4); % 垂直风

    % %
    sx = ss.*sin((sd-180)*pi/180);
    sy = ss.*cos((sd-180)*pi/180);

    % % % 赋[]值
    % [rx1,~] = find(isnan(sx));
    % rx1 = unique(rx1);
    % for k = 1:length(rx1)
    %     cN = sx(rx1(k):lenM,:);
    %     if all(isnan(cN))
    %        sx(rx1(k):lenM,:) = [];
    %        sh(rx1(k):lenM) = [];
    %        break; %终止循环
    %     end
    % end

    % %
    if length(st)>1
         
        figure;
        til = tiledlayout(3,1);
        
        ss = {sx,sy,sv};
        tex = ["纬向风","经向风","垂直风"];
        for k = 1:3
            nexttile;
            contourf(st,sh,ss{k},20);
            colormap default;
            colorbar;
            clim([-50,50]);
            title(tex(k));
        end
        
        r1='Freq=';
        r2=num2str(fD{i}{2,1});
        r3='MHz; ';
        r4='HR=';
        r5=num2str((sh(2)-sh(1))*1000);
        r6='m';
        title(til,[r1 r2 r3 r4 r5 r6]);
        xlabel(til,'Day');
        ylabel(til,'Height(km)');


    end

%end



