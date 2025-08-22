%% 각도에 따른 intensity (- 걸면 드러나는 영역)
close all; clear all;
cd 'raw data'

% 데이터 파일 이름 (안 바꾸면 이전 데이터 겹쳐지면서 날아감!)
% 서식: processed_data_dataname.mat
dataname = '250822_try_1';

% 정보 저장할 행렬
dat=[];
poly_info = [];

isreduce = false; %이미지 사이즈 조정할 것인지


formatSpec = '%.1f';
polygon_num = 2; % 만들 ROI 개수

isGaussian = true; % Gaussian filter 적용할 것인지
gaussian_size = 2; % Gaussian filter size (default: 2)3



% 아래에 파일 이름 적어주면 됨 (정확하게)
FileNameArray = [
-15.9
-14.2
-12.1
-10.1
-8.0
-6.0
-4.0
-2.0
0.2
2.3
4.4
6.5
8.6
10.7
12.7
14.8
15.8
    ];

% 이상값 제거용 기준값 - by manual: img 실제로 로딩 후 데이터들 살펴보고, max(max(img))해서 적당한
% threshold 설정할 것
threshold = 200;
threshold_negative = -1;


% normalize 용 constant (전체 intensity의 나누기)
divider = 1;

% Set the width and height of the rectangle
width = 20;
height = 20;

% Set the rotation angle in degrees
rotationAngle = 0; % in degrees

color_list = {"r","g","b","c","m","y","k"}; % 만약 ROI 수가 7개를 넘어간다면, 이 코드 비활성화하고, 아래의 "Color setting" 부분을 활성화할 것



%% Color setting

% color_code = [0,1,0]; % Green
% 
% color_list = {};
% color_adjust = 1/(polygon_num+1);
% 
% for idx = 1:polygon_num
%     color_list{idx} = color_code;
%     color_code(1) = color_code(1) + color_adjust;
%     color_code(2) = color_code(2) - color_adjust;
%     color_code(3) = color_code(3) + color_adjust;
% end

%% 이하 건드릴 필요 X

lw = 1;

img=imread(strcat(num2str(FileNameArray(1),formatSpec),'.tif'));

% for idx1 = 1:length(img)
%     for idx2 = 1:length(img)
%         if img(idx1,idx2) > threshold
%             img(idx1,idx2) = 0;
%         end
%     end
% end

% if isreduce == true
% 
%     img=im2gray(img)/3000;
%     figure()
% 
%     imshow(img);
%     title('Select a reduced image region: Click top left of region, then bottom right, then press enter. Close figure automatically')
% 
%     [x, y]=getpts(); %Click in top left and bottom right of desired window
%     topleft=[x(1),y(1)];
%     botright=[x(2),y(2)];
%     clear x y 
%     close all
% 
% end

k=1;

for l = 1:length(FileNameArray)
    image_raw=imread(strcat(num2str(FileNameArray(l),formatSpec),'.tif'));

    if isGaussian == true
        image_raw = imgaussfilt(image_raw,gaussian_size); %guassian filter is optional to smooth the data a bit. here the gaussian size is 2 pixels
    end


    % image1=im2gray(image)/max(max(image));
    % image1=im2gray(image_raw)/3000;
    image_plot = im2gray(image_raw)/divider;

    for idx1 = 1:length(image_plot)
        for idx2 = 1:length(image_plot)
            if image_plot(idx1,idx2) > threshold/divider
                image_plot(idx1,idx2) = 0;
            end
        end
    end

    for idx1 = 1:length(image_plot)
        for idx2 = 1:length(image_plot)
            if image_plot(idx1,idx2) < threshold_negative/divider
                image_plot(idx1,idx2) = 0;
            end
        end
    end

    figure (l)
    %colormap gray
    %image_plot = image(image1);
    
    imshow(image_plot, [])

    hold on

   

    for p = 1:polygon_num

        % zoom on;
        image1=im2gray(image_raw);
        % Prompt the user to zoom to the desired area
        % disp('Zoom into the image to the desired level, then press a key to continue.');
        tx = sprintf('%d th data, %d th polygon',k,p);
        title(tx)
        % disp(tx);
        % pause; % Wait for a key press
        % 
        % % Disable zooming
        % zoom off;
        % clear image1
        
        % image1=im2gray(image)/max(max(image));
        % image1=im2gray(image)/3000;
    
        % 이미지로 errorbar 그리기 위해서 이미지와 같은 크기의 행렬도입
        sz=size(image_raw);
        one_image=logical(ones(sz(1),sz(2)));
        
    
        % Let the user select the bottom-left corner of the rectangle
        [x_i, y_i] = ginput(1); % Get one point for the bottom-left corner
        bottomLeftX = x_i;
        bottomLeftY = y_i;
    
        % Calculate the coordinates of the rectangle's corners
        theta = deg2rad(rotationAngle);
        coordX = bottomLeftX + [0, width, width, 0] * cos(theta) - [0,0,height, height] * sin(theta);
        coordY = bottomLeftY - [0, width, width, 0] * sin(theta) - [0,0,height, height] * cos(theta);
        
        poly_coord = [coordX; coordY];
    
        % Create a binary mask using these coordinates
        M = poly2mask(coordX, coordY, size(image_raw, 1), size(image_raw, 2));
    
        % Apply the mask to the image
        % image_raw(M == 0) = 0;
        image1(M == 0) = 0;
        % imshow(image1);
        plot([coordX(1),coordX(2)],[coordY(1),coordY(2)],'color',color_list{p},'LineWidth',lw)
        plot([coordX(2),coordX(3)],[coordY(2),coordY(3)],'color',color_list{p},'LineWidth',lw)
        plot([coordX(3),coordX(4)],[coordY(3),coordY(4)],'color',color_list{p},'LineWidth',lw)
        plot([coordX(4),coordX(1)],[coordY(4),coordY(1)],'color',color_list{p},'LineWidth',lw)
        one_image(M==0)=0;
        
    
        
       
        % 평균 intensity 구하기
        intensity = nonzeros(image1);
        % matrix_up(k,1)=l; % 엑셀 1열: 각도 정보
        % matrix_up(k,2)=bottomLeftX; % 엑셀 2열: 내가 찍은 점의 x좌표
        % matrix_up(k,3)=bottomLeftY; % 엑셀 3열: 내가 찍은 점의 y좌표
        % matrix_up(k,4:(length(intensity)+3))=transpose(intensity); % 엑셀 4열 이후: 데이터
        poly_info(k,p,:,:) = poly_coord; %k번째 이미지의 p번째 rectangle의 좌표

        if length(intensity) ~= width * height
            intensity = [intensity; zeros(width * height - length(intensity),1)];
        end


        dat(k,p,:) = transpose(intensity);

        clear x_i y_i bottomLeftX bottomLeftY coordX coordY poly_coord intensity image1

    end
    
    k=k+1;

    hold off
    
    close

end


%% Save files


datafilename = sprintf("processed_data_%s.mat",dataname);
save(datafilename, "FileNameArray", "poly_info", "dat","polygon_num")
excelfilename = strcat(dataname,'.xlsx');
writematrix(dat, excelfilename)

close all
