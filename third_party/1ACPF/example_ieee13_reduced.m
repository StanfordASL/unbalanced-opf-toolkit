function [v_linearized, t_linearized, p_linearized, q_linearized] = example_ieee13_reduced(do_plots)

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

%clear all
% close all
% clc

Vbase = 4160/sqrt(3);
Sbase = 5e6;
Zbase = Vbase^2/Sbase;

[Y,v,t,p,q,n] = ieee13();

v_testfeeder = [...
    1.0625  1.0500  1.0687  ;...
    1.0210  1.0420  1.0174  ;...
    1.0180  1.0401  1.0148  ;...
    0.9940  1.0218  0.9960  ;...
    NaN     1.0329  1.0155  ;...
    NaN     1.0311  1.0134  ;...
    0.9900  1.0529  0.9778  ;...
    0.9900  1.0529  0.9777  ;...
    0.9835  1.0553  0.9758  ;...
    0.9900  1.0529  0.9778  ;...
    0.9881  NaN     0.9758  ;...
    NaN     NaN     0.9738  ;...
    0.9825  NaN     NaN     ];

v_testfeeder = reshape(v_testfeeder.',3*n,1);

node_has_phase_stack  = isfinite(v_testfeeder);
n_bus_has_phase = sum(node_has_phase_stack);

t_testfeeder = [...
    0.00    -120.00 120.00  ;...
    -2.49   -121.72 117.83  ;...
    -2.56   -121.77 117.82  ;...
    -3.23   -122.22 117.34  ;...
    NaN     -121.90 117.86  ;...
    NaN     -121.98 117.90  ;...
    -5.30   -122.34 116.02  ;...
    -5.31   -122.34 116.02  ;...
    -5.56   -122.52 116.03  ;...
    -5.30   -122.34 116.02  ;...
    -5.32   NaN     115.92  ;...
    NaN     NaN     115.78  ;...
    -5.25   NaN     NaN     ];

t_testfeeder = reshape(t_testfeeder.',3*n,1)/180*pi;

%%

% Linearized model

e0 = [1;zeros(n-1,1)];
a = exp(-1j*2*pi/3);
aaa = [1; a; a^2];

VTV = [kron(e0',eye(3)), zeros(3, n_bus_has_phase), zeros(3, n_bus_has_phase), zeros(3, n_bus_has_phase)];
VTT = [zeros(3, n_bus_has_phase), kron(e0',eye(3)), zeros(3, n_bus_has_phase), zeros(3, n_bus_has_phase)];
PQP = [zeros(3*(n-1),n_bus_has_phase), zeros(3*(n-1),n_bus_has_phase), zeros(3*(n-1),3), eye(n_bus_has_phase - 3), zeros(3*(n-1),n_bus_has_phase)];
PQQ = [zeros(3*(n-1),n_bus_has_phase), zeros(3*(n-1),n_bus_has_phase), zeros(n_bus_has_phase - 3,n_bus_has_phase), zeros(3*(n-1),3), eye(3*(n-1))];

UUU = bracket(kron(eye(n),diag(aaa)));
NNN = Nmatrix(6*n);
LLL = bracket(Y);
PPP = Rmatrix(ones(3*n,1), kron(ones(n,1),angle(aaa)));

% equivalent, when linearizing around the no load solution
RRR = bracket(kron(eye(n),diag(aaa)));
Amat = [NNN*inv(RRR)*LLL*RRR eye(6*n); VTV; VTT; PQP; PQQ];
Bmat = [zeros(3*n,1); zeros(3*n,1); v(rw(1)); t(rw(1)); p(rw(2:n)); q(rw(2:n))];

x = Amat\Bmat;

v_linearized = x(1:3*n);
t_linearized = x(3*n+1:2*3*n);

v_linearized(isnan(v_testfeeder))=NaN;
v_linearized_nl(isnan(v_testfeeder))=NaN;
t_linearized(isnan(t_testfeeder))=NaN;

%Start AE
p_linearized = x(2*3*n+1:3*3*n);
q_linearized = x(3*3*n+1:4*3*n);



%End AE
if do_plots
    % print

    for bus = 1:n

        fprintf('--- bus %i\t|  ', bus);
        vbus = v_linearized((bus-1)*3+1:(bus-1)*3+3);
        tbus = t_linearized((bus-1)*3+1:(bus-1)*3+3);
        fprintf(1, '%f at %+f  |  ', [vbus(1) tbus(1)/pi*180]);
        fprintf(1, '%f at %+f  |  ', [vbus(2) tbus(2)/pi*180]);
        fprintf(1, '%f at %f\n', [vbus(3) tbus(3)/pi*180]);

    end

    %% comparison

    figure(1)

    phnames = ['a' 'b' 'c'];
    for ph=1:3

        subplot(3,2,(ph-1)*2+1)
        plot(1:13, v_testfeeder(rw(1:n,ph)), 'ko', 1:13, v_linearized(rw(1:n,ph)), 'k*');
        xlim([0 14])
        set(gca,'XTick',[1 13])

        ylabel(sprintf('phase %c',phnames(ph)), 'FontWeight','bold')

        if ph==1
            title('magnitudes {v_i} [pu]')
        end

        subplot(3,2,(ph-1)*2+2)
        plot(1:13, t_testfeeder(rw(1:n,ph))/pi*180, 'ko', 1:13, t_linearized(rw(1:n,ph))/pi*180, 'k*')
        xlim([0 14])
        set(gca,'XTick',[1 13])

        if ph==1
            title('angles \theta_i [deg]')
        end

    end
end

end
