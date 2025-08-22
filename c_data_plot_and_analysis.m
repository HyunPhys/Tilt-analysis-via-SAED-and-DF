%% Import Data

close all

% 폴더로 이동

cd 'raw data'

% 데이터 파일 이름

% filename_exp_1 = "mean_and_std_left_raw.xlsx";
% filename_exp_2 = "mean_and_std_right_raw.xlsx";
% filename_the_1 = "mean_and_std_right.xlsx";
% filename_the_2 = "mean_and_std_right.xlsx";

load("mean_and_std_250822_try_1.mat")


% 관심있는 polygon 선택
polystart = 1;
polyend = 2;

intensity_mean_of_interest = intensity_mean(1:end,polystart:polyend);
intensity_std_of_interest = intensity_std(1:end,polystart:polyend);


% Plot 관련 설저
color_list = {"r","g","b","c","m","y","k"};
legend_list = {'Red','Green'}; % ROI 이름을 string으로 넣기...


% 각도, 평균, 표준편차의 열 번호

% angle_column_num = 1;
% mean_column_num = 2;
% std_column_num = 3;

% normalization 할 것인지 (average 값들에 대해)

is_normalize = true;


%% import

% exp_data_1 = readmatrix(filename_exp_1);
% exp_data_2 = readmatrix(filename_exp_2);
%the_data_1 = readmatrix(filename_the_1);
%the_data_2 = readmatrix(filename_the_2);

%% Normalization

if is_normalize == true
    % intensities = [exp_data_1(:,mean_column_num),exp_data_2(:,mean_column_num)];
    intensity_mean_max = max(max(intensity_mean_of_interest)); intensity_mean_min = min(min(intensity_mean_of_interest));
    % exp_data_1(:,mean_column_num) = (exp_data_1(:,mean_column_num) - intensity_min) / (intensity_max-intensity_min);
    % exp_data_2(:,mean_column_num) = (exp_data_2(:,mean_column_num) - intensity_min) / (intensity_max-intensity_min);
    % exp_data_1(:,std_column_num) = exp_data_1(:,std_column_num) / (intensity_max-intensity_min);
    % exp_data_2(:,std_column_num) = exp_data_2(:,std_column_num) / (intensity_max-intensity_min);
    intensity_mean_of_interest = (intensity_mean_of_interest - intensity_mean_min) / (intensity_mean_max - intensity_mean_min);
    intensity_std_of_interest = intensity_std_of_interest / (intensity_mean_max - intensity_mean_min);
    

end

   
%% plot하기

% 실험값 graph 그리기




hold on

%plot(exp_data_1(:,1), exp_data_1(:,2),'marker','.', 'MarkerSize',7,'Color','r','LineStyle','none')
%plot(exp_data_2(:,1), exp_data_2(:,2),'marker','.', 'MarkerSize',7,'Color','g','LineStyle','none')

%plot(a, matrix_C_region,'marker','.', 'MarkerSize',7,'Color','b','LineStyle','none')
%plot(a, matrix_D_region,'marker','.', 'MarkerSize',7,'Color','black','LineStyle','none')

% 실험값 error bar

%e1=errorbar(exp_data_1(:,1), exp_data_1(:,2), exp_data_1(:,3),'-s','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','CapSize',1, 'Color', 'r');
%e2=errorbar(exp_data_2(:,1), exp_data_2(:,2), exp_data_2(:,3),'-s','MarkerSize',3,'MarkerEdgeColor','g','MarkerFaceColor','g','CapSize',1, 'color', 'g');
% e3=errorbar(a,matrix_C_region,div_C,div_C,'-s','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','CapSize',1, 'color', 'b');
% e4=errorbar(a,matrix_D_region,div_D,div_D,'-s','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','black','CapSize',1, 'color', 'black');

for p=1:(polyend-polystart+1)
    errorbar(FileNameArray,intensity_mean_of_interest(:,p),intensity_std_of_interest(:,p),'-s','MarkerSize',3,'MarkerEdgeColor',color_list{p},'MarkerFaceColor',color_list{p},'CapSize',1, 'Color', color_list{p})
end



% 이론값 plot



% nor_I_ABC = I_ABC/max(I_ABC);
% nor_I_ABA = I_ABA/max(I_ABC);
% nor_I_CBA = I_CBA/max(I_ABC);
% nor_I_ACA = I_ACA/max(I_ABC);
% 
% sz = 12;
% 
% plot(x, nor_I_ABC, 'Color','r')
% plot(x, nor_I_ABA, 'Color','g')
% plot(x, nor_I_CBA, 'Color','b')
% plot(x, nor_I_ACA, 'Color','black')
% 
% 
% e1=errorbar(a,matrix_A_region,div_A,div_A,'-s','MarkerSize',3,'MarkerEdgeColor','r','MarkerFaceColor','r','CapSize',1, 'Color', 'r');
% e2=errorbar(a,matrix_B_region,div_B,div_B,'-s','MarkerSize',3,'MarkerEdgeColor','g','MarkerFaceColor','g','CapSize',1, 'color', 'g');
% e3=errorbar(a,matrix_C_region,div_C,div_C,'-s','MarkerSize',3,'MarkerEdgeColor','b','MarkerFaceColor','b','CapSize',1, 'color', 'b');
% e4=errorbar(a,matrix_D_region,div_D,div_D,'-s','MarkerSize',3,'MarkerEdgeColor','black','MarkerFaceColor','black','CapSize',1, 'color', 'black');


% legend 등


legend(legend_list, 'fontsize',7)


xlabel('Tilt Angle [deg]','FontSize',10)
ylabel('Normalized Intensity [a.u.]','FontSize',10)
ylim([0,1])
xlim([-20, 20])

grid on
box on

hold off


