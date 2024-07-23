
clc


%programming is designed by Nur Zulaikha Mohd Afandi et al., #
dir_name='C:\Users\\'; 
s=strcat(dir_name,'*.fit');

file=dir(s); 



for i=1:length(file)         
file_name=file(i).name;
disp(['Filename: ' file_name]);
    


%----CHECK PROSES ATAU BELUM----------------
% oldfile=file_name;xxxxxzb  bnbgcx
%    
%     
%     num = [];
%     ada = 0;-
%    % X = sprintf('Checked %s ',oldfile);


%    % disp(X);
%     
%     file_n=fopen('burst.txt');%open notepad in ('at' permission) binary mode and then text mode and list out the file 
%     tline = fgetl(file_n);
%     while ischar(tline)
%         if contains(tline,oldfile)
%            ada=1;
%            break;
%         end
%         tline = fgetl(file_n);
%     end
%     fclose(file_n);
%     
%     if (ada==1)
%         X = sprintf('Skipped %s ',oldfile);
%         disp(X);
%         continue;
%     else
%         X = sprintf('Processed %s ',oldfile);
%         disp(X);
%         file_n=fopen('burst.txt','at');
%         fprintf(file_n,'\n%s',oldfile);%yg peratus tu nama dia formatSpec
%         fclose(file_n);
%     end 
%      
  
    
file_name;
 jump = false;
%%%%%%%%%%%------------function------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=strcat(dir_name,file_name);
str=string(file_name);
%str=urlread('http://soleil80.cs.technik.fhnw.ch/solarradio/data/2002-20yy_Callisto/2014/01/01/');
newstr=split(str,{' ','_','.'});
strO=newstr(1,1);
strcode=newstr(4,1);

% %%station1%%
% station1=0;
% st1='PHOENIX3';
% station=strcmp(strO,st1);
% if (station==1)
%         station1=1;
%         jump=true;
%     else
%         station1=0;
% % end
% 
% 
% try
%      data_ori=fitsread(s);
% 
% catch 
%   
%      display('bad data');
%      %mkdir(fullfile('result burst','error file'));
%      %save(fullfile('C:','xampp','solarburst','error file',file_name));
%      jump = true;
% 
% 
% end

 if ~ jump


%%%%%%%----cancellation background----%%%%%    
 %[avg data data_an fn tm]=backgrnd_cancel(file_name, dir_name);   
 [avg, data, data_an, fn, tm] = backgrnd_cancel2(file_name, dir_name);

temp=zeros(1,fn);

for x=1:fn
    temp(x)=min(data_an(x,:));
end

temp_v=min(temp);

if (temp_v<=0)
    
    data_an=data_an+((-1)*temp_v);
else 
    data_an=data_an + temp_v;
    

end
%%%%%%%------standardize size of the spectrum-----%%%%%%
siz_data=size(data_an);
fin=siz_data(1);
tim=siz_data(2);

maxfreq = 200;
maxtime = 3600;

if (fin == maxfreq && tim < maxtime)||(fin > maxfreq && tim < maxtime)||(fin < maxfreq && tim < maxtime)
    display('size spectrum is not standard');
    y=zeros(fin,tim);
    data_complete=zeros(fin,3600);
    for i=1:size(y,1)
         for j=1:size(y,2)
                data_complete(i,j)=data_an(i,j);
         end
    end
    
elseif (fin == maxfreq && tim > maxtime)|| (fin > maxfreq && tim > maxtime)||(fin < maxfreq && tim > maxtime)
    display('size spectrum is not standard');
    k=zeros(fin,tim);
    data_complete=zeros(fin,7200);
    for i=1:size(k,1)
         for j=1:size(k,2)
                data_complete(i,j)=data_an(i,j);
         end
    end
    
else
    display('size spectrum is standard');
    data_complete=data_an;
end 

%%%%%%-------compress size spectrum per sec (200,900)----%%%%%
m=4;
data_compress2=zeros(size(data_complete,1),size(data_complete,2)/m);
siz_meancol=size(data_compress2);
fin_mean=siz_meancol(1);
tim_mean=siz_meancol(2);
mean_col=zeros(1,tim_mean);
j=0;
     for i=1:4:size(data_complete,2)
        j=j+1;
        data_compress2(:,j)=mean(data_complete(:,i:i+m-1),2);
        data_compress=floor(data_compress2); 

     end
     
    if size(data_compress2, 2) == 1800
        data_compress3 = zeros(size(data_complete, 1), 900);
        j = 0;
        for i = 1:2:size(data_compress2, 2)
            j = j + 1;
            data_compress3(:, j) = mean(data_compress2(:, i:i + 1), 2);
        data_compress = floor(data_compress3);
        end
    end
 


%%% enhance burst event on the spectrum
[arr max_v]=distribution(data_complete,fn,tm);%%%%plot the maximum and minimum%%
[cont half data_fn]=threshold(arr,max_v,data_complete,fn,tm);%%make threshold point between them%%
data_filt = medfilt2(data_fn, [9 9]);    %%%Median filtering is a nonlinear operation often used in image
%processing to reduce "salt and pepper" noise. A median filter is more
%effective than convolution when the goal is to simultaneously reduce
%noise and preserve edges%%%%%
%dia come from median filtering in 2-D :-
%B=medfilt2(A,[m n]),m x n ada=3 x 3, 5 x 5,7 x 7 and 9 x 9 nnti ref ada kt
%filtering median-
% more to line shape of burst%
% data_filt=edge(data_filt,'canny');%nnti kita gunakan utk counting for
%classify



enh_col=mean(data_filt,1);
plot(enh_col);
enh_row=mean(data_filt,2);

%%tapisan utk kurangkan noise through sse poly1 of frequency channel data_filt3
%%%a.through freq channel data_filt3
n=4;
data_filt2=zeros(size(data_filt,1),size(data_filt,2)/n);
siz_meancol1=size(data_filt2);
fin_mean1=siz_meancol1(1);
tim_mean1=siz_meancol1(2);
mean_col1=zeros(1,tim_mean1);%%%mean intensity utk time channel utk dijadikan input pd condition 3
j=0;
     for i=1:4:size(data_filt,2)
        j=j+1;
        data_filt2(:,j)=mean(data_filt(:,i:i+m-1),2);
        data_filt3=floor(data_filt2);
     end
     
siz=size(data_filt3);
fn3=siz(1);
tm3=siz(2);
mean_curve=mean(data_filt3,2)';
meancur=mean(mean_curve);
diff_curve=zeros(1,fn3);
for i=1:fn3
    diff_curve(:,i)=(mean_curve(:,i)- meancur);
end


% Assuming diff_curve is already computed
max_difff = max(diff_curve, [], 1)'; % input y
xo = (1:1:size(diff_curve, 2))'; % input x

% Compute the linear fit coefficients (slope and intercept)
p = polyfit(xo, max_difff, 1); % p(1) is the slope (m), p(2) is the intercept (c)

% Manually set the intercept (c) to zero
c = 0;
m = p(1);

% Compute the fitted line using the new intercept
y_fit = m * xo + c;

% Plot the original data points
figure;
plot(xo, max_difff, 'bo', 'MarkerFaceColor', 'b'); % blue circles for data points
hold on;

% Plot the linear fit
plot(xo, y_fit, 'r-', 'LineWidth', 2); % red line for the fit
hold off;

% Add labels and title
title('Polynomial Fit Line y = mx + c');
xlabel('x (Column Number)');
ylabel('y (Max Intensity)');
legend('Data Points', 'Linear Fit', 'Location', 'best');
grid on;

% Display the slope and new intercept
disp(['Slope (m): ', num2str(m)]);
disp('Intercept (c): 0');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%classification type burst%%%%%%%%%%%
% Assuming data_filt3 and data_compress are your 2D matrices containing intensity values
data_filt3 = floor(data_filt3);  % Ensure data_filt3 is integer values
data_compress = floor(data_compress);  % Ensure data_compress is integer values

% Flag to indicate if switched to data_filt3
switched_to_filt3 = false;



%%%%%%%%%%%%%%%%%%%%%% Count the number of non-zero values in data_filt3
numNonZeroValues = 0;
numNonZeroValues = nnz(data_filt3);
disp(['nnz: ', num2str(numNonZeroValues)]);

numZeroValuesdata_fn=0;
numZeroValuesdata_fn = nnz(data_fn);
disp(['numZeroValuesdata_fn:', num2str(numZeroValuesdata_fn)]);

numZeroValuesdata_compress=0;
numZeroValuesdata_compress= nnz(data_compress);
disp(['numZeroValuesdata_compress:', num2str(numZeroValuesdata_compress)]);

