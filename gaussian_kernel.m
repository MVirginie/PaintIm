function G_sigma = gaussian_kernel(P, dt, K)
    sigma = 2*K*dt;
    x = 1:P;
    X = repmat(x,P, 1);
    coeff = 1/(2*pi*sigma^2);
    G_sigma = coeff.*exp(-abs(X.^2-transpose(X).^2)./(2*sigma^2));
    
