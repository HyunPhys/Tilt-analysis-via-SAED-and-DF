# -*- coding: utf-8 -*-

import numpy as np
import matplotlib.pyplot as plt

"""
Ewald sphere 곡률 -> exciation error s에 반영됨
Shape factor (Bragg rod) -> kz 계산 식에 반영됨

Material: MoS2
"""


#%% Crystal information

# lattice constant (unit: nm)


# WSe2
a=0.328
b=0.328
c=0.618


"""
# MoS2
a = 0.316
b = 0.316
c = 0.615 # c축값 = interplanar spacing
"""


# in-plane sliding vector (i.e. Delta vector) (coordinate: lattice)

delta_vector = np.array([-1/3,1/3]) # sliding vector가 positive: AA -> AB로의 stacking인 convention 사용

# Atomic form factor


f_Atom1 = 74 # W
f_Atom2 = 34 # Se

"""
f_Atom1 = 42 # Mo
f_Atom2 = 16 # S
"""

# Atom 1 position in unit cell (기준: monolayer, lattice coordinate (NOT CARTESIAN))
# -> Moledenium
Atom1 = np.array([[1/3, 2/3, 0.5]])

# Atom 2 position in unit cell (기준: monolayer, lattice coordinate (NOT CARTESIAN))
# -> Selenide
Atom2 = np.array([
    [2/3, 1/3, 0.742],
    [2/3, 1/3, 0.254]
])

#%% TEM imaging condition

g = np.array([1, 0, 0]) # Tilt series (DF image)를 촬영할 때 고른 peak의 index

# e-빔 전압 (V)
voltage = 200 * 1000  # 200 kV


# ph 설정 (degrees)
ph = 68.54 - (-7.72) - 90  # "tilt 축과 g vector 간의 각도" - 90도 = 인값을 넣어야 함.

# 각도 범위 설정 (degrees)
angle_deg = np.arange(-20, 20, 0.1)
angle_rad = np.deg2rad(angle_deg)  # radians로 변환






#%%

# 1. in-plane reciprocal vector 설정 (unit: dimensionless): 원래는 이렇게 하면 안 됨! (rectangular하지 않으므로...)
# 그러나 어차피 kx, ky는 rx, ry랑 연산될 것이기에, unit을 제거함.
kx = g[0]
ky = g[1]


# 2. e-beam wavelength 계산
wavelength = 1.226 / (voltage * np.sqrt(1 + 9.788e-7 * voltage))  # unit: nm
k0 = 1 / wavelength  # nm^-1

# 3. in-plane reciprocal distance kr 계산 - unit cell, diffraction peak 선택에 따라 달라짐
kr = 2 / (np.sqrt(3)*a) # hexagonal lattice, 1st order Bragg peak의 경우 이러함.
# kr = np.sqrt( (kx)**2 + (ky)**2 )

# 4. excitation error "s"
s = k0 - np.sqrt(k0**2 - kr**2)


# 5. kz 계산 (각도에 따른)
kz = kr * np.tan(angle_rad) * np.cos(np.deg2rad(ph)) + s # unit: nm^-1




# in-plane 방향 phase 계산
phase_Atom1 = kx * Atom1[0,0] + ky * Atom1[0,1] + kz * Atom1[0,2]
phase_Atom2_1 = kx * Atom2[0,0] + ky * Atom2[0,1] + kz * Atom2[0,2]
phase_Atom2_2 = kx * Atom2[1,0] + ky * Atom2[1,1] + kz * Atom2[1,2]

# 2-dimensional structure factor 계산
F_2D = f_Atom1 * np.sum(np.exp(-2* np.pi* 1j * phase_Atom1)) + f_Atom2 * np.sum(np.exp(-2* np.pi* 1j * phase_Atom2_1)) + f_Atom2 * np.sum(np.exp(-2* np.pi* 1j * phase_Atom2_2))




# out-of-plane 방향 phase 계산 - 각도마다 kz가 다르므로 브로드캐스팅을 활용
phase_AB = (kx * delta_vector[0] + 
           ky * delta_vector[1] + 
           kz[:, np.newaxis] * c)
phase_BA = (kx * (-delta_vector[0]) + 
           ky * (-delta_vector[1]) + 
           kz[:, np.newaxis] * c)


# Wavefunction  계산
Psi_AB = F_2D * ( 1 + np.exp(-2*np.pi*1j * phase_AB) )
Psi_BA = F_2D * ( 1 + np.exp(-2*np.pi*1j * phase_BA) )


# Intensity 계산
I_AB = np.abs(Psi_AB)**2
I_BA = np.abs(Psi_BA)**2