% numZeroValuesdata_fn < 20000
    %disp(['Number of non-zero values i 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    %data_filt3: ' num2str(numNonZeroValues)]);
    %disp('Analyzing the position of the maximum intensity in the next 200 frequency channels.');

    % Find the position of the maximum intensity in the first frequency channel of data_compress
    [maxValue, maxIndex] = max(data_compress(:, 1));

    % Check if the position is within the valid range and if it's the same in the next frequency channel
    if maxIndex < size(data_compress, 2)
        nextChannelIntensity = data_compress(maxIndex, 2);

        if maxValue == nextChannelIntensity
            %disp('Position is the same in the next frequency channel (using data_compress).');
        else
            %disp('Position is different in the next frequency channel (using data_compress).');
        end

        % Initialize counter and array to store positions
        samePositionCounterdatacompress = 0;
        % Move the initialization of freqChannelsToCheck here
        freqChannelsToCheck = 200;
        samePositions = zeros(1, freqChannelsToCheck);
        

        % Analyze the position of the maximum intensity in the next 200 frequency channels
        for channel = 2:freqChannelsToCheck
            % Find the position of the maximum intensity in the current frequency channel
            [maxValue, maxIndex] = max(data_compress(:, channel));

            % Check if the position is within the valid range and if it's the same as in the previous frequency channel
            if maxIndex < size(data_compress, 2)
                prevChannelIntensity = data_compress(maxIndex, channel - 1);

                if maxValue == prevChannelIntensity
                    %disp(['Position is the same in channel ' num2str(channel) ' (using data_compress).']);
                    samePositionCounterdatacompress = samePositionCounterdatacompress + 1;
                    samePositions(samePositionCounterdatacompress) = maxIndex;
                else
                    %disp(['Position is different in channel ' num2str(channel) ' (using data_compress).']);
                end
            else
                %disp(['Maximum position is at the last position in channel ' num2str(channel) ' (using data_compress).']);
            end
            
            
            
        end

        % Display the number of occurrences and positions with the same intensity
        %disp(['Number of occurrences with the same intensity: ' num2str(samePositionCounter)]);
        %disp(['Positions with the same intensity: ' num2str(samePositions(1:samePositionCounter))]);
    else
        %disp('Maximum position is at the last position in the first channel (using data_compress).');
    end
    % Check if samePositionCounter is greater than 50
    disp(['samec: ', num2str(samePositionCounterdatacompress)]);


    if numZeroValuesdata_fn < 20000 
        disp('samePositionCounterdatacompress is greater than 45. Switching to use data_compress for next calculations.');
        disp('use data_compress for next calculations.');
        % Further calculations using data_compress can be added here
        data_to_use = data_compress;
        siz=size(data_compress);
        fn3compres=siz(1);
        tm3compres=siz(2);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%data-compress%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     

        %%%%%%%%%%%%%%%%%%%%%%%%%%%1. frequency range%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%a. through frequency channel%%%%
        [frq_fnc] = frequencychannel2(data_compress,fn3compres);
        
        % Save frq_fn plot
        folderPath2 = 'C:\Users\\';
        fileName = strrep(file_name, '.fit', '_data_intfre.png');  % Adjust the filename as needed
        fullFilePath = fullfile(folderPath2, fileName);
        
        % Display and save the image
        figure('Visible', 'off');
        plot(frq_fnc);
        xlabel('Frequency channel');
        ylabel('Intensity(digit)');
        saveas(gcf, fullFilePath);
        % Close the figure
        close(gcf);

        %%%%%%%%%%% Changes between point in frequency channel(totalchangesfreq) 
        % Gaussian NLL
        % x and y are your data
        xcompres = (0:numel(frq_fnc)-1)';
        ycompres = frq_fnc';
        % Initial guess for parameters  vvf
        a1_initc = max(ycompres);  % Initial guess for amplitude
        b1_initc = find(ycompres  == max(ycompres), 1);  % Initial guess for mean (use the index of the maximum value)
        c1_initc = 1;  % Initial guess for standard 
        
        % Create a Gaussian fit mode
        gauss_model = fittype('a1 * exp(-(x - b1)^2 / (2 * c1^2))', 'independent', 'x', 'dependent', 'y');
        % Set up the fit options
        fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a1_initc, b1_initc, c1_initc]);
        % Fit the model to the data
        [fit_resultc1, gof1] = fit(xcompres, ycompres , gauss_model, fit_options);
        % Calculate the predicted values using the fitted parameters
        y_fitc1 = fit_resultc1.a1 * exp(-(xcompres - fit_resultc1.b1).^2 / (2 * fit_resultc1.c1^2));

        % Calculate the residuals (the differences between the observed and predicted values) for the first fit
        residuals1 = ycompres - y_fitc1;
        % Calculate the total sum of squares for the first fit
        total_sum_squares1 = sum((ycompres - mean(ycompres)).^2);
        % Calculate the sum of squares of residuals for the first fit
        sum_squares_residuals1 = sum(residuals1.^2);
        % Calculate the R-square value for the first fit
        rsquare_valuec1 = 1 - sum_squares_residuals1 / total_sum_squares1;

        % Display or use the fitted parameters
        disp(['Fitted value for afc1: ', num2str(fit_resultc1.a1)]);
        disp(['Fitted value for bfc1: ', num2str(fit_resultc1.b1)]);
        disp(['Fitted value for cfc1: ', num2str(fit_resultc1.c1)]);        
        disp(['R-square value data compress frequency: ', num2str(rsquare_valuec1)]);
        
        % save Plot the plot the first gaussian fit
        figure;
        plot(xcompres, ycompres, 'o', 'DisplayName', 'Original Data');
        hold on;        
        x_fit = linspace(min(xcompres), max(xcompres), length(xcompres));   % Generate points for smooth curve
        plot(x_fit, y_fitc1, 'r-', 'DisplayName', 'Gaussian Fit');
        legend;
        xlabel('x');
        ylabel('y');
        title('Gaussian Fit');
        grid on;
       
        % Specify the folder where you want to save the plot
        folder_path3 = 'C:\Users\\';
        fileName = strrep(file_name, '.fit', '_gaussian_fit_plot.png');  % Adjust the filename as needed
        fullFilePath = fullfile(folder_path3, fileName);
        % Ensure the folder exists, create it if necessary
        if ~exist(folder_path3, 'dir')
            mkdir(folder_path3);
        end
        % Save the plot in the specified folder
        saveas(gcf, fullFilePath);
        % Close the figure
        close(gcf);
        
        % Find the starting and ending points based on the Gaussian parameters
        start_point_xc = round(fit_resultc1.b1 - 2 * fit_resultc1.c1); % Adjust factor as needed
        end_point_xc = round(fit_resultc1.b1 + 2 * fit_resultc1.c1);   % Adjust factor as needed

        

            %%% Ensure that start_point_y does not low than 1
            fn3compres=siz(1);
            if start_point_xc >= fn3compres
                 start_point_xc = 1;
            end
            % Ensure that start_point_x does not exceed 1
            if start_point_xc <= 1
                start_point_xc = 1;
            end
        
            % Ensure that end_point_x does not exceed 200
            if end_point_xc >= fn3compres
                end_point_xc = fn3compres;
            end

            if end_point_xc <= 0
                end_point_xc = fn3compres;
            end
            


        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % do the 2nd gaussian fit if R-square is between 0.1 and 0.5 and c1 < 10 
        % Initialize rsquare_valuec2 before the first if statement
        rsquare_valuec2 = 0;
        if rsquare_valuec1 < 0.5 && fit_resultc1.c1 < 10
        disp('R-square is lower than 0.5 and standard deviation less than 10 Performing second Gaussian fit.');      

            % Initial guess for the parameters for the second fit
            a2_initc2 = 0.5 * max(ycompres); 
            % Find the position in y where the value is equal to a2_init
            indices = find(ycompres == a2_initc2);    
            % Check if indices is not empty before accessing its elements
            if ~isempty(indices)
                % Choose the first occurrence
                b2_initc2 = indices(1);
            else    
                % If indices is empty, find the nearest position with a value
                [~, b2_initc2] = min(abs(ycompres - a2_initc2));
            end
            c2_initc2= 1;  % Adjust as needed

            % Create a second Gaussian fit model
            gauss_model2 = fittype('a2 * exp(-(x - b2)^2 / (2 * c2^2))', 'independent', 'x', 'dependent', 'y');
            % Set up the fit options for the second fit
            fit_options2 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a2_initc2, b2_initc2, c2_initc2]);
            % Fit the second model to the data
            [fit_resultc2, gof2] = fit(xcompres, ycompres, gauss_model2, fit_options2);
            % Calculate the predicted values using the fitted parameters for the second fit
            y_fitc2 = fit_resultc2.a2 * exp(-(xcompres - fit_resultc2.b2).^2 / (2 * fit_resultc2.c2^2));

            % Plot the original data and the first and second fitted curves
            figure;
            plot(xcompres, ycompres, 'o', 'DisplayName', 'Original Data');
            hold on;
            plot(xcompres, y_fitc1, 'r-', 'DisplayName', 'First Gaussian Fit');
            plot(xcompres, y_fitc2, 'g-', 'DisplayName', 'Second Gaussian Fit');
            legend;
            xlabel('x');
            ylabel('y');
            title('Gaussian Fits');
            grid on;

            % Specify the folder where you want to save the second Gaussian plot
            folder_path = 'C:\Users\\';
            file_name = strrep(file_name, '.fit', '_gaussian_fits.png');  % Adjust the filename as needed
            full_file_path = fullfile(folder_path, file_name);
            % Save the plot
            saveas(gcf, full_file_path);
            % Close the figure
            close(gcf);
            
            % Calculate the residuals (the differences between the observed and predicted values) for the second fit
            residuals2 = ycompres - y_fitc2;
            % Calculate the total sum of squares for the second fit
            total_sum_squares2 = sum((ycompres - mean(ycompres)).^2);
            % Calculate the sum of squares of residuals for the second fit
            sum_squares_residuals2 = sum(residuals2.^2);
            % Calculate the R-square value for the second fit
            rsquare_valuec2 = 1 - sum_squares_residuals2 / total_sum_squares2;

            % Display or use the fitted parameters
            disp(['Fitted value for afc2: ', num2str(fit_resultc2.a2)]);
            disp(['Fitted value for bfc2: ', num2str(fit_resultc2.b2)]);
            disp(['Fitted value for cfc2: ', num2str(fit_resultc2.c2)]);
            disp(['R-square value data compress for the second fit: ', num2str(rsquare_valuec2)]);
         
         % Check if rsquare_valuec2 is the same as rsquare_valuec1 and fit_resultc2.c2 < 10
             if (rsquare_valuec2 == rsquare_valuec1 && fit_resultc2.c2 < 10)  && (rsquare_valuec2 < 0)
                start_point_xc = 1;
                end_point_xc = 199;% Set start_point_xc to 1 and end_point_xc to 199
             else
                start_point_xc = round(fit_resultc2.b2 - 2 * fit_resultc2.c2); % Adjust factor as needed
                end_point_xc = round(fit_resultc2.b2 + 2 * fit_resultc2.c2); 
             end
              %%% Ensure that start_point_y does not low than 1
            fn3compres=siz(1);
            if start_point_xc >= fn3compres
                 start_point_xc = 1;
            end
            % Ensure that start_point_x does not exceed 1
            if start_point_xc <= 1
                start_point_xc = 1;
            end
        
            % Ensure that end_point_x does not exceed 200
            if end_point_xc >= fn3compres
                end_point_xc = fn3compres;
            end

            if end_point_xc <= 0
                end_point_xc = fn3compres;
            end
        end
         
        %%%%%%%%%%%%%%%%%%%%%
        % Calculate the changes in between point in frequency channel
        totalchangesfrequencyc=end_point_xc-start_point_xc;% Calculate the changes in between point in frequency channel
        
            % this is for write the result totalchangesfrequency  
            % Convert file_name to cell array if it's a character array
            if ischar(file_name)
                file_name2 = cellstr(file_name);
            end

            % Construct a unique Excel file name based on the original file name
            excel_filename = fullfile('C:\Users\\', 'total_changes_frequencyc.xlsx');

           % Check if the Excel file already exists
            if exist(excel_filename, 'file')
                % Load existing data from the Excel file
                existing_data = readtable(excel_filename);

                % Create a new row with file name, start_point_xc, end_point_xc, and total changes frequency
                new_row = {file_name2, start_point_xc, end_point_xc, totalchangesfrequencyc};

                % Append the new row to the existing data
                new_data = [existing_data; new_row];

                % Write the updated data to the Excel file
                writetable(new_data, excel_filename);
            else
                % Create a table with file name, start_point_xc, end_point_xc, and total changes frequency
                data_table = table(file_name2, start_point_xc, end_point_xc, totalchangesfrequencyc, 'VariableNames', {'FileName', 'StartPointXC', 'EndPointXC', 'TotalChangesFrequency'});

                % Write the table to the Excel file
                writetable(data_table, excel_filename);
            end

        
            
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2. time channel
        %%%%%%%%%%%%%%%%%%%through time channel%%%%%%%%%%%%%%%
        [sum_tmc ] = timechannel2(data_compress,tm3compres);

        %  Save sum_tm plot
        folderPath3 = 'C:\Users\\';
        fileName = strrep(file_name, '.fit', '_data_compress.png');  % Adjust the filename as needed
        fullFilePath = fullfile(folderPath3, fileName);

        % Display and save the image
        figure('Visible','off');
        plot(sum_tmc);
        xlabel('Timestep');
        ylabel('Intensity(digit)');
        saveas(gcf, fullfile(folderPath3, strrep(file_name, '.fit', '_sum_tmc_plot.png')));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Changes between point in time channel 
        % Gaussian LNN
        % Assuming x and y are your data
        xcompres2 = (0:numel(sum_tmc)-1)';
        ycompres2 = sum_tmc';

        % Initial guess for parameters  vvf
        a1_initct = max(ycompres2);  % Initial guess for amplitude
        b1_initct = find(ycompres2 == max(ycompres2), 1);  % Initial guess for mean (use the index of the maximum value)
        c1_initct = 1;  % Initial guess for standard deviation

        % Create a Gaussian fit model
        gauss_model = fittype('a1 * exp(-(x - b1)^2 / (2 * c1^2))', 'independent', 'x', 'dependent', 'y');
        % Set up the fit options
        fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a1_initct, b1_initct, c1_initct]);
        % Fit the model to the data
        [fit_resultct, gof] = fit(xcompres2, ycompres2, gauss_model, fit_options);
        % Calculate the predicted values using the fitted parameters for the first fit
        y_fitct1 = fit_resultct.a1 * exp(-(xcompres2 - fit_resultct.b1).^2 / (2 * fit_resultct.c1^2));

        % Calculate the residuals (the differences between the observed and predicted values) for the first fit
        residuals1 = ycompres2 - y_fitct1;
        % Calculate the total sum of squares for the first fit
        total_sum_squares1 = sum((ycompres2 - mean(ycompres2)).^2);
        % Calculate the sum of squares of residuals for the first fit
        sum_squares_residuals1 = sum(residuals1.^2);
        % Calculate the R-square value for the first fit
        rsquare_valuect1 = 1 - sum_squares_residuals1 / total_sum_squares1;

        % Display or use the fitted parameters for the first fit
        disp(['Fitted value for atc1: ', num2str(fit_resultct.a1)]);
        disp(['Fitted value for btc1: ', num2str(fit_resultct.b1)]);
        disp(['Fitted value for ctc1: ', num2str(fit_resultct.c1)]);
        disp(['R-square value data compress time: ', num2str(rsquare_valuect1)]);

        % Save the plot of the first Gaussian fit
        figure;
        plot(xcompres2, ycompres2, 'o', 'DisplayName', 'Original Data');
        hold on;
        plot(xcompres2, y_fitct1, 'r-', 'DisplayName', 'First Gaussian Fit');
        legend;
        xlabel('x');
        ylabel('y');
        title('First Gaussian Fit');
        grid on;

        % Specify the folder where you want to save the plot
        folder_path = 'C:\Users\\';
        file_name = strrep(file_name, '.fit', '_first_gaussian_fit.png');  % Adjust the filename as needed
        full_file_path = fullfile(folder_path, file_name);
        % Save the plot
        saveas(gcf, full_file_path);
        % Close the figure
        close(gcf);

        % Find the starting and ending points based on the Gaussian parameters
        start_point_yc = round(fit_resultct.b1 - 2 * fit_resultct.c1); % Adjust factor as needed
        end_point_yc = round(fit_resultct.b1 + 2 * fit_resultct.c1);   % Adjust factor as needed

            % Ensure that start_point_y does not exceed 1
            if start_point_yc <= 1
                start_point_yc = 1;
            end

            % % Ensure that start_point_y does not low than 1
            if start_point_yc >= 900
                start_point_yc = 1;
            end

            % Ensure that end_point_y does not exceed 900
           if end_point_yc >= 900
                % Check if file_name is "OSRA"
                if strcmp(strO, 'OSRA')
                    % If file_name is "OSRA" and end_point_yc is >= 900, keep it as is
                    % (no modification needed in this case)
                    end_point_yc= round(fit_resultct.b1 + 2 * fit_resultct.c1);  
                else
                    % If file_name is not "OSRA", set end_point_yc to 900
                    end_point_yc = 900;
                end            
           end

            if end_point_yc <= 0
                end_point_yc = 900;
            end
        
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Initialize rsquare_value2 before the first if statement
        rsquare_valuect2 =0;
        % do the 2nd gaussian fit if R-square is lower than 0.5 and c1 <10 
        if rsquare_valuect1 < 0.5 && fit_resultct.c1 < 10
            disp('R-square is lower than 0.5 and standard deviation less than 10 Performing second Gaussian fit.');

            % Initial guess for the parameters for the second fit
            a2_initct2 = 0.5 * max(ycompres2); 
            % Find the position in y where the value is equal to a2_init
            indices = find(ycompres2 == a2_initct2);    
            % Check if indices is not empty before accessing its elements
            if ~isempty(indices)
                % Choose the first occurrence
                b2_initct2 = indices(1);
            else
                % If indices is empty, find the nearest position with a value
                [~, b2_initct2] = min(abs(ycompres2 - a2_initct2));
            end
            c2_initct2 = 1;  % Adjust as needed

           % Create a second Gaussian fit model
            gauss_model2 = fittype('a2 * exp(-(x - b2)^2 / (2 * c2^2))', 'independent', 'x', 'dependent', 'y');
            % Set up the fit options for the second fit
            fit_options2 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a2_initct2, b2_initct2, c2_initct2]);
            % Fit the second model to the data
            [fit_resultct2, gof2] = fit(xcompres2, ycompres2, gauss_model2, fit_options2);
            % Calculate the predicted values using the fitted parameters for the second fit
            y_fitct2 = fit_resultct2.a2 * exp(-(xcompres2 - fit_resultct2.b2).^2 / (2 * fit_resultct2.c2^2));

             % Plot the original data and the first and second fitted curves
            figure;
            plot(xcompres2, ycompres2, 'o', 'DisplayName', 'Original Data');
            hold on;
            plot(xcompres2, y_fitct2, 'r-', 'DisplayName', 'First Gaussian Fit');
            plot(xcompres2, y_fitct2, 'g-', 'DisplayName', 'Second Gaussian Fit');
            legend;
            xlabel('x');
            ylabel('y');
            title('Gaussian Fits');
            grid on;

            % Specify the folder where you want to save the Gaussian plot
            folder_path = 'C:\Users\\';
            file_name = strrep(file_name, '.fit', '_gaussian_fits.png');  % Adjust the filename as needed
            full_file_path = fullfile(folder_path, file_name);
            % Save the plot
            saveas(gcf, full_file_path);
            % Close the figure
            close(gcf);

            % Calculate the residuals (the differences between the observed and predicted values) for the second fit
            residuals2 = ycompres2 - y_fitct2;
            % Calculate the total sum of squares for the second fit
            total_sum_squares2 = sum((ycompres2 - mean(ycompres2)).^2);
            % Calculate the sum of squares of residuals for the second fit
            sum_squares_residuals2 = sum(residuals2.^2);
            % Calculate the R-square value for the second fit
            rsquare_valuect2 = 1 - sum_squares_residuals2 / total_sum_squares2;

            % Display or use the fitted parameters for the first fit
            disp(['Fitted value for atc2: ', num2str(fit_resultct2.a2)]);
            disp(['Fitted value for btc2: ', num2str(fit_resultct2.b2)]);
            disp(['Fitted value for ctc2: ', num2str(fit_resultct2.c2)]);
            disp(['R-square value for the second fit: ', num2str(rsquare_valuect2)]);
            
            
             % Check if rsquare_valuec2 is the same as rsquare_valuec1 and fit_resultc2.c2 < 10
             if (rsquare_valuect2 == rsquare_valuect1 && fit_resultct2.c2 < 10)  && (rsquare_valuect2 < 0)
                start_point_yc = 1;
                end_point_yc = 899;% Set start_point_xc to 1 and end_point_xc to 199
             else
                start_point_yc = round(fit_resultct2.b2 - 2 * fit_resultct2.c2); % Adjust factor as needed
                end_point_yc = round(fit_resultct2.b2 + 2 * fit_resultct2.c2); 
             end
             % Ensure that start_point_y does not exceed 1
            if start_point_yc <= 1
                start_point_yc = 1;
            end

            % % Ensure that start_point_y does not low than 1
            if start_point_yc >= 900
                start_point_yc = 1;
            end

            % Ensure that end_point_y does not exceed 900
           if end_point_yc >= 900
                % Check if file_name is "OSRA"
                if strcmp(strO, 'OSRA')
                    % If file_name is "OSRA" and end_point_yc is >= 900, keep it as is
                    % (no modification needed in this case)
                    end_point_yc= round(fit_resultct.b1 + 2 * fit_resultct.c1);  
                else
                    % If file_name is not "OSRA", set end_point_yc to 900
                    end_point_yc = 900;
                end            
           end

            if end_point_yc <= 0
                end_point_yc = 900;
            end
             
             
             
        end

       

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Calculate the changes in between point in time channel
        totalchangestimec=end_point_yc-start_point_yc;

            % Convert file_name to cell array if it's a character array
            if ischar(file_name)
                file_name2 = cellstr(file_name);
            end

            % Construct a unique Excel file name based on the original file name
            excel_filename = fullfile('C:\Users\\', 'total_changes_timec.xlsx');

           % Check if the Excel file already exists
            if exist(excel_filename, 'file')
                %Load existing data from the Excel file
                existing_data = readtable(excel_filename);

                %Create a new row with file name and total changes frequency
                new_row = {file_name2,start_point_yc,end_point_yc, totalchangestimec};

                %Append the new row to the existing data
                new_data = [existing_data; new_row];

                %Write the updated data to the Excel file
                writetable(new_data, excel_filename);
            else
                %Create a table with file name and total changes frequency
                data_table = table(file_name2, start_point_yc,end_point_yc, totalchangestimec, 'VariableNames', {'FileName','StartPointYC', 'EndPointYC', 'TotalChangesFrequency'});

                %Write the table to the Excel file
                writetable(data_table, excel_filename);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%classify 3 &4 :gradient in middle area binary value
           
              % Assuming data_filt3 is your original array
              % Find the maximum intensity in data_compress
               max_intensity = max(data_compress(:));

               % Define the threshold (60% of max intensity)
                thresholdcheck = 0.3 * max_intensity;

               % Threshold the values in data_compress
                data_compress_thresholded = (data_compress>= thresholdcheck);

               % Convert the logical array to double (0 and 1)
                data_compress_binary = double(data_compress_thresholded);
            
            
                % Use bwlabel to label connected components
                labeled_components = bwlabel(data_compress_binary);

                % Display the original image and overlay the boundaries
                figure;
                imshow(data_compress_binary); hold on;

                % Use regionprops to get properties of connected components, including 'FilledImage'
                stats = regionprops(labeled_components, 'Area', 'PixelIdxList');

                % Initialize arrays to store gradient and area values
                gradient_values = zeros(1, length(stats));

                % Find the indices of the five largest areas
                [~, sorted_indices] = sort([stats.Area], 'descend');
                top_2_indices = sorted_indices(1:min(2, length(stats)));

                % Loop over each connected component
                for k = 1:length(top_2_indices)
                    idx = top_2_indices(k);

                    % Extract pixel indices for the boundary
                    boundary_indices = stats(idx).PixelIdxList;

                    % Convert linear indices to subscripts
                    [rows, cols] = ind2sub(size(data_compress_binary), boundary_indices);

                    % Calculate the middle point of the boundary
                    x_coord = round(mean(cols));
                    y_coord = round(mean(rows));

                    % Fit a linear line to the boundary along rows
                    p_rows = polyfit(rows, cols, 1);

                    % Calculate the gradient of the line along rows
                    gradient_rows = p_rows(1);
                    gradient_values(k) = gradient_rows;

                    % Plot a red dot at the middle point
                    plot(x_coord, y_coord, 'ro');

                    % Plot the linear line along rows
                    plot(polyval(p_rows, rows), rows, 'b', 'LineWidth', 2);

                    % Display the gradient along rows
                    text(x_coord, y_coord, sprintf('Gradient: %.2f', gradient_rows), 'Color', 'y');
                end

                % Display the image with marked gradients
                %title('Image with Marked Gradients on Top 2 Area Components');
                hold off;
                
                
                % Assign the gradient values to variables in the workspace
                gr1 = round(gradient_values(1, 1), 2); % Gradient value for the first highest area

                if size(gradient_values, 2) >= 2 % Check if there are at least 2 columns in gradient_values
                    % If there are at least 2 columns, assign gr2 accordingly
                    gr2 = round(gradient_values(1, 2), 2);
                else
                    if size(gradient_values, 1) >= 2 % Check if there are at least 2 rows in gradient_values
                        % If there's only one column, assign gr2 from the second row
                        gr2 = round(gradient_values(2, 1), 2);
                    else
                        % If there's only one element in gradient_values, assign 0 to gr2
                        gr2 = 0;
                    end
                end

                    
                    if (gr1 < 1e-10) && (gr2 < 1e-10)
                    % Flag to indicate if switched to data_filt3
                    switched_to_filt3 = true;
                    end
