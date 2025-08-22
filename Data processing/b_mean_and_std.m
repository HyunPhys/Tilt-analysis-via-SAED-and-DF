% 데이터 평균, 표준편차 추출
clear;

% 파일 위치한 폴더

cd 'raw data'

% 데이터 열기

%data_raw = xlsread('left.xlsx');
%data_raw_ref = xlsread('left.xlsx'); % max, min normalization을 위한, reference data

load("processed_data_250822_try_1.mat")

data_raw = dat;
% data_raw_ref = dat;

% export할 이름

dataname = 'mean_and_std_250822_try_1';

% Pixel 개수

% pixel_num = 1600;

% Normalize 여부

is_normalize = false; % False로 둘 것. 어차피 data_plot_and_analysis에서 SD까지 같이 normalization해줌


% 각 데이터 별 열 번호

% angle_column_num = 1;
% x_ginput_num = 2;
% y_ginput_num = 3;
% intensity_num_start = 4;
% intensity_num_end = intensity_num_start + pixel_num - 1; % 여긴 건드릴 필요 x

%% Process

% 기본 변수들

angle = FileNameArray;
% x_ginput = data_raw(1:end, x_ginput_num);
% y_ginput = data_raw(1:end, y_ginput_num);

intensity_mean = [];
intensity_std = [];


for idx = 1:length(angle)
    
    for p=1:polygon_num
        intensity = data_raw(idx,p,:);
        intensity_ref = data_raw(idx,p,:);

        % Normalization 수행 코드
        
        if is_normalize == true
            intensity_max = max(max(intensity)); intensity_min = min(min(intensity));
            intensity_ref_max = max(max(intensity_ref)); intensity_ref_min = min(min(intensity_ref));
            intensity_max_total = max([intensity_max,intensity_ref_max]); intensity_min_total = min([intensity_min,intensity_ref_min]);
            intensity = (intensity - intensity_min_total) / (intensity_max_total-intensity_min_total);
        end
        
        % mean, std 계산 코드
        
        intensity_mean(idx,p) = mean(intensity);
        intensity_std(idx,p) = std(intensity);

        
        %intensity_mean = intensity_mean';
        %intensity_std = intensity_std';
        
        %matrix_total = [angle, intensity_mean, intensity_std];

        clear intensity intensity_ref 
    end

end

%% Save files

%excelfilename = strcat(dataname,'.xlsx');
%writematrix(matrix_total, excelfilename)

data_name_export = strcat(dataname,'.mat');
save(data_name_export,"FileNameArray","intensity_mean","intensity_std","polygon_num")


close all
