function averageNorm = isFaceTest(img, eigenfacesOrdered, weights, images, meanImage, k, M, N)
    img = imresize(img, N, N);
    img = img - meanImage;
    img = img(:);

    for i=1:k
      imgWeights(i)  = sum(transpose(eigenfacesOrdered{i}(:)) * img);
    end
    
    averageNorm = 0;
    for i=1:M
        diff = imgWeights(1,:) - weights(i,:);
        euc = norm(diff);
        averageNorm = averageNorm + euc;
    end
    averageNorm = averageNorm/M;

end

