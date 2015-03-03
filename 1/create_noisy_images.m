for i=[0 1]
    filename = ['Shapes', num2str(i)];

    img = im2bw(imread(['Input/', filename, '.png']));
    noise = rand(size(img)) < 0.1;

    % Flip color at noisy positions
    img(noise) = ~img(noise);
    imwrite(img, ['Input/', filename, '_noisy.png'])
end

