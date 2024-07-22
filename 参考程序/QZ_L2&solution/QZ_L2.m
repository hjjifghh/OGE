% % % %% % by TMZG % % % % %
clear;
clc;
close all;

fol='E:\郑亦奇2024\test2\参考程序\QZ_L2&solution\20240401-0420';
f=fullfile(fol,'*.txt');

files=dir(f); %导入数据
nf=length(files); %数组的最大长度

for k=1:nf
    
    fk=files(k).name; %第k个文件名字符向量
    
    % time
    time(k) = string(fk(32:37));
    day(k) = str2double(fk(32:33));
    hour(k) = str2double(fk(34:35));
    minu(k) = str2double(fk(36:37));
    time_cal(k) = ((day(k)-1)*24 + hour(k) +minu(k)/60)/24;

    % freq
    path = [fol,'\',fk]; 
   
    fileID = fopen(path);
    
    for i = 1:14
        fg = fgetl(fileID);
    end
    freq(k) = str2double(fg(19:23));
    
    fclose(fileID);
    
    % 
    T = readmatrix(path);
    T(1:2,:) = [];
    T(:,5:6) = [];

    hT = T(:,1);
    hTs(:,k) = hT(1:3);
    Tc{k} = T;
end

h_uniq = [unique(hTs','rows')]';
hu_s = size(h_uniq,2);
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

for j = 1:3*hu_s

    fD{j} = D(:,cell2mat(D(1,:))==j);

end

fD(cellfun(@isempty,fD))=[];



%%%%

for i = 1:length(fD)

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
        xlabel(til,'Speed(m/s)');
        ylabel(til,'Height(km)');


    end

end



