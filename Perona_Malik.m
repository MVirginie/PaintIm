function u_k =Perona_Malik(f, dt, K, a)
u_k = f;
[n,m]= size(u_k);
for t = 1:K
    u_km = u_k;
    fp = [flip(u_km,1);u_km;flip(u_km,1)];
    fn = [flip(fp,2), fp, flip(fp,2)];
    grad_x = gradx(fn); 
    grad_y = grady(fn);
    norm = sqrt(grad_x(n+1:2*n,m+1:2*m).^2+ grad_y(n+1:2*n,m+1:2*m).^2);
    u_k = u_km+ dt.*(div(g(norm, a).*gradx(u_km), g(norm, a).*grady(u_km)));
    imagesc(u_k);
     txt = ['Iteration n° ', num2str(t), '  dt = ', num2str(dt), ' a = ', num2str(a)];
    title(txt)
    colormap gray;
    drawnow
end