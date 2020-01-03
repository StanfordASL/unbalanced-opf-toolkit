%	This code generates the simulations included in
%
%	S. Bolognani, F. Dörfler (2015)
%	"Fast power system analysis via implicit linearization of the power flow manifold."
%	In Proc. 53rd Annual Allerton Conference on Communication, Control, and Computing.
%	Preprint available at http://control.ee.ethz.ch/~bsaverio/papers/BolognaniDorfler_Allerton2015.pdf
%
%	This source code is distributed in the hope that it will be useful, but without any warranty.
%
%	MatLab OR GNU Octave, version 3.8.1 available at http://www.gnu.org/software/octave/
%	MATPOWER 5.1 available at http://www.pserc.cornell.edu/matpower/
%

close all
clear all
clc

% 2-bus case
% bus 0: voltage = 1, theta = 0
% bus 1: voltage = v, theta = t

% range for the meshplot
% voltage
v = 0.65:0.05:1.25;
vn = length(v);
% theta
t = -pi/3:pi/16:pi/3;
tn = length(t);

% impedance of the line connecting 1 to 2
z = 0.5+1j;
y = 1/z;
g = real(y);
b = imag(y);

% Laplacian
L = [y -y;-y y];

% linearization point
V1 = 1;
T1 = 0;

%%%%%%%%%%%%%%%%%%%%%%%%% Solution of the nl power flow equations

% complete vectors p and q as solutions given v and t
p = zeros(vn,tn);
q = zeros(vn,tn);
ir = zeros(vn,tn);
ii = zeros(vn,tn);

for vi = 1:vn
	for ti = 1:tn
		vl = v(vi)*exp(1j*t(ti));
		il = L*[1;vl];
		s=vl*conj(il(2));
		ir(vi,ti)=real(il(2));
		ii(vi,ti)=imag(il(2));
		p(vi,ti)=real(s);
		q(vi,ti)=imag(s);
	end
end

% compute solution at linearization point
vl = V1*exp(1j*T1);
il = L*[1;vl];
s=vl*conj(il(2));
I1=il(2);
IR1=real(I1);
II1=imag(I1);
P1=real(s);
Q1=imag(s);

%%%%%%%%%%%%%%%%%%%%%%%%% Tangent space

TH = [0; T1];
V = [1; V1];
I = [-I1; I1];

pl = zeros(vn,tn);
ql = zeros(vn,tn);

for vi=1:vn
	for ti = 1:tn
		itmp = bracket(L)*Rmatrix(V,TH)*[0;v(vi)-V1;0;t(ti)-T1];
		stmp = bracket(diag(conj(I)))*Rmatrix(V,TH)*[0;v(vi)-V1;0;t(ti)-T1] ...
				+ bracket(diag(V.*exp(1j*TH)))*Nmatrix(4)*itmp;
		pl(vi,ti) = P1 + stmp(2);
		ql(vi,ti) = Q1 + stmp(4);
	end
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%% FIG 1: P Q V

%close(1)
figure(1)
hold on

% true manifold

for vi=1:vn
	plot3(p(vi,:),q(vi,:),v(vi)*ones(tn,1),'k');
end

for ti=1:tn
	plot3(p(:,ti),q(:,ti),v,'k');
end

scatter3(P1,Q1,V1,69,'filled', 'r')

% linear manifold

for vi=1:vn
	plot3(pl(vi,:),ql(vi,:),v(vi)*ones(tn,1),'r');
end

for ti=1:tn
	plot3(pl(:,ti),ql(:,ti),v,'r');
end

xlabel('p_2')
ylabel('q_2')
zlabel('v_2')

%%
%%%%%%%%%%%%%%%%%%%%%%%%% FIG 2: P Q TH

figure(2)
hold on

% nonlinear manifold

for vi=1:vn
	plot3(p(vi,:),q(vi,:),t,'k');
end

for ti=1:tn
	plot3(p(:,ti),q(:,ti),t(ti)*ones(vn,1),'k');
end

scatter3(P1,Q1,T1,9,'filled')

% linear manifold

for vi=1:vn
	plot3(pl(vi,:),ql(vi,:),t,'r');
end

for ti=1:tn
	plot3(pl(:,ti),ql(:,ti),t(ti)*ones(vn,1),'r');
end

xlabel('p')
ylabel('q')
zlabel('theta')

%%
%%%%%%%%%%%%%%%%%%%%%%%%% FIG 3: V TH P

figure(3)
hold on

% nonlinear manifold

for vi=1:vn
	plot3(v(vi)*ones(tn,1),t,p(vi,:),'k');
end

for ti=1:tn
	plot3(v,t(ti)*ones(vn,1),p(:,ti),'k');
end

scatter3(V1,T1,P1,69,'filled', 'r')

% linear manifold

for vi=1:vn
	plot3(v(vi)*ones(tn,1),t,pl(vi,:),'r');
end

for ti=1:tn
	plot3(v,t(ti)*ones(vn,1),pl(:,ti),'r');
end

xlabel('v_2')
ylabel('\theta_2')
zlabel('p_2')


%%
%%%%%%%%%%%%%%%%%%%%%%%%% FIG 4: V TH Q

figure(4)
hold on

% nonlinear manifold

for vi=1:vn
	plot3(v(vi)*ones(tn,1),t,q(vi,:),'k');
end

for ti=1:tn
	plot3(v,t(ti)*ones(vn,1),q(:,ti),'k');
end

scatter3(V1,T1,Q1,69,'filled', 'r')

% linear manifold

for vi=1:vn
	plot3(v(vi)*ones(tn,1),t,ql(vi,:),'r');
end

for ti=1:tn
	plot3(v,t(ti)*ones(vn,1),ql(:,ti),'r');
end

xlabel('v_2')
ylabel('\theta_2')
zlabel('q_2')

%%
%%%%%%%%%%%%%%%%%%%%%%%%% FIG 5: TH P V

figure(5)
hold on

% nonlinear manifold

for vi=1:vn
	plot3(t,p(vi,:),v(vi)*ones(tn,1),'k');
end

for ti=1:tn
	plot3(t(ti)*ones(vn,1),p(:,ti),v,'k');
end

scatter3(T1,P1,V1,69,'filled', 'r')

% linear manifold

for vi=1:vn
	plot3(t,pl(vi,:),v(vi)*ones(tn,1),'r');
end

for ti=1:tn
	plot3(t(ti)*ones(vn,1),pl(:,ti),v,'r');
end

xlabel('\theta_2')
ylabel('p_2')
zlabel('v_2')
