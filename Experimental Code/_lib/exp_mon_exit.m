function [ ] = exp_mon_exit( epar )
%EXP_EXIT_MON Summary of this function goes here
%   Detailed explanation goes here
%SoundVolume('Realtek','speaker',epar.oldVolume)
if epar.GAMMA
    Screen('LoadNormalizedGammaTable',epar.window,epar.oldGamma);
end
Screen('Close',epar.window);
ShowCursor;

