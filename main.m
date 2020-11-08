%% Example 1 : Reading and displaying an image 

im_to_load = double(imread('cameraman.tif'));
im_noised = add_gaussian_noise(im_to_load, 30);
%Denoising with PDES
K = 50;
e = 1;
%% Tikhonov regularization 
l = 0.001;
Denoise_Tikhonov(im_noised, K, l);
l = 0.01;
Denoise_Tikhonov(im_noised, K, l);
l = 0.1;
Denoise_Tikhonov(im_noised, K, l);
l = 0.5;
im_regularized =Denoise_Tikhonov(im_noised, K, l);
%%
im_to_load2 = double(imread('lena.jpg'));
im_noised2 = add_gaussian_noise(im_to_load2, 30);
K = 100;
l = 0.95;
Denoise_Tikhonov(im_noised2, K, l);
l = 0.1;
Denoise_Tikhonov(im_noised2, K, l);
l = 0.001;
Denoise_Tikhonov(im_noised2, K, l);
%% Denoise_TV
l = 0.01;
t = 1/(l+4);
K = 100;
im_denoised = Denoise_TV(im_noised, t, K, l, e);
l = 0.001;
t = 1/(l+4);
K = 300;
im_denoised = Denoise_TV(im_noised, t, K, l, e);
l = 0.1;
t = 1/(l+4);
K = 100;
im_denoised = Denoise_TV(im_noised, t, K, l, e);
%% Fourier
fu = relation14(im_noised,0.1);
min= ifft2(fu);
imagesc(real(min))
colormap gray;
%%
fu = relation14(im_noised,0.01);
min= ifft2(fu);
imagesc(real(min))
colormap gray;
%%
fu = fourier(im_noised,0.001);
min= ifft2(fu);
imagesc(real(min))
colormap gray;
%% Deconvolution
G = fspecial('gaussian', [7 7], 5);
im = imfilter(im_to_load,G, 'replicate', 'conv');
e = 1;
t =  1/(l+4);
K = 100;
l = 0.1;
new_noisy_im = add_gaussian_noise(im, 30);
im = deconvolution_TV(im_noised,G, t,e, K, l);
%% Inpainting
K =10000; 
t= 0.05;
l = 0.05;
M = double(imread('Im1_mask.png'));
im1 = double(imread('Im1.png'));
res = Inpainting_Tichonov(im1, M, t, K, l);
K