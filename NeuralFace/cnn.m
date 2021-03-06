close all;
clear all;

faceDatasetPath = fullfile('ATT_Face_Database');
faceData = imageDatastore(faceDatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
% figure;
% for i = 1:20
%     subplot(4,5,i);
%     imshow(faceData.Files{i});
% end
CountLabel = faceData.countEachLabel;

% img = readimage(faceData,1);
% size(img)

trainingNumFiles = 5;
rng(1) % For reproducibility
[trainFaceData,testFaceData] = splitEachLabel(faceData, ...
				trainingNumFiles,'randomize');
            
layers = [imageInputLayer([112 92 1])
          convolution2dLayer(5,20)
          reluLayer
          maxPooling2dLayer(2,'Stride',2)
          fullyConnectedLayer(40)
          softmaxLayer
          classificationLayer()];

options = trainingOptions('sgdm','MaxEpochs',45, ...
	'InitialLearnRate',0.0001);

convnet = trainNetwork(trainFaceData,layers,options);
YTest = classify(convnet,testFaceData);
TTest = testFaceData.Labels;
accuracy = sum(YTest == TTest)/numel(TTest);