%                   


                % Display gradient values in the command window
                disp('Gradient values for top 2 highest areas along rows:');
                for i = 1:length(top_2_indices)
                    if i <= length(gradient_values)
                        fprintf('Area %d: Gradient %.2f\n', top_2_indices(i), gradient_values(i));
                    else
                        fprintf('Area %d: Gradient N/A\n', top_2_indices(i));
                    end
                end
% 


                % Specify the folder path where you want to save the image
                folder_path = 'C:\Users\\';
                % Specify the file name and format (e.g., 'result_image.png')
                file_name4 = strrep(file_name, '.fit', '_data_binaryc.png');
                % Combine folder path and file name
                full_file_path4 = fullfile(folder_path, file_name4);
                % Save the figure
                saveas(gcf, full_file_path4);

            totalchangesfrequency=totalchangesfrequencyc;
            totalchangestime=totalchangestimec;

else
    disp('Number of non-zero values in data_fn is not less than 20000.');
    disp('use data_filt3 for next calculations.');
    data_to_use = data_filt3;
      
        
    data_filt4 = zeros(size(data_filt3, 1), 900);
    j = 0; 
    
    if size(data_filt3, 2) == 1800
         temp_data_filt3 = data_filt3;  % Create a temporary variable
        for i = 1:2:size(data_filt3, 2)
                j = j + 1;
                data_filt4(:, j) = mean(temp_data_filt3(:, i:i + 1), 2);
                data_filt3 = floor(data_filt4);
        end
    end
    
        %%%%%%%%%%%%%%data filt3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Saving data_filt3 as PNG
        folderPath = 'C:\Users\\';
        fileName = strrep(file_name, '.fit', '_data_filt3.png');  % Adjust the filename as needed
        fullFilePath= fullfile(folderPath, fileName);
        
        % Display and save the image
        figure('Visible', 'off');
        imagesc(data_filt3);
        colormap('jet');
        xlabel('Timestep');
        ylabel('Frequency channel');
        h = colorbar;  % Add a color bar to the side of the plot
        ylabel(h, 'Intensity(digit dB)'); 
        % Save the figure
        saveas(gcf, fullFilePath);
        % Close the figure
        close(gcf);
        
        %%%%%%%%%%%%%%%%%frequency range=totalchangesfreq)%%%%%%%%%
         siz=size(data_filt3);%input data
         fn3=siz(1);%input y
         tm3=siz(2);%input x


        %%%%%%%%%%%%%%%%%% changes total intensity across frequency channel%%%%%%%%%%%%%%%%%%%%%%%
        [frq_fn ] = frequencychannel(data_filt3,fn3);

        % Save frq_fn plot %%%
        folderPath2 = 'C:\Users\\\';
        fileName = strrep(file_name, '.fit', '_data_filt3.png');  % Adjust the filename as needed
        fullFilePath = fullfile(folderPath2, fileName);
        % Display and save the image
        figure('Visible', 'off');
        plot(frq_fn);
        xlabel('Frequency channel');
        ylabel('Intensity(digit)');
        saveas(gcf, fullFilePath);
        % Close the figure
        close(gcf);
        
        %%%%%%%%%%1. frequency channel%%%%%%%%%%%%%%%%%%
        %%% Gaussian LNN
        % Assuming x and y are your data
        x = (0:numel(frq_fn)-1)';
        y = frq_fn';

        a1_initf = max(y);  % Initial guess for amplitude
        b1_initf = find(y == max(y), 1);  % Initial guess for mean (use the index of the maximum value)
        c1_initf= 1;  % Initial guess for standard deviation

        % Create a Gaussian fit model
        gauss_model = fittype('a1 * exp(-(x - b1)^2 / (2 * c1^2))', 'independent', 'x', 'dependent', 'y');
        % Set up the fit options for the first fit
        fit_options1 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a1_initf, b1_initf, c1_initf]);
        % Fit the first model to the data
        [fit_result1, gof1] = fit(x, y, gauss_model, fit_options1);
        % Calculate the predicted values using the fitted parameters for the first fit
        y_fit1 = fit_result1.a1 * exp(-(x - fit_result1.b1).^2 / (2 * fit_result1.c1^2));

        % Calculate the residuals (the differences between the observed and predicted values) for the first fit
        residuals1 = y - y_fit1;
        % Calculate the total sum of squares for the first fit
        total_sum_squares1 = sum((y - mean(y)).^2);
        % Calculate the sum of squares of residuals for the first fit
        sum_squares_residuals1 = sum(residuals1.^2);
        % Calculate the R-square value for the first fit
        rsquare_value1 = 1 - sum_squares_residuals1 / total_sum_squares1;

        % Display or use the fitted parameters for the first fit
        disp(['Fitted value for a1: ', num2str(fit_result1.a1)]);
        disp(['Fitted value for b1: ', num2str(fit_result1.b1)]);
        disp(['Fitted value for c1: ', num2str(fit_result1.c1)]);
        disp(['R-square value frequency: ', num2str(rsquare_value1)]);

        % Save the plot of the first Gaussian fit
        figure;
        plot(x, y, 'o', 'DisplayName', 'Original Data');
        hold on;
        plot(x, y_fit1, 'r-', 'DisplayName', 'First Gaussian Fit');
        legend;
        xlabel('Frequency channel');
        ylabel('Intensity(digit)');
       % title('First Gaussian Fit');
        grid off;

        % Specify the folder where you want to save the plot
        folder_path = 'C:\Users\\';
        file_name = strrep(file_name, '.fit', '_first_gaussian_fit.png');  % Adjust the filename as needed
        full_file_path = fullfile(folder_path, file_name);

        % Save the plot
        saveas(gcf, full_file_path);
        % Close the figure
        close(gcf);

        %%%%% Find the starting and ending points based on the Gaussian parameters
        start_point_x = round(fit_result1.b1 - 2 * fit_result1.c1); % Adjust factor as needed
        end_point_x = round(fit_result1.b1 + 2 * fit_result1.c1);   % Adjust factor as needed
            
            % Ensure that start_point_x does not exceed 1
            if start_point_x <= 1
                start_point_x = 1;
            end
            % Ensure that start_point_y does not low than 1
            fn3=siz(1);
            if start_point_x >= fn3
                start_point_x = 1;
            end
             % Ensure that end_point_x does not exceed 200
            if end_point_x >= fn3
                end_point_x = fn3;
            end
            if end_point_x <= 0
                end_point_x = fn3;
            end

        %%%%%%%%%%%%%%%%%%%%%%%    
        % Initialize rsquare_value2 before the first if statement
        rsquare_value2 =0;

        % do the 2nd gaussian fit if R-square is lower than 0.5 and c1 <10 rsquare_value1 > 0.1 &&
      if  rsquare_value1 < 0.5 && fit_result1.c1 < 10
        disp('R-square is lower than 0.5 and standard deviation less than 10 Performing second Gaussian fit.');

            % Initial guess for the parameters for the second fit
            a2_initf = 0.5 * max(y); 
            % Find the position in y where the value is equal to a2_init
            indices = find(y == a2_initf);    
            % Check if indices is not empty before accessing its elements
            if ~isempty(indices)
                % Choose the first occurrence
                b2_initf = indices(1);
            else
                % If indices is empty, find the nearest position with a value
                [~, b2_initf] = min(abs(y - a2_initf));
            end
            c2_initf = 1;  % Adjust as needed

            % Create a second Gaussian fit model
            gauss_model2 = fittype('a2 * exp(-(x - b2)^2 / (2 * c2^2))', 'independent', 'x', 'dependent', 'y');
            % Set up the fit options for the second fit
            fit_options2 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a2_initf, b2_initf, c2_initf]);
            % Fit the second model to the data
            [fit_result2, gof2] = fit(x, y, gauss_model2, fit_options2);
            % Calculate the predicted values using the fitted parameters for the second fit
            y_fit2 = fit_result2.a2 * exp(-(x - fit_result2.b2).^2 / (2 * fit_result2.c2^2));

            % Plot the original data and the first and second fitted curves
            figure;
            plot(x, y, 'o', 'DisplayName', 'Original Data');
            hold on;
            plot(x, y_fit1, 'r-', 'DisplayName', 'First Gaussian Fit');
            plot(x, y_fit2, 'g-', 'DisplayName', 'Second Gaussian Fit');
            legend;
            xlabel('Frequency channel');
            ylabel('Intensity(digit)');
            title('Gaussian Fits');
            grid off;

            % Specify the folder where you want to save the Gaussian plot
            folder_path = 'C:\Users\\';
            file_name = strrep(file_name, '.fit', 'second_gaussian_fit.png');  % Adjust the filename as needed
            full_file_path = fullfile(folder_path, file_name);
            % Save the plot
            saveas(gcf, full_file_path);
            % Close the figure
            close(gcf);

            % Calculate the residuals (the differences between the observed and predicted values) for the second fit
            residuals2 = y - y_fit2;
            % Calculate the total sum of squares for the second fit
            total_sum_squares2 = sum((y - mean(y)).^2);
            % Calculate the sum of squares of residuals for the second fit
            sum_squares_residuals2 = sum(residuals2.^2);
            % Calculate the R-square value for the second fit
            rsquare_value2 = 1 - sum_squares_residuals2 / total_sum_squares2;

            % Display or use the fitted parameters for the first fit
            disp(['Fitted value for a2: ', num2str(fit_result2.a2)]);
            disp(['Fitted value for b2: ', num2str(fit_result2.b2)]);
            disp(['Fitted value for c2: ', num2str(fit_result2.c2)]);
            disp(['R-square value for the second fit: ', num2str(rsquare_value2)]);

        % Check if rsquare_valuec2 is the same as rsquare_valuec1 and fit_resultc2.c2 < 10
          if (rsquare_value2 == rsquare_value1 && fit_result2.c2 < 10)  && (rsquare_valuect2 < 0)
              start_point_x = 1;
              end_point_x = 199;% Set start_point_xc to 1 and end_point_xc to 199
          else
              start_point_x = round(fit_result2.b2 - 2 * fit_result2.c2); % Adjust factor as needed
              end_point_x = round(fit_result2.b2 + 2 * fit_result2.c2); 
          end
        
            % Ensure that start_point_x does not exceed 1
            if start_point_x <= 1
                start_point_x = 1;
            end
            % Ensure that start_point_y does not low than 1
            fn3=siz(1);
            if start_point_x >= fn3
                start_point_x = 1;
            end
            
             % Ensure that end_point_x does not exceed 200
            if end_point_x >= fn3
                end_point_x = fn3;
            end
            if end_point_x <= 0
                end_point_x = fn3;
            end
          
          
      end


 

        %%%%%%% Calculate the changes in between point in frequency channel
        totalchangesfrequency=end_point_x-start_point_x;
        
         % this is for write the result totalchangesfrequency  
          % Convert file_name to cell array if it's a character array
            if ischar(file_name)
                file_name2 = cellstr(file_name);
            end

           % Construct a unique Excel file name based on the original file name
            excel_filename = fullfile('C:\Users\\', 'total_changes_frequency.xlsx');

           % Check if the Excel file already exists
            if exist(excel_filename, 'file')
                %Load existing data from the Excel file
                existing_data = readtable(excel_filename);

                %Create a new row with file name and total changes frequency
                new_row = {file_name2, start_point_x, end_point_x, totalchangesfrequency};

                %Append the new row to the existing data
                new_data = [existing_data; new_row];

                %Write the updated data to the Excel file
                writetable(new_data, excel_filename);
            else
                %Create a table with file name and total changes frequency
                data_table = table(file_name2, start_point_x, end_point_x, totalchangesfrequency, 'VariableNames', {'FileName', 'StartPointX', 'EndPointX','TotalChangesFrequency'});

                %Write the table to the Excel file
                writetable(data_table, excel_filename);
            end

        
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 


        %%%%%%%%%%%%Changes duration totalchangestime)%%%%%%%%%%%%%%%%%%%%%%
        %%% total intensity across time channel%%%%%
        [sum_tm ] = timechannel(data_filt3,tm3);
        

        %  Save sum_tm plot
        folderPath3 = 'C:\Users\\';
        fileName = strrep(file_name, '.fit', '_data_filt3.png');  % Adjust the filename as needed
        fullFilePath = fullfile(folderPath3, fileName);
        % Display and save the image
        figure('Visible','off');
        plot(sum_tm);
        xlabel('Timestep');
        ylabel('Intensity(digit)');
        saveas(gcf, fullfile(folderPath3, strrep(file_name, '.fit', '_sum_tm_plot.png')));
        % Close the figure
        close(gcf);

        %%%% Changes between point in time channel(totalchangestime)
        % Assuming x and y are your data
        x2 = (0:numel(sum_tm)-1)';
        y2 = sum_tm';
        
        % Initial guess for parameters  vvf
        a1_initt = max(y2);  % Initial guess for amplitude
        b1_initt = find(y2 == max(y2), 1);  % Initial guess for mean (use the index of the maximum value)
        c1_initt = 1;  % Initial guess for standard deviation
        
        % Create a Gaussian fit model
        gauss_model = fittype('a1 * exp(-(x - b1)^2 / (2 * c1^2))', 'independent', 'x', 'dependent', 'y');
        % Set up the fit options
        fit_options = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a1_initt, b1_initt, c1_initt]);
        % Fit the model to the data
        fit_resultt1 = fit(x2, y2, gauss_model, fit_options);


        % Calculate the predicted values using the fitted parameters
        y_fitt1 = fit_resultt1.a1 * exp(-(x2 - fit_resultt1.b1).^2 / (2 * fit_resultt1.c1^2));
        % Calculate the residuals (the differences between the observed and predicted values)
        residuals = y2 - y_fitt1;
        % Calculate the total sum of squares
        total_sum_squares = sum((y2 - mean(y2)).^2);
        % Calculate the sum of squares of residuals
        sum_squares_residuals = sum(residuals.^2);

        % Calculate the R-square value
        rsquare_valuet1 = 1 - sum_squares_residuals / total_sum_squares;
        
        % Display or use the fitted parameters
        disp(['Fitted value for at1: ', num2str(fit_resultt1.a1)]);
        disp(['Fitted value for bt1: ', num2str(fit_resultt1.b1)]);
        disp(['Fitted value for ct1: ', num2str(fit_resultt1.c1)]);
        disp(['R-square value time: ', num2str(rsquare_valuet1)]);

        % Plot the original data and the first fitted curve
        figure;
        plot(x2, y2, 'o', 'DisplayName', 'Original Data');
        hold on;
        plot(x2, y_fitt1, 'r-', 'DisplayName', 'First Gaussian Fit');
        legend;
        xlabel('Timestep');
        ylabel('Intensity (digit)');
        %title('Gaussian Fit');

        % Save the plot for the first fit
        folder_path4 = 'C:\Users\\';
        filename_first_fit = fullfile(folder_path4, strrep(file_name, '.fit', 'first_gaussian_fit_plot.png'));
        saveas(gcf, filename_first_fit, 'png');
        close(gcf);
        
        % Ensure the folder exists, create it if necessary
        if ~exist(folder_path4, 'dir')
            mkdir(folder_path4);
        end

        % Find the starting and ending points based on the Gaussian parameters
        start_point_y = round(fit_resultt1.b1 - 2 * fit_resultt1.c1); % Adjust factor as needed
        end_point_y = round(fit_resultt1.b1 + 2 * fit_resultt1.c1);   % Adjust factor as needed
            % Ensure that start_point_y does not exceed 1
            if start_point_y <= 1
                start_point_y = 1;
            end
            % % Ensure that start_point_y does not low than 1
            if start_point_y >= 900
                start_point_y = 1;
            end
            % Ensure that end_point_y does not exceed 900
           if end_point_y >= 900
                % Check if file_name is "OSRA"
                if strcmp(strO, 'OSRA')
                    % If file_name is "OSRA" and end_point_yc is >= 900, keep it as is
                    % (no modification needed in this case)
                    end_point_y= round(fit_resultt1.b1 + 2 * fit_resultt1.c1);  
                else
                    % If file_name is not "OSRA", set end_point_yc to 900
                    end_point_y = 900;
                end            
           end
           
            if end_point_y <= 0
                end_point_y = 900;
            end
        
        % Initialize rsquare_value2 before the first if statement
        rsquare_valuet2 =0;
    
        % do the 2nd gaussian fit if R-square is lower than 0.5 and c1 <10
        %  rsquare_valuet1 > 0.1 &&
        if  rsquare_valuet1 < 0.5 && fit_resultt1.c1 < 10
            disp('R-square is lower than 0.5 and standard deviation less than 10 Performing second Gaussian fit.');

            % Initial guess for the parameters for the second fit
            a2_initt = 0.5 * max(y2); 
            % Find the position in y where the value is equal to a2_init
            indices = find(y2 == a2_initt);    
            % Check if indices is not empty before accessing its elements
            if ~isempty(indices)
                % Choose the first occurrence
                b2_initt = indices(1);
            else
                % If indices is empty, find the nearest position with a value
                [~, b2_initt] = min(abs(y2 - a2_initt));
            end
            c2_initt= 1;  % Adjust as needed

            % Create a second Gaussian fit model
            gauss_model2 = fittype('a2 * exp(-(x - b2)^2 / (2 * c2^2))', 'independent', 'x', 'dependent', 'y');

            % Set up the fit options for the second fit
            fit_options2 = fitoptions('Method', 'NonlinearLeastSquares', 'StartPoint', [a2_initt, b2_initt, c2_initt]);
            % Fit the second model to the data
            [fit_resultt2, gof2] = fit(x2, y2, gauss_model2, fit_options2);
            % Calculate the predicted values using the fitted parameters for the second fit
            y_fitt2 = fit_resultt2.a2 * exp(-(x2 - fit_resultt2.b2).^2 / (2 * fit_resultt2.c2^2));

            % Plot the original data and the first and second fitted curves
            figure;
            plot(x2, y2, 'o', 'DisplayName', 'Original Data');
            hold on;
            plot(x2, y_fitt1, 'r-', 'DisplayName', 'First Gaussian Fit');
            plot(x2, y_fitt2, 'g-', 'DisplayName', 'Second Gaussian Fit');
            legend;
            xlabel('x');
            ylabel('y');
            title('Gaussian Fits');
            grid off;

            % Specify the folder where you want to save the Gaussian plot
            folder_path = 'C:\Users\\';
            file_name = strrep(file_name, '.fit', 'second_gaussian_fits.png');  % Adjust the filename as needed
            full_file_path = fullfile(folder_path, file_name);
            % Save the plot
            saveas(gcf, full_file_path);
            % Close the figure
            close(gcf);
            
            % Calculate the residuals (the differences between the observed and predicted values) for the second fit
            residuals2 = y2 - y_fitt2;
            % Calculate the total sum of squares for the second fit
            total_sum_squares2 = sum((y2 - mean(y2)).^2);
            % Calculate the sum of squares of residuals for the second fit
            sum_squares_residuals2 = sum(residuals2.^2);

            % Calculate the R-square value for the second fit
            rsquare_valuet2 = 1 - sum_squares_residuals2 / total_sum_squares2;
            
            disp(['Fitted value for a2: ', num2str(fit_resultt2.a2)]);
            disp(['Fitted value for b2: ', num2str(fit_resultt2.b2)]);
            disp(['Fitted value for c2: ', num2str(fit_resultt2.c2)]);
            disp(['R-square value for the second fit: ', num2str(rsquare_valuet2)]);

           % Check if rsquare_valuec2 is the same as rsquare_valuec1 and fit_resultc2.c2 < 10
            if (rsquare_valuet2 == rsquare_valuet1 && fit_resultt2.c2 < 10)  && (rsquare_valuet2 < 0)
              start_point_y = 1;
              end_point_x = 899;% Set start_point_xc to 1 and end_point_xc to 199
            else
              start_point_y = round(fit_resultt2.b2 - 2 * fit_resultt2.c2); % Adjust factor as needed
              end_point_y = round(fit_resultt2.b2 + 2 * fit_resultt2.c2); 
            end
            
            % Ensure that start_point_y does not exceed 1
            if start_point_y <= 1
                start_point_y = 1;
            end
            % % Ensure that start_point_y does not low than 1
            if start_point_y >= 900
                start_point_y = 1;
            end
            % Ensure that end_point_y does not exceed 900
           if end_point_y >= 900
                % Check if file_name is "OSRA"
                if strcmp(strO, 'OSRA')
                    % If file_name is "OSRA" and end_point_yc is >= 900, keep it as is
                    % (no modification needed in this case)
                    end_point_y= round(fit_resultt1.b1 + 2 * fit_resultt1.c1);  
                else
                    % If file_name is not "OSRA", set end_point_yc to 900
                    end_point_y = 900;
                end            
           end
           
            if end_point_y <= 0
                end_point_y = 900;
            end
            
        end

         %%%%%%%% Calculate the changes in between point in time channel
          totalchangestime=end_point_y-start_point_y;
       
            % this is for write the result totalchangesfrequency  
              % Convert file_name to cell array if it's a character array
                if ischar(file_name)
                    file_name2 = cellstr(file_name);
                end

               % Construct a unique Excel file name based on the original file name
                excel_filename = fullfile('C:\Users\\', 'total_changes_time.xlsx');

               % Check if the Excel file already exists
                if exist(excel_filename, 'file')
                    %Load existing data from the Excel file
                    existing_data = readtable(excel_filename);

                    %Create a new row with file name and total changes frequency
                    new_row = {file_name2,start_point_y,end_point_y,totalchangestime};

                    %Append the new row to the existing data
                    new_data = [existing_data; new_row];

                    %Write the updated data to the Excel file
                    writetable(new_data, excel_filename);
                else
                    %Create a table with file name and total changes frequency
                    data_table = table(file_name2,start_point_y,end_point_y, totalchangestime, 'VariableNames', {'FileName','StartPointY', 'EndPointY', 'TotalChangesTime'});

                    %Write the table to the Excel file
                    writetable(data_table, excel_filename);
                end 
                
      %%%%%%%%%%%%%%%%%%%%%classify 3 & classify 4:concept drift on middle of area burst binary
        
