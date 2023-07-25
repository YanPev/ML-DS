function filteredTable = filterRowsByNaN(inputTable,NaNnumber)
    % Count the number of NaN values in each row
    nanCount = sum(isnan(inputTable{:,:}), 2);
    
    % Find rows with less than or equal to NaNnumber NaN values
    validRows = nanCount <= NaNnumber;
    
    % Filter the table based on the valid rows
    filteredTable = inputTable(validRows, :);
end
