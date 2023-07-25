function filteredTable = filterRowsByNaNInColumn(inputTable, columnName)
    % Get the column index based on the column name
    columnIndex = find(strcmp(inputTable.Properties.VariableNames, columnName));
    
    % Find rows with non-NaN values in the specified column
    validRows = ~isnan(inputTable{:,columnIndex});
    
    % Filter the table based on the valid rows
    filteredTable = inputTable(validRows, :);
end
