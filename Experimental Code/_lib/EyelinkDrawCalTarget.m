function rect=EyelinkDrawCalTarget(el, x, y)

% draw simple calibration target
%
% USAGE: rect=EyelinkDrawCalTarget(el, x, y)
%
%		el: eyelink default values
%		x,y: position at which it should be drawn
%		rect: 

% simple, standard eyelink version
%   22-06-06    fwc OSX-ed

size=el.calibrationtargetsize;
inset=el.calibrationtargetwidth;
% 
% Screen('DrawDots', el.window, [x y], size, el.foregroundcolour, [], 1);
% Screen('DrawDots', el.window, [x y], inset, el.backgroundcolour, [], 1);
% 
rect=CenterRectOnPoint([0 0 size size], x, y);
% % Screen( 'FillOval', el.window, el.foregroundcolour,  rect );
% % rect=CenterRectOnPoint([0 0 inset inset], x, y);
% % Screen( 'FillOval', el.window, el.backgroundcolour, rect );
exp_target_draw(el.window,x,y,size,inset,el.foregroundcolour,el.backgroundcolour);
Screen( 'Flip',  el.window);
