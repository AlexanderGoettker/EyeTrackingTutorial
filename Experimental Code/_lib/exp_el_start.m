function exp_el_start( el, t, x, y )
%EXP_EL_START Summary of this function goes here
%   Detailed explanation goes here

%% Drift Correction Code
Eyelink('command','set_idle_mode');
WaitSecs(0.05);
drift_success = EyelinkDoDriftCorrection(el, x, y, 1, 1);
if drift_success ~= 1
    disp(drift_success);
end
Eyelink('command','set_idle_mode');
WaitSecs(0.05);
Eyelink('StartRecording');



%% Send message of the start of the trial
Eyelink('command','mark_playback_start');
Eyelink('message', ['TrialID' sprintf('%d',t)]);
WaitSecs(0.1);