# 정규화
domain_max = np.max( np.array([np.max(I_AB), np.max(I_BA) ]) )
domain_min = np.min( np.array([np.min(I_AB), np.min(I_BA) ]) )

I_AB_nor = (I_AB-domain_min) / (domain_max - domain_min)
I_BA_nor = (I_BA-domain_min) / (domain_max - domain_min)


# 플롯 설정
plt.figure(figsize=(10, 6))
plt.plot(angle_deg, I_AB_nor, color=(219/255, 78/255, 22/255), label='AB')
plt.plot(angle_deg, I_BA_nor, color=(100/255, 78/255, 10/255), label='BA')
# plt.xlim([-30, 30])
plt.xlabel('Angle (degrees)', fontsize=14)
plt.ylabel('Normalized Intensity', fontsize=14)
plt.title('Intensity vs Angle', fontsize=16)
plt.legend()
plt.grid(True)
plt.show()


#%% AB, BA domain contrast가 같은 alpha-tilt 각도 찾기

neg_indices = np.where(angle_deg < 0)[0]

neg_indices_equal = np.array([], dtype=int)

for idx in neg_indices:
    if (np.abs(I_AB_nor[idx] - I_BA_nor[idx]) <= 0.01):
        neg_indices_equal = np.append(neg_indices_equal, idx)


# Tilt-angle setting
#neg_indices_eq_min = np.max(neg_indices_equal) # auto (from tilt dependence)
neg_indices_eq_min = 110 # manual (set with index, NOT angle itself)
print(angle_deg[neg_indices_eq_min]) # angle 확인용

#%% AB, BA domain contrast가 같은 곳에서의 burgers vector 별 contrast

# Burgers vector setting (주의! Burgers vector 선택은, 맨 처음의 `delta_vector`를 잘 고려해서 골라야 한다.)
burgers1 = np.array([2/3,1/3]) # b = 1/3 [10-10] in 4 index
burgers2 = np.array([-1/3,1/3]) # b = 1/3 [-1100] in 4 index
burgers3 = np.array([-1/3,-2/3]) # b = 1/3[0-110] in 4 index

slider = np.arange(0,1,0.01) # AB -> BA로 sliding하는 것...

# phase: stacking order transition: AB -> BA, at specific alpha-tilt angle
phase_b1 = (kx * (delta_vector[0] + burgers1[0] * slider) + 
           ky * (delta_vector[1] + burgers1[1] * slider)+ 
           kz[neg_indices_eq_min, np.newaxis] * c)

phase_b2 = (kx * (delta_vector[0] + burgers2[0] * slider) + 
           ky * (delta_vector[1] + burgers2[1] * slider)+ 
           kz[neg_indices_eq_min, np.newaxis] * c)

phase_b3 = (kx * (delta_vector[0] + burgers3[0] * slider) + 
           ky * (delta_vector[1] + burgers3[1] * slider)+ 
           kz[neg_indices_eq_min, np.newaxis] * c)

# Wavefunction 계산
Psi_b1 = F_2D * ( 1 + np.exp(-2*np.pi*1j * phase_b1) )
Psi_b2 = F_2D * ( 1 + np.exp(-2*np.pi*1j * phase_b2) )
Psi_b3 = F_2D * ( 1 + np.exp(-2*np.pi*1j * phase_b3) )


# Intensity 계산
I_b1 = np.abs(Psi_b1)**2
I_b2 = np.abs(Psi_b2)**2
I_b3 = np.abs(Psi_b3)**2



# 정규화
burgers_max = np.max(np.array([I_b1, I_b2, I_b3]))
burgers_min = np.min(np.array([I_b1, I_b2, I_b3]))

I_b1_nor = (I_b1-burgers_min) / (burgers_max - burgers_min)
I_b2_nor = (I_b2-burgers_min) / (burgers_max - burgers_min)
I_b3_nor = (I_b3-burgers_min) / (burgers_max - burgers_min)


# 플롯 설정
plt.figure(figsize=(10, 6))
plt.plot(slider, I_b1_nor, color=(255/255, 0/255, 0/255), label='b1',ls='--')
plt.plot(slider, I_b2_nor, color=(0/255, 176/255, 80/255), label='b2', ls='--')
plt.plot(slider, I_b3_nor, color=(0/255, 176/255, 240/255), label='b3', ls='--')
# plt.xlim([-30, 30])
plt.xlabel('Stacking Order: from AB to BA', fontsize=14)
plt.ylabel('Normalized Intensity', fontsize=14)
plt.title('Domain wall intensity', fontsize=16)
plt.legend()
plt.grid(True)
plt.show()

