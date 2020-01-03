function load_case = GetLoadCaseIEEE_13_NoRegs_Manual()
u_nom_v = 4160/sqrt(3);


bus_spec_array = [
    uot.BusSpec_Unbalanced('n630',[1,1,1],u_nom_v,'bus_type',uot.enum.BusType.Swing);
    uot.BusSpec_Unbalanced('l671',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('n680',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('l692',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('l675',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('n684',[1,0,1],u_nom_v);
    uot.BusSpec_Unbalanced('l611',[0,0,1],u_nom_v);
    uot.BusSpec_Unbalanced('l632',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('l645',[0,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('l646',[0,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('n633',[1,1,1],u_nom_v);
    uot.BusSpec_Unbalanced('l634',[1,1,1],277.1281);
    uot.BusSpec_Unbalanced('l652',[1,0,0],u_nom_v);
    ];

% Currently, line capacitance is not supported when creating the model
% manually. It is supported when importing from Gridlab
Z_601_ohm_per_mile = [
    0.3465+1.0179i	0.1560+0.5017i	0.1580+0.4236i;
    0.1560+0.5017i	0.3375+1.0478i	0.1535+0.3849i;
    0.1580+0.4236i	0.1535+0.3849i	0.3414+1.0348i;
    ];

Z_602_ohm_per_mile = [
    0.7526+1.1814i	0.1580+0.4236i	0.1560+0.5017i;
    0.1580+0.4236i	0.7475+1.1983i	0.1535+0.3849i;
    0.1560+0.5017i	0.1535+0.3849i	0.7436+1.2112i;
    ];

Z_603_ohm_per_mile = [
    1.3294+1.3471i	0.2066+0.4591i;
    0.2066+0.4591i	1.3238+1.3569i
    ];

Z_604_ohm_per_mile = [
    1.3238+1.3569i	0.2066+0.4591i;
    0.2066+0.4591i	1.3294+1.3471i;
    ];

Z_605_ohm_per_mile = 1.3292+1.3475i;

Z_606_ohm_per_mile = [
    0.7982+0.4463i	0.3192+0.0328i	0.2849-0.0143i;
    0.3192+0.0328i	0.7891+0.4041i	0.3192+0.0328i;
    0.2849-0.0143i	0.3192+0.0328i	0.7982+0.4463i;
    ];

Z_607_ohm_per_mile = 1.3425+0.5124i;

ft_per_mile = 5280;

Z_xfm1_ohm = (1.1e-2 + 1i*2e-2)*4160^2/500e3*eye(3);

Y_switch_siemens = (1 + 1i)/(1e-4)*eye(3);

link_spec_array = [
    uot.LinkSpec_Unbalanced('630-632',[1,1,1],'n630','l632',inv(2000/ft_per_mile*Z_601_ohm_per_mile));
    uot.LinkSpec_Unbalanced('632-633',[1,1,1],'l632','n633',inv(500/ft_per_mile*Z_602_ohm_per_mile));
    uot.LinkSpec_Unbalanced('XFM-1',[1,1,1],'n633','l634',inv(Z_xfm1_ohm));
    uot.LinkSpec_Unbalanced('632-645',[0,1,1],'l632','l645',inv(500/ft_per_mile*Z_603_ohm_per_mile));
    uot.LinkSpec_Unbalanced('645-646',[0,1,1],'l645','l646',inv(300/ft_per_mile*Z_603_ohm_per_mile));
    uot.LinkSpec_Unbalanced('632-671',[1,1,1],'l632','l671',inv(2000/ft_per_mile*Z_601_ohm_per_mile));
    uot.LinkSpec_Unbalanced('671-692',[1,1,1],'l671','l692',Y_switch_siemens);
    uot.LinkSpec_Unbalanced('692-675',[1,1,1],'l692','l675',inv(500/ft_per_mile*Z_606_ohm_per_mile));
    uot.LinkSpec_Unbalanced('671-680',[1,1,1],'l671','n680',inv(1000/ft_per_mile*Z_601_ohm_per_mile));
    uot.LinkSpec_Unbalanced('671-684',[1,0,1],'l671','n684',inv(300/ft_per_mile*Z_604_ohm_per_mile));
    uot.LinkSpec_Unbalanced('684-611',[0,0,1],'n684','l611',inv(300/ft_per_mile*Z_605_ohm_per_mile));
    uot.LinkSpec_Unbalanced('684-652',[1,0,0],'n684','l652',inv(800/ft_per_mile*Z_607_ohm_per_mile));
    ];

network_spec = uot.NetworkSpec(bus_spec_array,link_spec_array);

network = network_spec.Create();

l632_l671_dist_s_y_va = [17e3 + 1i*10e3, 66e3 + 1i*38e3, 117e3 + 1i*68e3];

% Loads from gridlab
load_zip_spec_array = [
    uot.LoadZipSpec('l634','s_y_va',[160e3 + 1i*110e3, 120e3 + 1i*90e3, 120e3 + 1i*90e3]);
    uot.LoadZipSpec('l645','s_y_va',[0, 170e3 + 1i*125e3, 0]);
    uot.LoadZipSpec('l646','y_d_va',[0, 230e3 + 1i*132e3,0]);
    uot.LoadZipSpec('l652','y_y_va',[128e3 + 1i*86e3, 0, 0]);
    uot.LoadZipSpec('l671','s_d_va',(385e3 + 1i*220e3)*ones(1,3));
    uot.LoadZipSpec('l675','s_y_va',[485e3 + 1i*190e3, 68e3 + 1i*60e3, 290e3 + 1i*212e3]);
    uot.LoadZipSpec('l692','i_d_va',[0, 0,170e3 + 1i*151e3]);
    uot.LoadZipSpec('l611','i_y_va',[0, 0,170e3 + 1i*80e3]);
    % Distributed load. To keep matters simple we just distribute the load
    % equally in both buses
    uot.LoadZipSpec('l632','s_y_va',l632_l671_dist_s_y_va/2);
    uot.LoadZipSpec('l671','s_y_va',l632_l671_dist_s_y_va/2);
    % Capacitors
    uot.LoadZipSpec('l675','y_y_va',-[1i*200e3, 1i*200e3, 1i*200e3]);
    uot.LoadZipSpec('l611','y_y_va',-[0,0, 1i*100e3]);
    ];

time_step_s = 1;
n_time_step = 1;

load_case_zip_spec = uot.LoadCaseZIPspec(load_zip_spec_array,time_step_s,n_time_step);

load_case = uot.LoadCaseZIP(load_case_zip_spec,network);
end