function u_k= deconvolution_TV(f, G, t, e, K, l)
u_k = f;
for i = 1:K
    u_km = u_k;
    norm = sqrt(gradx(u_km).^2+grady(u_km).^2);
    gradJPM = div(gradx(u_km)./sqrt(norm.^2+e^2), grady(u_km)./sqrt(norm.^2+e^2));
    u_k = u_km+t.*(imfilter(f-imfilter(u_km,G, 'replicate', 'conv'),l.*G,'replicate', 'conv')+gradJPM);
    
    %u_k = u_km+t.*(imfilter(f-imfilter(u_km,G, 'replicate', 'conv'),l.*G,'replicate', 'conv')+div(gradx(u_km)./sqrt(norm.^2+e^2), grady(u_km)./sqrt(norm.^2+e^2)));
    imagesc(u_k)
    txt = ['Iteration n° ', num2str(i), '  lambda =  ', num2str(l), ' t = ', num2str(t), ' e = ', num2str(e)];
    title(txt)
    colormap gray;
    drawnow
end