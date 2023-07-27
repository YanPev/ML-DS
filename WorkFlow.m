% Getting to know the data in general

% Load data set that pass mice algorithm
data = readtable('imputed_data.csv');
clearData_unique = filterDuplicates(data, 'Patient_ID');

% Original Septic and Nonseptic for Training
[newDataSetOriginal,PatientsIDSeptic, PatientsIDNonSeptic] = OriginalPatients('Dataset.csv');
% We have 124 records for Test --> 496 Train and Val

% Remove the records for Test
% Identify the indices of test records to remove
testIndices = ismember(clearData_unique.Patient_ID, [PatientsIDSeptic; PatientsIDNonSeptic]);
% Remove the test records
clearData_unique(testIndices, :) = [];

% Extract the cleared rows with the wanted features
newDataSet = clearData_unique(:, {'Temp', ...
    'HR', 'O2Sat', 'SBP', 'MAP', 'DBP', 'Resp', 'Platelets', ...
    'PTT', 'PaCO2', 'Age','SepsisLabel'});

% Extract the data features from the table
data2 = table2array(newDataSet(:,1:11));

% Calculate the mean and standard deviation for each column
meanVals = mean(data2);
stdVals = std(data2);
% Z-score normalization
zScoreData = round((data2 - meanVals) ./ stdVals,4);

% Create a new table with z-scored data
zScoreData = [zScoreData,table2array(newDataSet(:,12))];
zScoredTable = array2table(zScoreData, 'VariableNames', newDataSet.Properties.VariableNames);
writetable(zScoredTable,'zScoredTableMice.csv');

% Sort the data using labels
[~, sortedIndex] = sort(newDataSet{:, end});
sortedTable = data2(sortedIndex, :);
numNonSeptic = sum(newDataSet.SepsisLabel == 0);
trainData = [newDataSet(1:496,:); newDataSet(numNonSeptic+1:numNonSeptic+496,:)];

% Prepare the Test Data - Original
[~, sortedIndex] = sort(newDataSetOriginal{:, end});
sortedTableOriginal = newDataSetOriginal(sortedIndex, :);
testData = [sortedTableOriginal(1:124,:); sortedTableOriginal(4194+1:end,:)];

% Extract the data features from the table
data3 = table2array(testData(:,1:11));

% Calculate the mean and standard deviation for each column
meanVals = mean(data3);
stdVals = std(data3);

% Z-score normalization
zScoreDataOriginal = round((data3 - meanVals) ./ stdVals,4);

% Create a new table with z-scored data
zScoreDataOriginal = [zScoreDataOriginal,table2array(testData(:,13))];
names = trainData.Properties.VariableNames;
zScoredTableOriginal = array2table(zScoreDataOriginal, 'VariableNames', names);

writetable(zScoredTableOriginal,'zScoredTable.csv');

[coeff, score, ~, ~, explained, ~] = pca(table2array(zScoredTableOriginal(:,1:11)));

% Plot PCA bar plot
figure;
bar(explained, 'b');
xlabel('Principal Component');
ylabel('Variance Explained (%)');
title('PCA: Variance Explained');

% Step 3: Determine feature importance (based on magnitude of coefficients)
feature_importance = sum(abs(coeff), 2);

% Step 4: Select the top 'k' features
k = 9; % Replace '3' with the desired number of top features
[sorted_importance, feature_indices] = sort(feature_importance, 'descend');
selected_features = newDataSet(:, feature_indices(1:k));

% Step 3: Determine feature importance for the first three PCs
num_pcs = 5; % Set the number of first PCs for which you want feature importance
feature_importance_first_pcs = sum(abs(coeff(:, 1:num_pcs)), 2);
% Display or use feature_importance_first_pcs for further analysis
disp(feature_importance_first_pcs);

% Invasive without PTT and DBP
forModel_Invasive_Train = trainData(:,{'Temp', ...
    'HR', 'O2Sat', 'SBP', 'MAP', 'Resp', 'Platelets', ...
    'PTT', 'Age','SepsisLabel'});
forModel_Invasive_Test = testData(:,{'Temp', ...
    'HR', 'O2Sat', 'SBP', 'MAP', 'Resp', 'Platelets', ...
    'PTT', 'Age','SepsisLabel'});

% Model Evaluation - SVM (gaussian kernel)
load SVM.mat
evaluateModel(forModel_Invasive_Test(:,1:9), forModel_Invasive_Test(:,10), SVM);

% Model Evaluation - Fine Tree
load FineTree.mat
evaluateModel(forModel_Invasive_Test(:,1:9), forModel_Invasive_Test(:,10), FineTree);
