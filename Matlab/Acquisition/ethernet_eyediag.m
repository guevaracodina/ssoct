clear all; %close all;
disp('reading...');
fid = fopen('test.txt', 'r'); % open the file
data = fscanf(fid, '%2X');
fclose(fid);

disp('plotting...');
lp = 100; 
data = data - mean(data); % remove DC
times = 1000; 
eyediagram(data(1:lp*times), lp, lp); 



  




