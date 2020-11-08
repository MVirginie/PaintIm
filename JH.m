function u_k = JH(f,K,t)
u_k = f;
for i = 1:K
    u_km = u_k;
    u_k = u_km+t*(div(gradx(u_km), grady(u_km)));
    imagesc(u_k);
    txt = ['Iteration n° ', num2str(i)];
    title(txt)
    colormap gray;
    drawnow
end