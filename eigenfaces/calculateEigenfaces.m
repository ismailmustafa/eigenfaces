% returns weights of face space and eigenfaces ordered by largest
% eigenvalue
function [weights, eigenfacesOrdered, meanImage, images, M] = calculateEigenfaces(allFiles, k, N)
    M = length(allFiles); % number of faces
    % Covert all images to grayscale
    images.name = cell(1,M);
    images.data = cell(1,M);
    for i = 1:numel(allFiles)
        filePath = allFiles{i};
        [path,name,ext] = fileparts(filePath);
        imagePath = [path, '/', strcat(name,ext)];
        extModified = strrep(ext, '.', '');
        img = imread(imagePath, extModified);
        img = rgb2gray(img);
        img = imresize(img,N,N);
        img = double(img)/255.0;
        images.name{i} = name;
        images.data{i} = img;
    end

    % convert image data to vector to graph
    imageData = arrangeImageData(images.data);

    % display grayscale image before image averaging
    %figure(1), imshow(imageData,'Initialmagnification','fit');

    %close all;

    % calculate average face
    sumImage = zeros(N);
    for i = 1:M
        %images.data{i} = double(images.data{i})/255.0;
        sumImage = sumImage + images.data{i};
    end
    meanImage = sumImage/M;

    % display mean image
    %figure(2), imshow(meanImage,'Initialmagnification','fit');

    %close all;

    % Subtract mean face
    for i = 1:M
        images.dataMean{i} = images.data{i} - meanImage;
    end

    imageDataMean = arrangeImageData(images.dataMean);
    %figure(3), imshow(imageDataMean,'Initialmagnification','fit');

    %close all;

    % Generate matrix A (covert dataMean into NxN vectors)
    A = zeros(N*N,M);
    for i = 1:M
        A(:,i) = images.dataMean{i}(:);
    end

    % Calculate covariance matrix (A^T * A, MxM)
    C = transpose(A)*A;

    % Calculate right eigenvectors and values
    [V,D] = eig(C);

    % Compute M best eigenvectors
    Mbest = A*V;
    size(Mbest);
    Mbest;

    % covert back into NxN eigenfaces
    for i = 1:M
        column = Mbest(:,i);
        eigenface = reshape(column, N,N);
        images.eigenface{i} = eigenface;
    end

    % plot eigenfaces
    eigenfacesData = arrangeImageData(images.eigenface);
    %figure(4), imshow(eigenfacesData,'Initialmagnification','fit');

    %close all;

    % keep only 5 largest eigenvectors
    eigenvalues = diag(D);
    [B,I] = sort(eigenvalues,'descend');

    % put eigenfaces in order of largest eigen value
    eigenfacesOrdered = cell(1,M);
    for i = 1:M
        eigenfacesOrdered{i} = images.eigenface{I(i)};
    end

    % plot eigenfaces in order of largest eigenvalue
    eigenfacesToDisplay = arrangeImageData(eigenfacesOrdered);
    %figure(5), imshow(eigenfacesToDisplay,'Initialmagnification','fit');
    %close all

    % use k best to calculate weights (use I for order)
    for i = 1:M
        for j = 1:k
            weights(i,j) = sum(transpose(eigenfacesOrdered{j}(:)) * A(:,i));
        end
    end
end

