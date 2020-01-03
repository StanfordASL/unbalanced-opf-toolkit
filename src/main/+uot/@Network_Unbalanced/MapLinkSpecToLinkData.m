function link_data = MapLinkSpecToLinkData(obj,link_spec,from_i,to_i,bus_spec_from,bus_spec_to,s_base_va)
% Note: this method is meant to be called from the constructor. Hence,
% it should not access non-constant properties and non-static methods of obj.

% In the case of unbalanced links, phase_from and phase_to are the same
switch class(link_spec)
    case 'uot.LinkSpec_Unbalanced'
        phase_from = link_spec.phase;
        phase_to = link_spec.phase;
    otherwise
        error('Error in %s: Invalid link_spec class %s.',link_spec.name,class(link_spec));
end

u_nom_from_v = bus_spec_from.u_nom_v;
u_nom_to_v = bus_spec_to.u_nom_v;
link_data = uot.LinkData(link_spec,from_i,to_i,phase_from,phase_to,u_nom_from_v,u_nom_to_v,s_base_va);
end