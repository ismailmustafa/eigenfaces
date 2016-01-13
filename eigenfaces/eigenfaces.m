% Image classification using eigen faces from "labeled faces in the wild"
% dataset

N = 50; % image dimension
k = 4; % selected eigenvectors

% false = face detection algorithm
% true = face recognition algorithm
TEST_RECOGNITION = false;

if ~TEST_RECOGNITION
    % get all images in directory
    facesDir = strcat(pwd,'/eigenfaces/faces');
    allFiles = getAllFiles(facesDir);
    allFiles = allFiles(2:length(allFiles)); % get rid of erroneous images

    % calculate weights and eigenfaces for all files
    [weights, eigenfacesOrdered, meanImage, images, M] = ...
        calculateEigenfaces(allFiles, k, N);

      % Calculate threshold to determine if face is an image
      averageOfAverageNorm = 0;
      for i = 1:36
        filePath = ['faces/face', num2str(i), '.jpg'];
        averageNorm = isFace(filePath, ...
                             eigenfacesOrdered, ... 
                             weights, ...
                             images, ...
                             meanImage, ...
                             k, ...
                             M, ...
                             N);                                  
        averageOfAverageNorm = averageOfAverageNorm + averageNorm;
      end
      threshold = (averageOfAverageNorm/36)*0.74;
  
  detectFaces('group/test2.jpg', threshold, eigenfacesOrdered, weights, images, meanImage, k, M, N);
else
    % get all images in directory
    facesDir = strcat(pwd,'/eigenfaces/lfwFaces');
    allFiles = getAllFiles(facesDir);
    allFiles = allFiles(2:length(allFiles)); % get rid of erroneous images

    % calculate weights and eigenfaces for all files
    [weights, eigenfacesOrdered, meanImage, images, M] = ...
        calculateEigenfaces(allFiles, k, N);
    
    %Detect "Jack Straw" with new image
    [sortedEuc, eucIndexOrder, orderedNames, solution] = detectMatch('/lfwTestFaces/Jack_Straw_0003.ppm', ...
                                           eigenfacesOrdered, ... 
                                           weights, ...
                                           images, ...
                                           meanImage, ...
                                           k, ...
                                           M, ...
                                           N);
    solution
end
  
  
  
 
