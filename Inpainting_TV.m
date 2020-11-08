function u_k=  Inpainting_TV(f, M, t,e, K, l)
[~,~,c] = size(f);
if c==3
    f= rgb2ycbcr(f);
end
u_k = f;
for i = 1:K
    for j = 1:c
        u_km(:,:,j) = u_k(:,:,j);
        norm = sqrt(gradx(u_km(:,:,j)).^2+grady(u_km(:,:,j)).^2);
        gradJD = l.*(f(:,:,j)-u_km(:,:,j)).*M;
        gradJPM = div(gradx(u_km(:,:,j))./sqrt(norm.^2+e^2), grady(u_km(:,:,j))./sqrt(norm.^2+e^2));
        u_k(:,:,j) = u_km(:,:,j)+t.*(gradJD+gradJPM);
 
      %  u_k(:,:,j) = u_km(:,:,j)+t.*(l.*(f(:,:,j)-u_km(:,:,j)).*M+div(gradx(u_km(:,:,j))./sqrt(norm.^2+e^2), grady(u_km(:,:,j))./sqrt(norm.^2+e^2)));
    end
    if c == 3
        imagesc(im2double(ycbcr2rgb(u_k)))
    else 
        imagesc(u_k)
    end
    txt = ['Iteration n° ', num2str(i), '  lambda =  ', num2str(l), ' t=', num2str(t)];
    title(txt)
    colormap gray;
    drawnow
end
