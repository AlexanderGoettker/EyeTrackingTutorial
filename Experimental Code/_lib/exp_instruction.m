function exp_instruction( epar,exp )
%EXP_INSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

Screen('FillRect', epar.window, epar.gray);
if exp
    expString = 'Experiment';
else
    expString = 'Demonstration';
end
fid = fopen(sprintf('exp_instruction_%d.txt',epar.experiment), 'rb');
instruction = fread(fid, [1, inf], 'char');
instruction = char(instruction);
fclose(fid);
DrawFormattedText(epar.window,sprintf('%s\nExperiment: %d\nVersuchsperson: %d\nBlock: %d\n\n%s\n\nWeiter mit Leertaste.',expString,epar.experiment,epar.subject,epar.block,instruction),'center','center',epar.black,80,[],[],1.75);
Screen('Flip', epar.window);
while 1
    [secs, keyCode] = KbWait([],2);
    if keyCode(KbName('space'))
        break;
    end
end
Screen('FillRect', epar.window, epar.gray);
Screen('Flip', epar.window);