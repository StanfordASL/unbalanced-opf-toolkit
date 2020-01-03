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

clear all
close all
clc

% Import MatPower 5.1 library

addpath('matpower5.1');
define_constants;

% Load grid model

mpc = loadcase('case14');
n = size(mpc.bus,1);

% Compute exact solution via MatPower

results = runpf(mpc, mpoption('VERBOSE', 0, 'OUT_ALL',0));

% Get admittance matrix, power injections, and voltage references, from the model

Ybus = makeYbus(mpc.baseMVA, mpc.bus, mpc.branch);
Sbus = makeSbus(mpc.baseMVA, mpc.bus, mpc.gen);
Pbus = real(Sbus);
Qbus = imag(Sbus);

Vbus = NaN(n,1);
Vbus(mpc.gen(:,GEN_BUS)) = mpc.gen(:,VG);

%%%%% LINEARIZED MODEL %%%%%

%%%%% Linearization point (given voltage magnitude and angle)

% Flat voltage profile
V0 = ones(n,1);
A0 = zeros(n,1);

% Corresponding current injection
J0 = Ybus*(V0.*exp(1j*A0));

% Corresponding power injection
S0 = V0.*exp(1j*A0).*conj(J0);
P0 = real(S0);
Q0 = imag(S0);

%%%%% Linear system of equations for the grid model

UU = bracket(diag(V0.*exp(1j*A0)));
JJ = bracket(diag(conj(J0)));
NN = Nmatrix(2*n);
YY = bracket(Ybus);
PP = Rmatrix(ones(n,1), zeros(n,1));

AA = zeros(2*n,4*n);
BB = zeros(2*n,1);

V_OFFSET = 0;
A_OFFSET = 1*n;
P_OFFSET = 2*n;
Q_OFFSET = 3*n;

% bus models

for bus = 1:n
	row = 2*(bus-1)+1;
	if (mpc.bus(bus,BUS_TYPE)==PQ)
		AA(row,P_OFFSET+bus) = 1;
		BB(row) = Pbus(bus) - P0(bus);
		AA(row+1,Q_OFFSET+bus) = 1;
		BB(row+1) = Qbus(bus) - Q0(bus);
	elseif (mpc.bus(bus,BUS_TYPE)==PV)
		AA(row,P_OFFSET+bus) = 1;
		BB(row) = Pbus(bus) - P0(bus);
		AA(row+1,V_OFFSET+bus) = 1;
		BB(row+1) = Vbus(bus) - V0(bus);
	elseif (mpc.bus(bus,BUS_TYPE)==REF)
		AA(row,V_OFFSET+bus) = 1;
		BB(row) = Vbus(bus) - V0(bus);
		AA(row+1,A_OFFSET+bus) = 1;
		BB(row+1) = 0 - A0(bus);
	end
end

Agrid = [(JJ + UU*NN*YY)*PP -eye(2*n)];
Amat = [Agrid; AA];
Bmat = [zeros(2*n,1); BB];

x = Amat\Bmat;

approxVM = V0 + x(1:n);
approxVA = (A0 + x(n+1:2*n))/pi*180;

%%%%%%%%%%%%%%%%

subplot(211)
plot(1:n, results.bus(:,VM), 'ko', 1:n, approxVM, 'k*')
ylabel('magnitudes [p.u.]')
xlim([0 15])

subplot(212)
plot(1:n, results.bus(:,VA), 'ko', 1:n, approxVA, 'k*')
ylabel('angles [deg]')
xlim([0 15])


