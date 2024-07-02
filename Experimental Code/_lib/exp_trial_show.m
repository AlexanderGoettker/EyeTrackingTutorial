function epar = exp_trial_show( epar, el, tn, demo)

Priority(2);
for f=1:epar.end_frame % This is the loop through the frames
    
    %% Check that the gaze is at fixation when target is not moving
    if f < epar.step_frame
        if epar.EL % If you are using the eye link
            [x y] =  exp_el_eye_pos( el ); % get the eye position
            Distance_Center = sqrt((x-epar.x_center).^2 +(y-epar.y_center).^2); % Compute the distance
            
            if Distance_Center > 2/epar.XPIX2DEG % If the Distance is larger than 2 deg
                tstring = (['Fixate on the central Target']); % Show a message
                [nx, ny, bbox] = DrawFormattedText(epar.window, tstring, 'center', 700, [0 0 0]);
                Screen('Flip', epar.window);
                WaitSecs(1);
                break % Break out of the trial
            end
            
        end
    end
    
    %% Movement of the stimulus
    if f>=epar.step_frame % If you are beyond the frame it should start to move
        if f==epar.step_frame
            epar.gabor.xp = epar.gabor.xp+epar.gabor.xs; % Add the position step at the moment of target movement onset
            epar.gabor.yp = epar.gabor.yp+epar.gabor.ys;
        else
            epar.gabor.xp = epar.gabor.xp+epar.gabor.xm; % Add the movement for the other frames
            epar.gabor.yp = epar.gabor.yp+epar.gabor.ym;
        end
    end
    
    if epar.Stimulus % If you want the Gaussian, take the created mask
        rect = CenterRectOnPoint(epar.gabor.rect, epar.gabor.xp+epar.x_center, epar.gabor.yp+epar.y_center);
        Screen('DrawTexture', epar.window, epar.gabor.id, [], rect);
    else % If you want the circle
        Size_of_Dot = 1; % Size of the Dot
        epar.dot_size = [0 0 Size_of_Dot/epar.XPIX2DEG Size_of_Dot/epar.XPIX2DEG]; % Get the rect
        epar.dot_rect = CenterRectOnPoint(epar.dot_size,epar.gabor.xp+epar.x_center,epar.gabor.yp+epar.y_center); %Get the correct position
        Screen('FillOval',epar.window,[1 0 0],epar.dot_rect);
    end
    
    Screen('DrawingFinished', epar.window);
    Screen('Flip', epar.window);
    
    if epar.EL && f==epar.step_frame % Send message to eyelink at movement onset
        Eyelink('Message','Movement_start');
    end
end

Screen( 'Flip',  epar.window);

if epar.EL % End the trial and send message
    Eyelink('Message','TRIAL_END');
end;
Priority(1);

