function [ ex ey ] = exp_el_eye_pos( el )
%EXP_EL_EYE_POS Summary of this function goes here
%   Detailed explanation goes here

ex = NaN;
ey = NaN;

eye_used = Eyelink('EyeAvailable'); % get eye that's tracked
if eye_used == el.BINOCULAR; % if both eyes are tracked
    eye_used = el.LEFT_EYE; % use left eye
end

if Eyelink( 'NewFloatSampleAvailable') > 0
    % get the sample in the form of an event structure
    evt = Eyelink( 'NewestFloatSample');
    if eye_used ~= -1 % do we know which eye to use yet?
        % if we do, get current gaze position from sample
        x = evt.gx(eye_used+1); % +1 as we're accessing MATLAB array
        y = evt.gy(eye_used+1);
        % do we have valid data and is the pupil visible?
        if x~=el.MISSING_DATA & y~=el.MISSING_DATA & evt.pa(eye_used+1)>0
            ex=x;
            ey=y;
        end
    end
end
