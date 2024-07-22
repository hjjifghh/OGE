clear all;
close all;
clc;
tic  % Start clock to measure performance

%%
save_path='F:\LYM\3 风场等数据\武汉MST\2014\12\高模式\';  %%%% store path for the results 
echo_writename=[save_path,'MST_PSDdata_highMode_east_beam_echo_power_gauss','.xlsx'];  %%%% echo power for guss fitting
radialV_writename=[save_path,'MST_PSDdata_highMode_east_beam_radial_velocity_gauss','.xlsx'];  %%%% Radial velocity for guss fitting
width_writename=[save_path,'MST_PSDdata_highMode_east_beam_half_Power_full_width_gauss','.xlsx'];  %%%% Full spectrum width for guss fitting

mydir='F:\LYM\2 MST处理数据\武汉MST\2014\12\高模式\东';  %%%% Data location

%%
files=dir(fullfile(mydir,'*.TXT'));
num_files=length(files);  %%%% Number of Data

%%
%%% Basic Parameter %%%%%%
NumFFT = 512;  %谱线数目
NumBin = 129;  % Bin的数目
NumInCohInter = 10;  % 非相干积累次数/谱平均数
NumCohInter = 8;  % 相干积累次数/脉间积累次数
NumFFT = 512;  % FFT点数
Azth = 15;  %  斜波束天顶角（度）
RangeReso = 1200;  % Range Resolution  1200m
SamplingFrq = 80*10^6;  % 采样频率 80MHz
Waveleth = 5.576;  % 发射波长  5.576 m
PRF = 10^6/1280;  % 脉冲重复周期 1280 us
m0=2*(log(2))^0.5;

%%%%%%%  计算参数
DopRange = [-PRF/NumCohInter/2 , PRF/NumCohInter/2];  % 多普勒探测范围 Hz
DopReso = PRF/(NumFFT*NumCohInter);  % 多普勒分辨率 Hz    
VeloRange = DopRange*Waveleth/2;  % 径向速度范围 m/s
VeloReso  = DopReso*Waveleth/2;  % 径向速度分辨率 m/s
% AxisVelo = VeloRange(1):VeloReso:VeloRange(end);  % 径向速度轴
AxisVelo = (VeloRange(1)+VeloReso/2):VeloReso:(VeloRange(end)-VeloReso/2);  % 径向速度轴

