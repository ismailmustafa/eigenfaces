function [sortedEuc, eucIndexOrder, orderedNames, solution] = detectMatch(filePath, eigenfacesOrdered, weights, images, meanImage, k, M, N)
    img = imread(filePath, 'ppm');
    img = rgb2gray(img);
    img = imresize(img, N, N);
    img = double(img)/255.0;
    img = img - meanImage;
    
    
    img = img(:);

    for i=1:k
      imgWeights(i)  = sum(transpose(eigenfacesOrdered{i}(:)) * img);
    end

    euc = zeros(M,1);
    for i=1:M
        diff = imgWeights(1,:) - weights(i,:);
        euc(i,:) = norm(diff);
        weights(i,:);
    end

    [sortedEuc,eucIndexOrder] = sort(euc,'ascend');
    orderedNames = cell(1,M);
    % sort names in order
    for i = 1:M
        splitName = strsplit(images.name{eucIndexOrder(i)},'_');
        name = [splitName{1}, ' ', splitName{2}];
        orderedNames{i} = name;
    end
    splitAnswer = strsplit(images.name{eucIndexOrder(1)},'_');
    solution = [splitAnswer{1}, ' ', splitAnswer{2}];
end

