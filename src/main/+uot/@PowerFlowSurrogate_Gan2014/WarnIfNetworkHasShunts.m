function WarnIfNetworkHasShunts(network)
    % Function is static
    %
    % Shows a warning if network has shunts
    if network.has_shunts
        warning('Buses have non-negligible shunts. Results may be inaccurate.');
    end
end