function MST_radar_3Dimensional_wind_files_from_proData
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

clear all;
% start_path = 'F:\MST radar\Power spectral data file with C++\low mode data\';
start_path = 'H:\MST_XHT_MST01_DWL_L21_STP\2011\12\';
handles.RadarPara.Base.PathName = uigetdir(start_path,'请选择需处理的文件夹');
Files = FileNum(handles.RadarPara.Base.PathName);

Verticalwind='productdata_Vertical_wind_201112.xlsx';
zonalwind='productdata_zonal_wind_201112.xlsx';
meridional_wind='productdata_meridional_wind_201112.xlsx';

if ~isempty(Files)
    %  for i1 =4882:5013
    % for i1 =5013:5060
    %          for i1=1:Files.num;
    for i1=1:Files.num
        % for i1 =237:375
        FileName=[handles.RadarPara.Base.PathName '\' Files.file{1}(i1).name];
        %  FileName=load([handles.RadarPara.Base.PathName '\' Files.file{1}(i1).name]);
        [d1, d2, d3 ,d4, d5]=textread(FileName,'%n%n%n%n%n','delimiter', ',','headerlines', 1);
        data=[d1, d2, d3 ,d4, d5];    %%%西波束
        %%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 提取数文件的时间所对应序列号
        TIME_dd=strcat(Files.file{1}(i1).name(29:30));    %%%提取时间 日
        TIME_hh=strcat(Files.file{1}(i1).name(31:32));   %%%提取时间 小时
        TIME_min=strcat(Files.file{1}(i1).name(33));   %%%提取时间 分钟
        TIME_dd=str2num(TIME_dd);
        TIME_hh=str2num(TIME_hh);
        TIME_min=str2num(TIME_min);
        if TIME_min==0
            plus_min=1;
        else
            plus_min=2;
        end
        day=TIME_dd;
        hour=TIME_hh;
        lines=(day-1)*48+(hour)*2+plus_min;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        wind_direction(:,lines-0)=data(18:98,2);
        honrizontal_wind(:,lines-0)=data(18:98,3);
        vertical_wind(:,lines-0)=-data(18:98,4);    %%%%%%%%%%%%%%加了负号
        % wind_direction(:,lines-0)=(wind_direction(:,lines-0)-180)/180*pi;
        %u(:,lines-0)=honrizontal_wind(:,lines-0).*sin(wind_direction(:,lines-0));
        %v(:,lines-0)=honrizontal_wind(:,lines-0).*cos(wind_direction(:,lines-0));
        
    end
end
H(:,1)=data(:,1);
[m,n]=size(vertical_wind);
for i=1:m
    for j=1:n
        if wind_direction(i,j)==9999
            wind_direction(i,j)=NaN;
        end
        if honrizontal_wind(i,j)==9999
            honrizontal_wind(i,j)=NaN;
        end
        if honrizontal_wind(i,j)==0
            vertical_wind(i,j)=NaN;
            honrizontal_wind(i,j)=NaN;
            wind_direction(i,j)=NaN;
        end
        if vertical_wind(i,j)>4
            vertical_wind(i,j)=0.01;
        end
        if vertical_wind(i,j)<-4
            vertical_wind(i,j)=0.01;
        end
        
    end
end
for i=1:m
    for j=2:n-2
        if isnan(vertical_wind(i,j))||isnan(vertical_wind(i,j-1))
            continue;
        else
            for o=j:n
                if isnan(vertical_wind(i,o))
                    continue
                else
                    break
                end
                if abs(vertical_wind(i,j-1)-vertical_wind(i,o))>2
                    vertical_wind(i,j-1)=vertical_wind(i,o);
                end
            end
            if abs(vertical_wind(i,j)-vertical_wind(i,j-1))>2
                for k=j+1:n
                    if abs(vertical_wind(i,k)-vertical_wind(i,j-1))>2
                        continue;
                    else
                        break
                    end
                end
                if k<=j+10
                    for l=j:k-1
                        vertical_wind(i,l)=vertical_wind(i,j-1);
                    end
                else
                    for l=j:k-1
                        vertical_wind(i,l)=NaN;
                    end
                end
            end
        end
    end
end
for j=1:n
    for i=2:m-2
        if isnan(vertical_wind(i,j))||isnan(vertical_wind(i-1,j))
            continue;
        else
            if i>=4
                for o=i-2:-1:1
                    if isnan(vertical_wind(o,j))
                        continue;
                    else
                        break
                    end
                end
                if abs(vertical_wind(i-1,j)-vertical_wind(o,j))>2
                    vertical_wind(i-1,j)=vertical_wind(o,j);
                end
            end
            if abs(vertical_wind(i,j)-vertical_wind(i-1,j))>2
                for k=i+1:m
                    if abs(vertical_wind(k,j)-vertical_wind(i-1,j))>2
                        continue
                    else
                        break
                    end
                end
                if k<=i+10
                    for l=i:k-1
                        vertical_wind(l,j)=vertical_wind(i-1,j);
                    end
                else
                    for l=i:k-1
                        vertical_wind(l,j)=NaN;
                    end
                end
            end
        end
    end
end
for j=1:n
    for i=m-1:-1:1
        if isnan( vertical_wind(i,j))
            if ~isnan(vertical_wind(i+1,j))
                vertical_wind(i,j)=vertical_wind(i+1,j);
            end
        end
    end
end
wind_direction=(wind_direction-180)/180*pi;
u=-honrizontal_wind.*sin(wind_direction);%%%%eastward wind (向西吹的风为负)
if abs(u(i,j))>60
    u(i,j)=NaN;
end
for i=1:m
    for j=2:n-2
        if isnan(u(i,j))||isnan(u(i,j-1 ))
            continue;
        else
            if j>=4
                for o=j-2:-1:1
                    if isnan(u(i,o))
                        continue;
                    else
                        break
                    end
                end
                if abs(u(i,j-1)-u(i,o))>30
                    u(i,j-1)=u(i,o);
                end
            end
            if abs(u(i,j)-u(i,j-1))>30
                for k=j+1:n
                    if abs(u(i,k)-u(i,j-1))>30
                        continue
                    else
                        break
                    end
                end
                if k<=j+10
                    for l=j:k-1
                        u(i,l)=u(i,j-1);
                    end
                else
                    for l=j:k-1
                        u(i,l)=NaN;
                    end
                end
            end
        end
    end
end
for j=1:n
    for i=2:m-2
        if isnan(u(i,j))||isnan(u(i-1,j))
            continue;
        else
            if i>=4
                for o=i-2:-1:1
                    if isnan(u(o,j))
                        continue;
                    else
                        break
                    end
                end
                if abs(u(i-1,j)-u(o,j))>25
                    u(i-1,j)=u(o,j);
                end
            end
            if abs(u(i,j)-u(i-1,j))>25
                for k=i+1:m
                    if abs(u(k,j)-u(i-1,j))>25
                        continue
                    else
                        break
                    end
                end
                if k<=i+10
                    for l=i:k-1
                        u(l,j)=u(i-1,j);
                    end
                else
                    for l=i:k-1
                        u(l,j)=NaN;
                    end
                end
            end
        end
    end
end

for j=1:n
    for i=m-1:-1:1
        if isnan(u(i,j))
            if ~isnan(u(i+1,j))
                u(i,j)=u(i+1,j);
            end
        end
    end
end

% for i=2:m
%     for j=1:n-3
%         if isnan(u(i,j))
%            for kk=j+1:n
%                 if isnan(u(i,j))
%             continue
%                 else
%                    k=kk;
%
%                 end
%             break;
%         end
%         if k-j>=20
%             for l=j:k-1
%             u(i,l)=u(i-1,l);
%             end
%         end
%         end
%     end
% end

% for i=1:m
%     for j=2:n-2
%         if isnan(u(i,j))||isnan(u(i,j-1 ))
%             continue;
%         else
%             if j>=4
%                 for o=j-2:-1:1
%                     if isnan(u(i,o))
%                         continue;
%                     else
%                         break
%                     end
%                 end
%                 if abs(u(i,j-1)-u(i,o))>30
%                     u(i,j-1)=u(i,o);
%                 end
%             end
%             if abs(u(i,j)-u(i,j-1))>30
%                 for k=j+1:n
%                     if abs(u(i,k)-u(i,j-1))>30
%                         continue
%                     else
%                         break
%                     end
%                 end
%                 if k<=j+10
%                     for l=j:k-1
%                         u(i,l)=u(i,j-1);
%                     end
%                 else
%                     for l=j:k-1
%                         u(i,l)=NaN;
%                     end
%                 end
%             end
%         end
%     end
% end
v=-honrizontal_wind.*cos(wind_direction);   %%% 北风为负  （向南吹的风）
for i=1:m
    for j=2:n-2
        if isnan(v(i,j))||isnan(v(i,j-1))
            continue;
        else
            if j>=4
                for o=j-2:-1:1
                    if isnan(v(i,o))
                        continue;
                    else
                        break
                    end
                end
                if abs(v(i,j-1)-v(i,o))>25
                    v(i,j-1)=v(i,o);
                end
            end
            if abs(v(i,j)-v(i,j-1))>25
                for k=j+1:n
                    if abs(v(i,k)-v(i,j-1))>25
                        continue
                    else
                        break
                    end
                end
                if k<=j+10
                    for l=j:k-1
                        v(i,l)=v(i,j-1);
                    end
                else
                    for l=j:k-1
                        v(i,l)=NaN;
                    end
                end
            end
        end
    end
end
for j=1:n
    for i=2:m-2
        if isnan(v(i,j))||isnan(v(i-1,j))
            continue;
        else
            if i>=4
                for o=i-2:-1:1
                    if isnan(v(o,j))
                        continue;
                    else
                        break
                    end
                end
                if abs(v(i-1,j)-v(o,j))>25
                    v(i-1,j)=v(o,j);
                end
            end
            if abs(v(i,j)-v(i-1,j))>25
                for k=i+1:m
                    if abs(v(k,j)-v(i-1,j))>25
                    else
                        break
                    end
                end
                if k<=i+10
                    for l=i:k-1
                        v(l,j)=v(i-1,j);
                    end
                else
                    for l=i:k-1
                        v(l,j)=NaN;
                    end
                end
            end
        end
    end
end
for j=1:n
    for i=m-1:-1:1
        if isnan(v(i,j))
            if ~isnan(v(i+1,j))
                v(i,j)=v(i+1,j);
            end
        end
    end
end
u=u(:,1:end);v=v(:,1:end);vertical_wind1=vertical_wind(:,1:end);
H=H(18:98,1:end);

%xlswrite('productdata_wind_direction_2011011.xlsx',[H,wind_direction]);
%xlswrite('productdata_honrizontal_wind_2011011.xlsx',[H,honrizontal_wind]);
xlswrite(Verticalwind,[H,vertical_wind1]);
xlswrite(zonalwind,[H,-u]);
xlswrite(meridionalwind,[H,-v]);
% contourf(u,'levellist',-100:10:100);
% colormap(jet);
% caxis([-100,100]);
% xlabel('time');
% ylabel('height')
end