%                 % Use bwlabel to label connected components
%                 labeled_components = bwlabel(data_filt3);
% 
%                 % Display the original image and overlay the boundaries
%                 figure;
%                 imshow(data_filt3); hold on;
% 
%                 % Use regionprops to get properties of connected components, including 'FilledImage'
%                 stats = regionprops(labeled_components, 'Area', 'PixelIdxList');
% 
%                 % Find the indices of the two largest areas
%                 [~, sorted_indices] = sort([stats.Area], 'descend');
%                 top_2_indices = sorted_indices(1:min(2, length(stats)));
% %
%                 % Initialize arrays to store gradient values
%                 gradient_values = zeros(2, min(2, length(stats))); % Initialize as 2x2 array
% 
% 
%                 %Loop over each connected component
%                 for k = 1:length(top_2_indices)
%                     idx = top_2_indices(k);
% 
%                     % Extract pixel indices for the boundary
%                     boundary_indices = stats(idx).PixelIdxList;
% 
%                     % Convert linear indices to subscripts
%                     [rows, cols] = ind2sub(size(data_filt3), boundary_indices);
% 
%                     % Calculate the middle point of the boundary
%                     x_coord = round(mean(cols));
%                     y_coord = round(mean(rows));
% 
%                     % Fit a linear line to the boundary along rows
%                     p_rows = polyfit(rows, cols, 1);
% 
%                     % Calculate the gradient of the line along rows
%                     gradient_rows = p_rows(1);
% 
%                     % Store gradient values 
%                     gradient_values(k, 1) = gradient_rows;
% 
% 
%                     % Display gradient values for each iteration
%                     disp(['Gradient ', num2str(k), ': ', num2str(gradient_rows)]);
% 
%                     % Plot a red dot at the middle point
%                     plot(x_coord, y_coord, 'ro');
% 
%                     % Plot the linear line along rows
%                     plot(polyval(p_rows, rows), rows, 'r', 'LineWidth', 2);
% 
%                     % Display the gradient along rows
%                     text(x_coord, y_coord, sprintf('Gradient: %.2f', gradient_rows), 'Color', 'g');
%                 end
    

