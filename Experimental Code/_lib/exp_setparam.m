%returns settings of experiment in struct epar


%% independent variables
epar.motion_dir = [0 180]; % Target direction in angle, 0 is to the right, 90 up, 180 to the left
epar.repetitions = 1;
epar.speed = [6 14]; % target Speed in deg/s

% Step is here if you want Rashbass paradigm with step-ramp
% if you dont want step, set it 0
if epar.StepRamp
epar.step = [0.2]; % Time target needs till it crosses initial fixation in s
else 
epar.step = [0]; % Time target needs till it crosses initial fixation in s
end

%% constants for blob stimulus

epar.gabor_orient = [0];
epar.trial.demo = 3;
epar.gabor.sf = 0;
epar.gabor.sd = 0.4; %% Groesse veraendern 
epar.gabor.contrast = 0.7;  % original = 0.5 %% Maximal 1 
epar.gabor.exponent = 4; % 2: standard gauss; 4: sharper edges


epar.motion_duration = 1; % Length of motion in frames 

%% create trial array
[epar.trial.motion_dir epar.trial.speed] = BalanceFactors(epar.repetitions,1,epar.motion_dir,epar.speed);
epar.trial.num = length(epar.trial.motion_dir);

cd(epar.path)

