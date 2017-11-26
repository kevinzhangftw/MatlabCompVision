clear all;
close all;

f=dir('s1/*.pgm');
files={f.name};
alls=dir('s*');
folders={alls.name};

trainData = [];
testData = [];
for i=1:numel(folders)
  for j=1:numel(files)      
    filename = fullfile(char(folders(i)), char(files(j)));
    if j<6 %     test train data split as specified by paper
            trainData = cat(3,trainData,imread(filename)); %adapted from https://www.mathworks.com/help/matlab/ref/cat.html
    else 
            testData = cat(3,testData,imread(filename));
    end
  end
end

trainFourier = [];
testFourier = [];
for thisTestImg = 1:200
    X_test = testData(:, :, thisTestImg);
    X_test = padarray(X_test, [8, 18], 'replicate', 'both');
    fourier_test = fft2(double(X_test));
    shifted_test = fftshift(fourier_test);
    lowQuadTest = shifted_test(65:128,65:128);
    Test_v = lowQuadTest(:);
    testFourier = cat(3, testFourier, Test_v);
end

for eachTrainImg = 1:200
    X_train = trainData(:, :, eachTrainImg);
    X_train = padarray(X_train, [8, 18], 'replicate', 'both');
    fourier = fft2(double(X_train));
    shifted = fftshift(fourier);
    lowQuadTrain = shifted(65:128,65:128);
    Train_v = lowQuadTrain(:);
    trainFourier = cat(3, trainFourier, Train_v);
end

accuracy = 0;
for eachTrainImg = 1:200
    min_distance = 2^32;
    best_match = 0;
    Train_v = trainFourier(:,:,eachTrainImg);    
    for thisTestImg = 1:200
        Test_v = testFourier(:,:,thisTestImg);
        euclidean_d = norm(Train_v - Test_v);
        if min_distance > euclidean_d
            min_distance = euclidean_d;
            best_match = thisTestImg;
        end
    end
    
    trainsetIndices = floor((eachTrainImg-1) / 5);
    bestmatchFoundIndices = floor((best_match-1) / 5);
    
    if trainsetIndices == bestmatchFoundIndices
        accuracy = accuracy + 1;
    end
end

accuracy = accuracy/200*100;
disp("Accuracy: " + accuracy);
