%% Import Data

close all

% 폴더로 이동

cd 'raw data'

% 데이터 파일 이름

% filename_exp_1 = "mean_and_std_left_raw.xlsx";
% filename_exp_2 = "mean_and_std_right_raw.xlsx";
% filename_the_1 = "mean_and_std_right.xlsx";
% filename_the_2 = "mean_and_std_right.xlsx";

load("mean_and_std_250807.mat")


% 관심있는 polygon 선택
polystart = 1;
polyend = 4;

intensity_mean_of_interest = intensity_mean(1:end,polystart:polyend);
intensity_std_of_interest = intensity_std(1:end,polystart:polyend);


% Plot 관련 설저
% MarkerFace_list = {"#E67B99","#99CCB3","#BB8FCE","#6699CC"};
% MarkerEdge_list = {"#8A4A5C","#5C7A6B","#70567B","#2A4D6F"};
% color_list = {"#B8637A", "#7AA38F", "#9672A5", "#4072A0"};
% MarkerFace_list = {"#FF4477", "#44CCAA", "#AA66FF", "#4477FF"};
% MarkerEdge_list = {"#CC3366", "#33AA88", "#8844CC", "#3344CC"};
% color_list      = {"#FF3366", "#33CC99", "#9966FF", "#3366FF"};
MarkerFace_list = {"#E86880", "#63C4B5","#4C85E5", "#A976D7"};
MarkerEdge_list = {"#B8475C", "#3B8F7F","#2A5FBF", "#714C9E"};
color_list      = {"#D2526B", "#47B3A4","#467DE3", "#8E5ECF"};


legend_list = {'A','B','C','D'}; % ROI 이름을 string으로 넣기...


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


figure()

hold on

fontsize(14,"points")

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
    errorbar(FileNameArray,intensity_mean_of_interest(:,p),intensity_std_of_interest(:,p), ...
        '-o','MarkerSize',4,'MarkerEdgeColor',MarkerEdge_list{p}, ...
        'MarkerFaceColor',MarkerFace_list{p},'CapSize',3, 'Color', color_list{p}, ...
        'LineWidth',1)
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


legend(legend_list,'Location','north')


xlabel('Tilt Angle [deg]')
ylabel('Normalized Intensity [a.u.]')
ylim([-0.05,1.1])
xlim([-20, 20])

grid on
box on

hold off


