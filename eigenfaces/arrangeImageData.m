% Covert cell array to vector optimized for graphing
function imageData = arrangeImageData(cellArray)

    [N,~] = size(cellArray{1});
    [~,M] = size(cellArray);
    
    x = floor(sqrt(M));
    if abs((M/x) - floor(M/x)) < 0.0001
        y = floor(M/x);
    else
        y = floor(M/x) + 1;
    end
    
    imageData = [];
    index = 1;
    for i = 1:x
        row = [];
        for j = 1:y
            if index > M
                row = [row ones(N)];
            else
                row = [row cellArray{index}];
                index = index + 1;
            end
        end
        imageData = [imageData ; row];
    end
end

