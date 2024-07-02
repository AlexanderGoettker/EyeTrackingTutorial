clear all; close all; clc;
addpath('_lib');
addpath('edf-converter-master');

%% INIT EXPERIMENT
rand('twister',sum(100*clock));
epar.experiment=input('Experiment:');
epar.subject=input('Subject:');
epar.block=input('Block:');

%%%%%
% When running script, Experiment should be 1, all other things can be random

%% Here you can set some general Settings
epar.StepRamp = 1; % If you want Step-Ramp set to 1, otherwise to 0
epar.Stimulus = 1; % If Stimulus is 0 --> Circle, if it will be a Gaussian blob
epar.EL = 1;    %1: Eyelink active; 0: No eyelink
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Adjust  to fit to experimental settings
exp_settings; % Settings of the monitor and toggle for activating the Eyelink, for now Eyelink is set to 0
epar.path = 'C:\Users\exp\Desktop\EyeTrackingDemo\'; % Path to Experimental Folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


try
    
    %% INIT DISPLAY
    epar = exp_mon_init(epar); % Open Psychtoolbox screen, Allows for Gamma Correction etc, can be ignored for now
    %% Init Experiment
    
    exp_setparam % Define trial conditions like movement speed etc.
    
    exp_instruction(epar,epar.experiment); % Display a instruction at the beginning of the experiment
    
    %% INIT EYELINK
    if epar.EL
        el = exp_el_init(epar);% Function to start the eyelink
    else
        el = NaN;
    end
    
    %% CALIBRATE EYELINK
    if epar.EL
        result=EyelinkDoTrackerSetup(el);  % Calibration --> This is using the Eyelink Psychtoolbox functions
        if result==el.TERMINATE_KEY
            return;
        end;
        Eyelink('message', 'Block_Start');
        Eyelink('WaitForModeReady', 500);
    end
    
    %% EXP
    for t=1:epar.trial.num % Loop through the trials
        
        %Prepare content --> Here you compute the velocity steps, define the
        %starting position, etc
        epar = exp_trial_init (epar,el,t);
        
        % Check EyeLink adn do drift check
        
        if epar.EL
            exp_el_start( el, t, epar.x_center, epar.y_center);
        end
        
        % Present things
        epar = exp_trial_show(epar,el);
        
        if epar.EL % Set eyelink offline for intertrial interval
            WaitSecs(0.1);
            Eyelink('StopRecording');
            error = Eyelink('CheckRecording');
            fprintf('Stop Recording: %d; ',error);
            Eyelink('SetOfflineMode');
        end
        
        % Save the trial information into the logfile
        exp_trial_save(epar,t);
        
    end % End of trial loop
    
    %% FINISH
    if epar.EL
        exp_el_exit(epar); % Get the Edf file from the Eyelink
    end
    
    % resetGamma
    exp_mon_exit(epar);
    
%     ReadoutTrials % This scripts readsout the edf files, using the edf
%     converter toolbox
    
catch e
    sca
    rethrow(e)
    
end