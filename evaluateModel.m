function evaluateModel(test_data, test_labels, trained_model)
    % Make predictions using the trained model
    predicted_labels = trained_model.predictFcn(test_data);

    % Calculate the confusion matrix
    confusion_mat = confusionmat(table2array(test_labels), predicted_labels);

    % Display the confusion chart
    figure;
    % Define your custom labels
    custom_labels = {'Non-Septic', 'Septic'};

    % Display the confusion matrix with custom labels
    confusionchart(confusion_mat, custom_labels);
    title('Confusion Chart');

    % Calculate True Positives (TP), False Positives (FP), and False Negatives (FN)
    TP = confusion_mat(2, 2);
    FP = confusion_mat(1, 2);
    FN = confusion_mat(2, 1);

    % Calculate Precision, Recall, and F1 Score
    precision = TP / (TP + FP);
    recall = TP / (TP + FN);

    % Display the F1 score
    fprintf('Precision: %.4f\n', precision);
    fprintf('Recall: %.4f\n', recall);
end
