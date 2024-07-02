function exp_target_draw(w, x, y, dl, ds, fg, bg)

ds =6; 
Screen('FillOval', w, fg, [x-dl/2, y-dl/2, x+dl/2, y+dl/2], dl);
Screen('DrawLine', w, bg, x-dl/2, y, x+dl/2, y, ds);
Screen('DrawLine', w, bg, x, y-dl/2, x, y+dl/2, ds);
Screen('FillOval', w, fg, [x-ds/2, y-ds/2, x+ds/2, y+ds/2], ds);
