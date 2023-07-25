function filteredTable = filterColumnsByNaN(inputTable,NaNnumber)
    % Count the number of NaN values in each column
    nanCount = sum(isnan(inputTable{:,:}), 1);
    
    % Find columns with less than or equal to 7 NaN values
    validColumns = nanCount <= NaNnumber;
    
    % Filter the table based on the valid columns
    filteredTable = inputTable(:, validColumns);
end
