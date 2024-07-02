
epar.save_path=('./data/'); 
epar.running_path=('.');
epar.exp_path=sprintf('%s/e%dv%db%d', epar.save_path, epar.experiment, epar.subject, epar.block');
if exist(epar.exp_path)==7
    error('Directory already exists! Please check experiment, subject and block number!')
else
    mkdir ([epar.exp_path]);
end
epar.log_file=sprintf('%s/e%dv%db%d.log', epar.exp_path, epar.experiment, epar.subject, epar.block);

%% Eyelink settings
epar.SAMP_FREQ = 1000;
epar.CALIB_TRIALS = 180;
epar.CALIB_X = 10;
epar.CALIB_Y = 10;

%% Screen settings
epar.GAMMA = 0; %1: Gamma correction; 0: No correction
epar.GAMMA_TABLE ='C:\SRC\lut\VIEWPixx_sbloff';
epar.EXPNAME='StepRamp';

epar.MONITOR_FREQ = 120;
epar.SCREEN_X_PIX = 1920;
epar.SCREEN_Y_PIX = 1080;
epar.screen_x_cm  = 70;
epar.screen_y_cm  = 39.5;
epar.vp_dist_cm   = 85.0;

epar.x_center=epar.SCREEN_X_PIX/2;
epar.y_center=epar.SCREEN_Y_PIX/2;
epar.XPIX2DEG = atand ((epar.screen_x_cm / epar.SCREEN_X_PIX) / epar.vp_dist_cm);
epar.YPIX2DEG = atand ((epar.screen_y_cm / epar.SCREEN_Y_PIX) / epar.vp_dist_cm);

%% Fixation settings
epar.fixsize = round([0.5 0.6]./epar.XPIX2DEG); % [0.15 0.6]
epar.fix_min = 1;
epar.fix_max = 1.5;
epar.fix_tol = 2;
