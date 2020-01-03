function res = IsSquareMatrix(M)
res = ismatrix(M) && (size(M, 1) == size(M, 2));
end