% % utk highlight satu gradient shja
% Use bwlabel to label connected components
labeled_components = bwlabel(data_filt3);

% Display the original image and overlay the boundaries
figure;
imshow(data_filt3); hold on;

% Use regionprops to get properties of connected components, including 'FilledImage'
stats = regionprops(labeled_components, 'Area', 'PixelIdxList');

% Find the indices of the two largest areas
[~, sorted_indices] = sort([stats.Area], 'descend');
top_2_indices = sorted_indices(1:min(2, length(stats)));

% Initialize arrays to store gradient values
gradient_values = zeros(2, min(2, length(stats))); % Initialize as 2x2 array

% Loop over each connected component
for k = 1:length(top_2_indices)
    idx = top_2_indices(k);

    % Extract pixel indices for the boundary
    boundary_indices = stats(idx).PixelIdxList;

    % Convert linear indices to subscripts
    [rows, cols] = ind2sub(size(data_filt3), boundary_indices);

    % Calculate the middle point of the boundary
    x_coord = round(mean(cols));
    y_coord = round(mean(rows));

    % Fit a linear line to the boundary along rows
    p_rows = polyfit(rows, cols, 1);

    % Calculate the gradient of the line along rows
    gradient_rows = p_rows(1);

    % Store gradient values 
    gradient_values(k, 1) = gradient_rows;

    % Display gradient values for each iteration
    disp(['Gradient ', num2str(k), ': ', num2str(gradient_rows)]);

    if k == 1
        % Plot a red dot at the middle point for the first component
        plot(x_coord, y_coord, 'ro');

        % Plot the linear line along rows for the first component
        plot(polyval(p_rows, rows), rows, 'r', 'LineWidth', 2);

        % Display the gradient along rows for the first component
        text(x_coord, y_coord, sprintf('Gradient: %.2f', gradient_rows), 'Color', 'g','FontWeight', 'bold');
    end
