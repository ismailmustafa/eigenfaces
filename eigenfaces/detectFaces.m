function detectFaces(filepath, threshold, eigenfacesOrdered, weights, images, meanImage, k, M, N)

  img = imread(filepath, 'jpg');
  img = double(img)/255.0;
  img = rgb2gray(img);
  [height, width] = size(img);
  
  
  scale = 1.3*N;
  widthLimit = width-scale;
  heightLimit = height-scale;
 
  allFaces = [];
  for i = 1:heightLimit
      for j = 1:20:widthLimit
          c = img(i:i+scale-1,j:j+scale-1);
          averageNorm = isFaceTest(c, ...
                         eigenfacesOrdered, ... 
                         weights, ...
                         images, ...
                         meanImage, ...
                         k, ...
                         M, ...
                         N);
         if averageNorm < threshold
             disp('face found');
             foundFace.y = i;
             foundFace.x = j;
             foundFace.width = scale;
             foundFace.height = scale;
             allFaces = [allFaces ; foundFace];
             break
         end
      end
      disp(i);
  end
  
  figure(24), imshow(img,'Initialmagnification','fit'); title('before')
  hold on
  
  [sizeAllFaces, ~] = size(allFaces)
  for i = 1:sizeAllFaces  
    foundFace = allFaces(i);
    rectangle('Position', [foundFace.x foundFace.y foundFace.width foundFace.height], 'EdgeColor', 'r', 'LineWidth', 3);
  end

end

