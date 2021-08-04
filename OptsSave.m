function OptsSave( opts )

opts.Code.UpdateTimeStamp = clock;
save('opts.mat','opts');