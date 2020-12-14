function [ Rot_femur_r ] = Femur_Mat_Rot(origin,proximal,lateral,anterior)
%UNTITLED3 Summary of this function goes here
Y = lateral - origin;
Y = Y/sqrt(Y(1)^2+Y(2)^2+Y(3)^2);

X = anterior - origin;
X = X/sqrt(X(1)^2+X(2)^2+X(3)^2);

Z = cross(X,Y);
Z = Z/sqrt(Z(1)^2+Z(2)^2+Z(3)^2);

Rot_femur_r=[X',Y',Z'];
% A12=transpose(A21);

end