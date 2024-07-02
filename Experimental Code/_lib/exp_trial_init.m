function [ epar el] = exp_trial_init( epar, el, tn )
%EXP_TRIAL_INIT Summary of this function goes here
%   Detailed explanation goes here

epar.eye_name = sprintf('%s//trial%d.dat',epar.exp_path, tn);

% timing --> Moment of the movement onset as well as the movement duration
epar.step_frame = round((epar.fix_min+rand(1,1).*(epar.fix_max-epar.fix_min)).*epar.MONITOR_FREQ);
epar.end_frame = round(epar.step_frame + (epar.motion_duration+epar.step).*epar.MONITOR_FREQ);

% motion of the target --> Compute the shift per frame
epar.gabor.xm = epar.trial.speed(tn).*cos(epar.trial.motion_dir(tn)./180.*pi)./epar.MONITOR_FREQ./epar.XPIX2DEG;
epar.gabor.ym = epar.trial.speed(tn).*sin(epar.trial.motion_dir(tn)./180.*pi)./epar.MONITOR_FREQ./epar.XPIX2DEG;

%Position step
epar.gabor.xs = epar.gabor.xm.*-1.*(epar.step.*epar.MONITOR_FREQ);
epar.gabor.ys = epar.gabor.ym.*-1.*(epar.step.*epar.MONITOR_FREQ);

%% Create the Gaussian blob
% get the distance to the center
epar.gabor.size = 256;
x(1,:) =(1:epar.gabor.size)-epar.gabor.size/2;
x = repmat(x,[epar.gabor.size 1]);
y = x';
x = x.*epar.XPIX2DEG;
y = y.*epar.YPIX2DEG;
r = hypot(x,y);
% If you have a spatial frequency in mind, add that
epar.gabor.phase = rand(1,1);
if epar.gabor.sf==0
    sin_data = ones(size(x));
else
    sin_data = cos(2.*pi.*((x.*cos(epar.gabor.orient)+y.*sin(epar.gabor.orient)+epar.gabor.phase).*epar.gabor.sf));
end

% Create the gabor
gauss_data = exp(-0.5 .* ((r - 0)./epar.gabor.sd).^epar.gabor.exponent) ./ (sqrt(2*pi) .* epar.gabor.sd);
gauss_data = gauss_data./max(gauss_data(:)).*0.5.*epar.gabor.contrast;

% Combine them into one texture
gabor_data = (sin_data.*gauss_data)+0.5;
epar.gabor.id = Screen('MakeTexture',epar.window,gabor_data,[],[],1);
epar.gabor.rect = [0 0 epar.gabor.size epar.gabor.size];

%% Set the starting position of the stimulus

epar.gabor.xp = 0; 
epar.gabor.yp = 0;
