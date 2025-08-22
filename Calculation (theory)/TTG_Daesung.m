c = 3.348
d = 2.464*sqrt(3)/2
k_r = 1/d
phase = [1/3, 1/3, 0]
g = [1, 0, 0]



% 이론값 graph

x = linspace(-18, 18, 1000);

kz = k_z(x)
F_ABC= 1+2*cos(2*pi*3.346*kz+2*pi*dot(phase, g));
F_ABA= 1+2*exp(-2*pi*i*dot(phase,g))*cos(2*pi*c*kz)
F_CBA= 1+2*cos(2*pi*c*kz-2*pi*dot(phase,g))
F_ACA= 1+2*exp(2*pi*i*dot(phase,g))*cos(2*pi*c*kz)
I_ABC = conj(F_ABC).*F_ABC
I_ABA = conj(F_ABA).*F_ABA
I_CBA = conj(F_CBA).*F_CBA
I_ACA = conj(F_ACA).*F_ACA

%graph 그리기

figure('pos', [100,100,550,600])

hold on

nor_I_ABC = I_ABC/max(I_ABC)
nor_I_ABA = I_ABA/max(I_ABC)
nor_I_CBA = I_CBA/max(I_ABC)
nor_I_ACA = I_ACA/max(I_ABC)

sz = 12;

%plot(x, nor_I_CBA,'linewidth', 2, 'Color','blue')
%plot(x, nor_I_ACA,'linewidth', 2, 'Color','g')
plot(x, nor_I_ABA,'linewidth', 1, 'Color','r')
plot(x, nor_I_ABC,'linewidth', 1, 'Color','blue')




hold off

fontsize(gcf,13,"points")

legend('ABA', 'ABC','Location','north')
%xlabel('tilt angle(deg)','FontSize',10)
%ylabel('Intensity(a.u.)','FontSize',10)

xticks([-20, -10, 0, 10, 20])
yticks([0, 0.25 ,0.5,0.75, 1])

ylim([0,1])
xlim([-20 20])
%grid on
box on
grid off
%함수 정의

function k_z = k_z(angle)
    d = 2.464*sqrt(3)/2
    voltage = 800000
    wavelength = 1.226/((voltage*(1+0.9788e-6*voltage))^(1/2))
    k_r = 1/d
    k_0 = 1/wavelength
    s = k_0-sqrt(k_0^2-k_r^2)
    ph = 68.54+(-6.99)-90
    c = 3.348


    k_z = k_r*tan(-angle*pi/180)*cos(ph*pi/180)+s
end