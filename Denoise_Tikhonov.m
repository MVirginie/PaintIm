function u_k = Denoise_Tikhonov(f,K, l)
t = 1/(l+4);
[~,~, c] = size(f);
if c == 3
    f = double(rgb2gray(f));
end
u_k = f;
for i = 1:K
    u_km = u_k;
    u_k = u_km+t*(l.*(f-u_km)+div(gradx(u_km), grady(u_km)));
    imagesc(u_k);
    txt = ['Iteration n° ', num2str(i), '  lambda =  ', num2str(l)];
    title(txt)
    colormap gray;
    drawnow
end