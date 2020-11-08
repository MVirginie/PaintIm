function res =  fourier(u, l)
[~,~,c] = size(u);
if c == 3
  u = double(rgb2gray(u));
end
fourier = ifftshift(fftshift(fft2(u)));
[n,m] = size(u); 
x = 1:m;
p = repmat(x,n, 1);
y = 1:n;
q = repmat(y,m,1)';
res = (l.*fourier)./(l+4.*(sin((pi.*p)./m).^2+sin((pi.*q)./n).^2));