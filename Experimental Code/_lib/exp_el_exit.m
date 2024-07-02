function [ ] = exp_el_exit( epar )
%EXP_EXIT_EL Summary of this function goes here
%   Detailed explanation goes here

    Eyelink('message', 'Block_End');
    Eyelink('CloseFile');
    Eyelink('ReceiveFile', [], epar.save_path, 1);
    Eyelink('Shutdown');
end
