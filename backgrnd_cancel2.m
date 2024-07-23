function [avg, data, data_an, fn, tm] = backgrnd_cancel2(file_name, dir_name)
    % Construct the full file path
    full_path = fullfile(dir_name, file_name);

    % Check if the file exists
    if ~exist(full_path, 'file')
        error('File not found: %s', full_path);
    end

    % Read data from the FITS file
    data = fitsread(full_path);
    [fn, tm] = size(data);

    % Calculate the average background along each row
    avg = min(data, [], 2);

    % Subtract the average background from the data using vectorized operations
    datamin = data - avg;

    % Calculate standard deviation along each column
    data2 = std(datamin);

    % Calculate the mean of the standard deviations
    c = mean(data2);

    % Find columns where the standard deviation is less than c
    valid_columns = data2 < c;

    % Calculate the sum of valid columns
    data_n_sum = sum(datamin(:, valid_columns), 2);

    % Count the number of valid columns
    count = sum(valid_columns);

    % Calculate the background as the average of valid columns
    data_n = ceil(data_n_sum / count);

    % Expand data_n to match the size of the original data
    data_bg = repmat(data_n, 1, tm);

    % Subtract the background from the original data
    data_an = datamin - data_bg;




end

