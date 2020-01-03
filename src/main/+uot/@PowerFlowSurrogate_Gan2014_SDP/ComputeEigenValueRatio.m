% Computes the ratio abs(labmda_2)/abs(lambda_1) of M. This ratio is useful
% to evaluate solution exactness. See page 6 in Gan2014
function m_eigenvalue_ratio = ComputeEigenValueRatio(obj,link,i_time_step)
    M_link_val = value(obj.GetMlink(link,i_time_step));

    M_lambda = sort(eig(M_link_val),'descend');

    m_eigenvalue_ratio = abs(M_lambda(2))/abs(M_lambda(1));
end