end


                    % Assign the gradient values to variables in the workspace
                    gr1 = round(gradient_values(1, 1),2); % Gradient value for the first highest area
                    gr2 = round(gradient_values(2, 1),2);

                     % Display the image with marked gradients
                      %title('Image with Marked Gradients on Top 2 Area Components');
                      hold off;



%                 % Convert file_name to cell array if it's a character array
%                 if ischar(file_name)
%                     file_name2 = cellstr(file_name);
%                 end

%                 % Construct a unique text file name based on the original file name
%                 text_filename = fullfile('C:\Users\zulaikhafendy\Documents\MATLAB\Burst 2023\totalchangesdatafilt', 'top_5_indices.txt');
% 
%                 % Open the text file for writing
%                 fid = fopen(text_filename, 'a');
% 
%                 % Check if the file is successfully opened
%                 if fid ~= -1
%                     % Write file name to the text file
%                     fprintf(fid, 'File Name: %s\n', file_name2{1});
% 
%                     % Write top 5 indices and corresponding gradients to the text file
%                     for i = 1:length(top_2_indices)
%                         fprintf(fid, 'Top %d Index: %d, Gradient: %.2f\n', i, top_2_indices(i), gradient_values(i));
%                     end
% 
%                     % Add a separator line for better readability
%                     fprintf(fid, '------------------------\n');
% 
%                     % Close the text file
%                     fclose(fid);
%                 else
%                     % Display an error message if the file cannot be opened
%                     disp('Error: Unable to open the text file for writing.');
%                 end


                % Specify the folder path where you want to save the image
                folder_path = 'C:\Users\\';
                % Specify the file name and format (e.g., 'result_image.png')
                file_name4 = strrep(file_name, '.fit', '_data_binary.png');
                % Combine folder path and file name
                full_file_path4 = fullfile(folder_path, file_name4);
                % Save the figure
                ylabel('Frequency channel');
                xlabel('Timestep');
               saveas(gcf, full_file_path4);
    