ccc = cell(170,1);
%%
s_width=[];
for k=1:num_files  %%%% 一个个数据处理
    filename=files(k).name;
    newpath=strcat(mydir,'\',filename);  %%%% One data address
    psd_data=load(newpath);              %%%% read the data on line
    psd_data=reshape(psd_data,512,129);  %%%% Spectum of 512, 129 spectra
    
%     psd_data = log(psd_data); %%% 取对数

    psd_data=groundclutter_processing(psd_data);  %%%% 槽口滤波：地物杂波抑制

    t=filename(23:36);  %%%% 提取时间信息
    tt(:,k)=str2num(t);  %%%% TimeAxis
    
    x=-256*5576000/(1280*512*8*2):5576000/(1280*512*8*2):255*5576000/(1280*512*8*2);  %%% 径向速度轴
    m0=2*(log(2))^0.5;
    
    Amplitude = sum(psd_data',2);  % 幅度
    m = psd_data'*AxisVelo'; 
    shift(k,:) = m./Amplitude;
    
    for i=49:104;  %%%% 选择数据高度区间
        ii= 48;
        for iii = 2:511
            ThreePoints = [psd_data(iii-1,i),psd_data(iii,i),psd_data(iii+1,i)];  %%%% 中值滤波：随机脉冲杂波抑制
            psd_data(iii,i) = median(ThreePoints);
        end
%         for iii = 1:508
%             FivePoints = [psd_data(iii,i),psd_data(iii+1,i),psd_data(iii+2,i),psd_data(iii+3,i),psd_data(iii+4,i)];
%             psd_data(iii,i) = median(FivePoints);
%         end
%         for iii = 1:506
%             SevenPoints = [psd_data(iii,i),psd_data(iii+1,i),psd_data(iii+2,i),psd_data(iii+3,i),psd_data(iii+4,i),psd_data(iii+5,i),psd_data(iii+6,i)];
%             psd_data(iii,i) = median(SevenPoints);
%         end

        psd_data_normal=highmode_normalization_processing(psd_data);  %%% 归一化处理

%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 谱宽、径向速度
%         y=psd_data_normal(:,i);
%         [cfun,gof] = fit(x',y,'gauss2');
%         b1=cfun.b1;
%         c1=cfun.c1;
%         Rsquare=gof.rsquare;  %%%% R-square:确定系数，越接近1越好
%         if Rsquare>0.3
%             s_width((i-ii),k)=m0*c1;  %%%% 达标存谱宽
%             radial_velocity((i-ii),k)=b1;  %%%% 达标存径向速度
%         else
%             s_width((i-ii),k)=NaN;
%             radial_velocity((i-ii),k)=NaN;
%         end
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  SNR
%         yy=psd_data_normal(:,i);
%         m=size(yy,1);  % 这是谱线数
%         gg=m/8;  % 将频谱平均分为段,然后对每一段数据取平均,取最小平均值作为整个谱的平均噪声功率值
%         for j=1:8
%             n(j)=mean(yy((gg*(j-1)+1):(gg*j)));
%         end
%         
%         N(i-ii)=min(n);  %%%% 每个高度上的平均噪声功率值
%         
%         for a=3:(m-3);
%             sum(a,1)=yy(a-2)+yy(a-1)+yy(a)+yy(a+1)+yy(a+2);  %%%% sum(3,1)=yy(1)+yy(2)+yy(3)+yy(4)+yy(5)......
%         end
%         jj = find(sum == max(sum(:,1)));  %%找到求和最大值的位置
%         jj=max(jj); 
%         Y=yy(jj); 
% %         V=yy(jj)*jj;
%         
%         kk=0; count=0;
%         while yy(jj)>N(i-ii)&&jj>1;  %取平均噪声功率值以上的信号功率
%             jj=jj-1;
%             kk=kk+1;
%             Y=Y+yy(jj);
% %             V=V+yy(jj)*jj;
%             count=count+1;
%         end
%         
%         jj=jj+kk;
%         while yy(jj)>N(i-ii)&&jj<m;
%             jj=jj+1;
%             Y=Y+yy(jj);
% %             V=V+yy(jj)*jj;
%             count=count+1;
%         end
%         
%         YY(i-ii)=Y;
%         power(i-ii)=10*log10(YY(i-ii));
%         noise(i-ii)=10*log10(N(i-ii)*count);
%     end
%     snr=power-noise;
%     SNR(:,k)=snr';
% % %     SNR(find(SNR==Inf))= NaN;
%     ccc{k} = psd_data_normal;
    end
end

% s_width(s_width==0)=NaN;
% radial_velocity(radial_velocity==0)=NaN;
% SNR(SNR==0)=NaN;

%%
height=2.3182:1.16:149.5235;
% xlswrite(echo_writename,[height(49:104)',SNR]);
% xlswrite(radialV_writename,[height(49:104)',radial_velocity]);
% xlswrite(width_writename,[height(49:104)',s_width]);
toc

%%
for i = 12:28
    figure()
    hold on
    a = 0;
    for ii = 59:68
        plot(ccc{i}(:,ii)+a);box on;
        a = a+1;
    end
end

shift(find(abs(shift)>50)) = nan;

figure()
c=imagesc(1:170,height,shift');axis xy;
set(c,'alphadata',~isnan(shift')) ;
colormap(jet);
caxis([-25 25]);

figure
rv_e = shift';
hold on
plot(1:23,rv_e(19,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(20,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(21,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(22,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(23,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(24,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(25,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(26,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(27,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(28,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(29,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(30,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(31,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(32,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(33,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(34,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(35,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(36,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(37,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(38,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(39,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(40,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(41,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(42,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(43,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(44,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(45,9:31),'.r','MarkerSize',15);
plot(1:23,rv_e(46,9:31),'.r','MarkerSize',15);
ylim([-50 50])


% title('(g) Radial velocity of east beam');
% 
% xlim([datenum(TimeAxis(1)) datenum(TimeAxis(170))]);
% set(gca,'xtick',[TimeAxis(9) TimeAxis(27) TimeAxis(44) TimeAxis(61) TimeAxis(79) TimeAxis(96) TimeAxis(114) TimeAxis(131) TimeAxis(148)]);
% set(gca,'xticklabel',{'14', '17', '20', '23', '02', '05', '08', '11', '14'});
% ylim([70 110]);
% set(gca,'ytick',[70:10:110]);
% % set(gca,'YLim',[65 85]);%Y轴的数据显示范围
% 
% hold on
%  x=t1*ones(length(height),1); % start
% plot(x',height,'color',[0.8,0.8,0.8]) 
% 
%  x=t2*ones(length(height),1);  % peak
% plot(x',height,'r') 
% 
%  x=t3*ones(length(height),1);  % end
% plot(x',height,'color',[0.8,0.8,0.8]) 
% 
% 
% t4 = datenum([2020 06 22 14 31 31]);
% t5 = datenum([2020 06 22 16 00 43]);
% t6 = datenum([2020 06 22 17 16 38]);
% 
% hold on
%  x=t4*ones(length(height),1); % start
% plot(x,height,'color',[0.8,0.8,0.8]) 
% 
%  x=t5*ones(length(height),1);  % peak
% plot(x,height,'r') 
% 
%  x=t6*ones(length(height),1);  % end
% plot(x,height,'color',[0.8,0.8,0.8])
% 
% % y1 = 80*ones(length(time),1);
% % y2 = 70*ones(length(time),1);
% % plot(datenum(time),y1);
% % plot(datenum(time),y2);
% 
% 
