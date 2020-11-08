function u = heat_equation(f, delta_t, k, ~)
u = f;
[n,m]= size(u);
for t = 1:k
    fp = [flip(u,1);u;flip(u,1)];
    fn = [flip(fp,2), fp, flip(fp,2)];
    grad_x = gradx(fn);
    grad_y = grady(fn);
    u = u+delta_t.*div(grad_x(n+1:2*n,m+1:2*m), grad_y(n+1:2*n,m+1:2*m));
    txt = ['Iteration n° ', num2str(t), '  dt = ', num2str(delta_t)];
    imagesc(u);
    title(txt)
    colormap gray;    
    drawnow
    
end