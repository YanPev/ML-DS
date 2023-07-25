function filteredTable = filterDuplicates(table, columnName)
    [~, idx, ~] = unique(table.(columnName), 'last');
    filteredTable = table(idx, :);
end
