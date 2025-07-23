function A_inv = inv_cholesky(A)
    L = chol(A, 'lower');
    L_inv = inv(L);
    A_inv = L_inv' * L_inv;
end