end



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %      decision for classify 1(frequency range)
    [cl2_1 cl3_1 cl4_1] = classify1(totalchangesfrequency);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %     decision for classify 2(time range)
     [cl2_2 cl3_2 cl4_2] = classify2(totalchangestime);
     

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    % %    decision for classify 3(gradient 1 based on 1st area)
     [cl2_3 cl3_3 cl4_3] = classify3(gr1);
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %  decision for classify 4(gradient 1 based on 2nd area)
     [cl2_4 cl3_4 cl4_4] = classify4(gr2);


%%%%%%%%%%%%%%%%decision for type burst result%%%%%
     cl_burst2=cl2_1+cl2_2+ cl2_3+ cl2_4;
   
     cl_burst3=cl3_1+cl3_2+ cl3_3+ cl3_4;

     cl_burst4=cl4_1+cl4_2+ cl4_3+ cl4_4;
     

     
%     %%decision for burst result%%%%%
     maxburst=max([cl_burst2, cl_burst3, cl_burst4]); 
     burst2=0;
     burst3=0;
     burst4=0;
     if maxburst == cl_burst2
            burst2=1;
        elseif maxburst == cl_burst3
            burst3=1;
        else
            burst4=1;
     end
    

     
    %%%%%%decision jumlah sama lain
          
% % %             %%(a)burst 2 , burst 3 burst 4
% %             if (cl_burst2 ==1 && cl_burst3 ==1&& cl_burst4==1)               BURST5=1;
% %                 
% %                 
% %             end
% % % 
% %             if (cl_burst2 ==2 && cl_burst3 ==2 && cl_burst4==2)
% %                 
% %             end
% %              
% %             if (cl_burst2 ==3 && cl_burst3 ==3 && cl_burst4==3)
% %  
% %             end
%             
              %%%%%%%% if maxburst is 4%%%%%%%%%
              if maxburst==4
                 %%(a)burst 2 dan burst 3
                 if (cl_burst2 == maxburst && cl_burst3 == maxburst && cl_burst4 == maxburst)
                    if exist('fit_resultct', 'var') && isfield(fit_resultct, 'c1') && fit_resultct.c1 < 10 || ...
                       exist('fit_resultt1', 'var') && isfield(fit_resultt1, 'c1') && fit_resultt1.c1 < 10
                        burst3 = 1;
                        burst2 = 0;
                        burst4 = 0;
                    end
                 end

               %%(a)burst 2 dan burst 4
                 if (cl_burst2 == maxburst && cl_burst4 == maxburst)
                      if (gr1 >0.9) || (gr2 >0.9)
                         burst2 = 1;
                         burst3 = 0;
                         burst4 = 0;
                      end
                  end
                    
                if (burst2==1)&&(burst4==1)
                        gr1 = gradient_values(1, 1);
                      if (gr1 >= 0.0001 && gr1 <= 0.01)
                         burst3 = 1;
                         burst2 = 0;
                         burst4 = 0;
                      else  
                          burst4 = 1;
                          burst2 = 0;
                          burst3 = 0;

                       end
                end
             end
