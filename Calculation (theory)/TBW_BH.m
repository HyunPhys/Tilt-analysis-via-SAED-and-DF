% syms rx ry rz kx ky kz
% assume(kx, 'real');
% assume(ky, 'real');
% assume(kz, 'real');

close all

% DF 이미징 관련 정보 (실험)
g=[1,0,0]; % in reciprocal space

ph=0.28; % abs(tilt 축과 g vector 간 각도) - 90도

voltage=200*1000; % e-beam voltage (unit: V)


% 크리스탈 정보 #######################################################################################
% scattering amplitude
W_s=74;
Se_s=34;


%unit cell 정보 (unit: nm) (hexagonal cell assumed)
a=0.328;
b=0.328;
c=0.618; % i.e. interlayer spacing


% Crystal 내 atom의 position (monolayer) (in crystallographic direction)
W1=[0.66666666666667,0.33333333333333,0.25];
Se1=[0.333333333333333,0.666666666666667,0.121];
Se2=[0.333333333333333,0.666666666666667,0.379];

% large Delta in Stacking, strain article; 즉 interlayer sliding
phase_AB = [-1/3, 1/3, 0]; % 이건 기존 TTT progress의 convention을 따른 것임
phase_BA = [1/3, -1/3, 0];

% Plot 관련
angle=-20:0.1:20; % plot할 angle 범위

angle_to_plot = angle;



%% e-beam

wavelength=1.226/((voltage*(1+9.788e-7*voltage)^(1/2))); % incident beam wavelength [nm]
% 2.5079pm   (wavelength=2.5079/1000nm)
k0=1/wavelength; % incident beam wavenumber

%% Ewald Sphere

% kx=g(1); ky=g(2);
d_hexa = 1/sqrt( (4/3) * ((g(1)^2+g(1)*g(2)+g(2)^2)/(a^2)) + (g(3)^2)/c^2 ); % hexagonal lattice의 면간거리(interplanar spacing) 공식

kr=1/d_hexa;
s=k0-sqrt(k0^2-kr^2);
kz=kr*tan(deg2rad(angle))*cos(deg2rad(ph))+s;


%% Structure factor

% Calculating structure factor (of unit cell)
Str_fac = W_s * exp(-2*pi*1i*dot(g,W1)) + Se_s * exp(-2*pi*1i*dot(g,Se1)) + Se_s * exp(-2*pi*1i*dot(g,Se2));

F_AB= Str_fac*2*cos(pi*c*kz+pi*dot(phase_AB, g));
F_BA= Str_fac*2*cos(pi*c*kz+pi*dot(phase_BA, g));

I_AB = conj(F_AB).*F_AB;
I_BA = conj(F_BA).*F_BA;

nor_I_AB = (I_AB-min(I_AB))/(max(I_AB)-min(I_AB));
nor_I_BA = (I_BA-min(I_BA))/(max(I_BA)-min(I_BA));


figure()

hold on

plot(angle_to_plot,nor_I_AB,'Color','r')
plot(angle_to_plot,nor_I_BA,'Color','g')

legend('AB', 'BA','Location','north')
xlabel('Tilt Angle [deg]','FontSize',10)
ylabel('Normalized Intensity [a.u.]','FontSize',10)
ylim([0,1])
%xlim([-20, 20])

box on
grid on

hold off


