clear;close all;clc;

% Material: WSe2

voltage = 200000;
ph = 0; % tilt 축과 g vector 간 각도 - 90도
% c = 6.15; %A
% d = 3.16*sqrt(3)/2;
% k_r = 1/d;
% phase = [-1/3, 1/3, 0];
% g = [1, 0, 0];
% f_w = 42; %W atomic form factor
% f_Se = 16; %Se atomic form factor
% l_2 = c;
% l_1 = 3.28*cos(pi/3);

c = 0.618; %A
d = 0.328*sqrt(3)/2;
phase = [-1/3, 1/3, 0];
g = [1, 0, 0];
f_w = 73.57;
f_Se = 33.76;
% l_2 = c;
% l_1 = 3.28*cos(pi/3);




% 이론값 graph

wavelength = 1.226/((voltage*(1+9.788e-7*voltage)^(1/2))); % [nm]
k_r = 1/d;
k_0 = 1/wavelength;
s = k_0-sqrt(k_0^2-k_r^2);


x = linspace(-20, 20, 1000);
angle=x;
kz = k_r*tan(angle*pi/180)*cos(ph*pi/180)+s;

S_MoS2=f_w+2*f_Se*cos(c*kz/2)*exp(-2*1i*pi*dot(phase,g));

F_ABC= times(S_MoS2,1+2*cos(2*pi*c*kz+2*pi*dot(phase, g)));
F_ABA= times(S_MoS2,1+2*exp(-2*pi*1i*dot(phase,g))*cos(2*pi*c*kz));
F_CBA= times(S_MoS2,1+2*cos(2*pi*c*kz-2*pi*dot(phase,g)));
F_ACA= times(S_MoS2,1+2*exp(2*pi*1i*dot(phase,g))*cos(2*pi*c*kz));
I_ABC = conj(F_ABC).*F_ABC;
I_ABA = conj(F_ABA).*F_ABA;
I_CBA = conj(F_CBA).*F_CBA;
I_ACA = conj(F_ACA).*F_ACA;

%graph 그리기

figure()

hold on
fontsize(14,"points")

nor_I_ABC = I_ABC/max(I_ABC);
nor_I_ABA = I_ABA/max(I_ABC);
nor_I_CBA = I_CBA/max(I_ABC);
nor_I_ACA = I_ACA/max(I_ABC);

sz = 12;

plot(x, nor_I_ABC,'linewidth',3, 'Color','#E67B99')
plot(x, nor_I_ABA,'linewidth',3, 'Color','#99CCB3')
plot(x, nor_I_CBA,'linewidth',3, 'Color','#6699CC')
plot(x, nor_I_ACA,'linewidth',3, 'Color','#BB8FCE','LineStyle','--')



legend('ABC', 'ABA', 'CBA','CBC','Location','north')
xlabel('Tilt Angle [deg]')
ylabel('Normalized Intensity [a.u.]')
ylim([-0.05,1.1])
xlim([-20, 20])

grid on

box on
hold off


%함수 정의

% function k_z = k_z(angle)
%     r_0 = 0.328;
%     d = r_0*sqrt(3)/2;
%     voltage = 200000;
%     wavelength = 12.26/((voltage*(1+0.9788e-6*voltage)^(1/2)));
%     k_r = 1/d;
%     k_0 = 1/wavelength;
%     s = k_0-sqrt(k_0^2-k_r^2);
%     ph = 0;
%     c = 0.615;
% 
% 
%     k_z = k_r*tan(angle*pi/180)*cos(ph*pi/180)+s;
% end