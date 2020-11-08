function u_k = Denoise_g1(f,t,K,l,e)
[~,~,c] = size(f);
if c == 3
    f = double(rgb2gray(f));
end
u_k = f;
for i = 1:K 
    u_km = u_k;
    norm2 = gradx(u_km).^2+grady(u_km).^2;
    gradphi1 = 2.*div(gradx(u_km)./((1+norm2).^2), grady(u_km)./((1+norm2).^2));
    u_k = u_km+t.*(l.*(f-u_km)+gradphi1);
    
    %u_k = u_km+t.*(l.*(f-u_km)+2.*div(gradx(u_km)./((1+norm2).^2), grady(u_km)./((1+norm2).^2)));
    imagesc(u_k);
    txt = ['Iteration n° ', num2str(i), '  lambda =  ', num2str(l), ' e = ', num2str(e), ' t = ', num2str(t)];
    title(txt);
    colormap gray;
    drawnow
end
