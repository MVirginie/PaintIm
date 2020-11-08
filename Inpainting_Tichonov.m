function u_k=  Inpainting_Tichonov(f, M, t, K, l) 
[~,~,c] = size(f);
if c ==3
    f= im2double(rgb2ycbcr(f));
end
u_k = f;
for i = 1:K
    for j =1:c
        u_km(:,:,j) = u_k(:,:,j);
        gradJD = l.*(f(:,:,j)-u_km(:,:,j)).*M;
        gradJH= div(gradx(u_km(:,:,j)), grady(u_km(:,:,j)));
        u_k(:,:,j) = u_km(:,:,j)+t.*(gradJD+gradJH);

        %u_k(:,:,j) = u_km(:,:,j)+t.*(l.*(f(:,:,j)-u_km(:,:,j)).*M+div(gradx(u_km(:,:,j)), grady(u_km(:,:,j))));
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
