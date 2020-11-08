function u_k = Denoise_TV(f,t,K,l,e)
[~,~,c] = size(f);
if c == 3
    f = double(rgb2gray(f));
end
u_k = f;
for i = 1:K 
    u_km = u_k;
    norm = sqrt(gradx(u_km).^2+grady(u_km).^2);
    gradJPM =div(gradx(u_km)./sqrt(norm.^2+e), grady(u_km)./sqrt(norm.^2+e));
    u_k = u_km+t*(l*(f-u_km)+gradJPM);
    %u_k = u_km+t*(l*(f-u_km)+div(gradx(u_km)./sqrt(norm.^2+e), grady(u_km)./sqrt(norm.^2+e)));
    imagesc(u_k);
    txt = ['Iteration n° ', num2str(i), '  lambda =  ', num2str(l), ' e = ', num2str(e), ' t = ', num2str(t)];
    title(txt);
    colormap gray;
    drawnow
end