%             
% %             %%(a)burst 3 dan burst 4

              %%%%%%% if maxburst is 3%%%%%%%%%
              if maxburst==3
                 if (cl_burst2 == maxburst && cl_burst3 == maxburst && cl_burst4 == maxburst)
                    if exist('fit_resultct', 'var') && isfield(fit_resultct, 'c1') && fit_resultct.c1 < 10 || ...
                       exist('fit_resultt1', 'var') && isfield(fit_resultt1, 'c1') && fit_resultt1.c1 < 10
                        burst3 = 1;
                        burst2 = 0;
                        burst4 = 0;
                    end
                end

                %%(a)burst 2 dan burst 4
                     if (burst2==1)&&(burst4==1)
                        gr1 = gradient_values(1, 1);
                        if (gr1 >= 0.0001 && gr1 <= 0.01)
                            burst3 = 1;
                            burst2 = 0;
                            burst4 = 0;
                        else 
                            burst4 = 1;
                            burst2 = 0;
                            burst3 = 0;
                        end
                     end
                    
    
                    if (cl_burst2 == maxburst && cl_burst4 == maxburst)
                         if (gr1 >0.9) || (gr2 >0.9)
                                burst2 = 1;
                                burst3 = 0;
                                burst4 = 0;

                         end
                    end
              
                  %(a)burst 3 dan burst 4
  
              end


%         if (burst2==1 && burst5==1)
%             burst2=1;
%             burst5=0;
%         end
% 
%         if (burst3==1 && burst5==1)
%             burst3=1;
%             burst5r=0;
%         end
% 
%         if (burst4==1 && burst5==1)
%             burst4=1;
%             burst5=0;
%         end
%           if (burst5==1)
% 
% 
%          end
    
  
  
 if (burst2==1)    
    disp('positive burst result');
    disp('burst type 2');
    formatSpec='%s&%s&%s&%d&%0.2f&%0.2f&%s';
    a1=newstr(1,1);%nama station,string,char
    a2=newstr(2,1);%date station,string,char             
    a3=newstr(3,1);%time station,string,char
    max2=max(data_filt3,[],2);%max intensity
    a4=max(max2);
    a5='2';
    
    %%indonesia station%%%
    st2='INDONESIA';
    st4='59';
    st5='60';
    st6='61';
    codeindo=newstr(4,1);
    stationlocation=strcmp(strO,st2);
    stationlocation2=strcmp(codeindo,st4);
    stationlocation3=strcmp(codeindo,st5);
    stationlocation4=strcmp(codeindo,st6); 
    if (stationlocation==1)
           if (stationlocation2==1)
             formatSpec1='%s-59&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile1=sprintf(formatSpec1,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst2',newfile1),'formatSpec1');%'*.fit.gz'));
           elseif (stationlocation3==1)
             formatSpec2='%s-60&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile2=sprintf(formatSpec2,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst2',newfile2),'formatSpec2');%'*.fit.gz'));
           
           else
             formatSpec3='%s-61&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile3=sprintf(formatSpec3,a1,a2,a3,a4,0,0);
             save(fullfile('D:','result paper burst 2024','result','burst2',newfile3),'formatSpec3');%'*.fit.gz'));   
           end
    else
    newfile4=sprintf(formatSpec,a1,a2,a3,a4,0,0,a5);
    save(fullfile('D:','result paper burst 2024','result','burst2',newfile4),'formatSpec');%'*.fit.gz'));

    end
 end

 if (burst3==1)
    disp('positive burst result');
    disp('burst type 3');
    formatSpec='%s&%s&%s&%d&%0.2f&%0.2f&%s';
    a1=newstr(1,1);%nama station,string,char
    a2=newstr(2,1);%date station,string,char             
    a3=newstr(3,1);%time station,string,char
    max2=max(data_filt3,[],2);%max intensity
    a4=max(max2);
    a5='3';
    %%indonesia station%%%
    st2='INDONESIA';
    st4='59';
    st5='60';
    st6='61';
    codeindo=newstr(4,1);
    stationlocation=strcmp(strO,st2);
    stationlocation2=strcmp(codeindo,st4);
    stationlocation3=strcmp(codeindo,st5);
    stationlocation4=strcmp(codeindo,st6);
    if (stationlocation==1)
           if (stationlocation2==1)
             formatSpec1='%s-59&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile1=sprintf(formatSpec1,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst3',newfile1),'formatSpec1');%'*.fit.gz'));
           elseif (stationlocation3==1)
             formatSpec2='%s-60&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile2=sprintf(formatSpec2,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst3',newfile2),'formatSpec2');%'*.fit.gz'));
           
           else
             formatSpec3='%s-61&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile3=sprintf(formatSpec3,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst3',newfile3),'formatSpec3');%'*.fit.gz'));   
           end
    else
    newfile4=sprintf(formatSpec,a1,a2,a3,a4,0,0,a5);
    save(fullfile('D:','result paper burst 2024','result','burst3',newfile4),'formatSpec');%'*.fit.gz'));


    end
end
 
 if (burst4==1)
    disp('positive burst result');
    disp('burst type 4');
    formatSpec='%s&%s&%s&%d&%0.2f&%0.2f&%s';
    a1=newstr(1,1);%nama station,string,char
    a2=newstr(2,1);%date station,string,char             
    a3=newstr(3,1);%time station,string,char
    max2=max(data_filt3,[],2);%max intensity
    a4=max(max2);
    a5='4';
    %%indonesia station%%%
    st2='INDONESIA';
    st4='59';
    st5='60';
    st6='61';
    codeindo=newstr(4,1);
    stationlocation=strcmp(strO,st2);
    stationlocation2=strcmp(codeindo,st4);
    stationlocation3=strcmp(codeindo,st5);
    stationlocation4=strcmp(codeindo,st6);
    if (stationlocation==1)
           if (stationlocation2==1)
             formatSpec1='%s-59&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile1=sprintf(formatSpec1,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst4',newfile1),'formatSpec1');%'*.fit.gz'));
           elseif (stationlocation3==1)
             formatSpec2='%s-60&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile2=sprintf(formatSpec2,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst4',newfile2),'formatSpec2');%'*.fit.gz'));
           
           else
             formatSpec3='%s-61&%s&%s&%d&%0.2f&%0.2f&%s';  
             newfile3=sprintf(formatSpec3,a1,a2,a3,a4,0,0,a5);
             save(fullfile('D:','result paper burst 2024','result','burst4',newfile3),'formatSpec3');%'*.fit.gz'));   
           end
    else
    newfile4=sprintf(formatSpec,a1,a2,a3,a4,0,0,a5);
    save(fullfile('D:','result paper burst 2024','result','burst4',newfile4),'formatSpec');%'*.fit.gz'));

    end
 end
 
%  if (burst5==1)
%     disp('positive burst result');
%     disp('burst othertype');
%     formatSpec='%s&%s%s&%d&%0.2f&%0.2f&%s';
%     a1=newstr(1,1);%nama station,string,char
%     a2=newstr(2,1);%date station,string,char             
%     a3=newstr(3,1);%time station,string,char
%     max2=max(data_filt3,[],2);%max intensity
%     a4=max(max2);
%     a5='5';
%     %indonesia station%%%
%     st2='INDONESIA';
%     st4='59';
%     st5='60';
%     st6='61';
%     codeindo=newstr(4,1);
%     stationlocation=strcmp(strO,st2);
%     stationlocation2=strcmp(codeindo,st4);
%     stationlocation3=strcmp(codeindo,st5);
%     stationlocation4=strcmp(codeindo,st6);
%     if (stationlocation==1)
%            if (stationlocation2==1)
%              formatSpec1='%s-59&%s&%s&%d&%0.2f&%0.2f&%s';  
%              newfile1=sprintf(formatSpec1,a1,a2,a3,a4,0,0,a5);
%              save(fullfile('D:','result paper burst 2023','result',newfile1),'formatSpec1');%'*.fit.gz'));
%            elseif (stationlocation3==1)
%              formatSpec2='%s-60&%s&%s&%d&%0.2f&%0.2f&%s';  
%              newfile2=sprintf(formatSpec2,a1,a2,a3,a4,0,0,a5);
%              save(fullfile('D:','result paper burst 2023','result',newfile2),'formatSpec2');%'*.fit.gz'));
%            
%            else
%              formatSpec3='%s-61&%s&%s&%d&%0.2f&%0.2f&%s';  
%              newfile3=sprintf(formatSpec3,a1,a2,a3,a4,0,0,a5);
%              save(fullfile('D:','result paper burst 2023','result',newfile3),'formatSpec3');%'*.fit.gz'));   
%            end
%     else
%     newfile4=sprintf(formatSpec,a1,a2,a3,a4,0,0,a5);
%     save(fullfile('D:','result paper burst 2023','result',newfile4),'formatSpec');%'*.fit.gz'));
% 
%     end
%  end
 
     
 else
   detectburst=0;
   disp('no burst result');
   newfile5=sprintf(formatSpec,a1,a2,a3,0,0);
   mkdir(fullfile('result burst','noburst'));
   save(fullfile('D:','result paper burst 2024','result','noburst',newfile5));
    
end
end






 