function [ epar ] = exp_mon_init( epar )

if epar.GAMMA
    if ~isempty(strfind(epar.GAMMA_TABLE,'sbloff'))
        PsychDataPixx('Open');
        PsychDataPixx('DisableVideoScanningBacklight');
        PsychDataPixx('Close');
    elseif ~isempty(strfind(epar.GAMMA_TABLE,'sblon'))
        PsychDataPixx('Open');
        PsychDataPixx('EnableVideoScanningBacklight');
        PsychDataPixx('Close');
    end
end
screenNumber=max(Screen('Screens'));
[epar.window epar.screenRect]=Screen('OpenWindow', screenNumber, 0);
Screen('Preference', 'SkipSyncTests', 1);
%PsychImaging('PrepareConfiguration');
%PsychImaging('AddTask', 'General', 'FloatingPoint16Bit');
%[epar.window epar.screenRect] = PsychImaging('OpenWindow', screenNumber, 128);
Screen('ColorRange', epar.window, 1);
epar.gray=GrayIndex(screenNumber, 0.5);
epar.black=BlackIndex(screenNumber);
epar.white=WhiteIndex(screenNumber);
epar.red=[255 0 0];
Screen('TextFont', epar.window, 'Arial');
Screen('TextSize', epar.window, 12);
%epar.oldVolume = SoundVolume('Realtek','speaker');
%SoundVolume('Realtek','speaker',epar.vol);
if epar.GAMMA
    initmon(epar.GAMMA_TABLE);
    newGamma(:,1) = dlmread([epar.GAMMA_TABLE '.r']);
    newGamma(:,2) = dlmread([epar.GAMMA_TABLE '.g']);
    newGamma(:,3) = dlmread([epar.GAMMA_TABLE '.b']);
    epar.newGamma = newGamma./255;
    epar.oldGamma = Screen('LoadNormalizedGammaTable',epar.window,epar.newGamma);
else
    epar.newGamma = NaN;
    epar.oldGamma = NaN;
end
HideCursor;