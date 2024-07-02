%% Specify the name of the edf-file
Screen('FillRect',epar.window,epar.gray)
Screen('TextSize', epar.window, 80);
Screen('TextFont', epar.window, 'Courier');
DrawFormattedText(epar.window, 'Block finished... Converting Data', 'center', 'center', epar.red);
Screen('Flip',epar.window)
% Define the path where you can find the data 
path = [epar.path,'data\'];

Name = ['e',num2str(epar.experiment),'v',num2str(epar.subject),'b',num2str(epar.block)]; % Name of the block 

% load the file 
cd(path)
Data= Edf2Mat([Name,'.edf']);
cd([path,Name])


%%%%%%%%%%%%%%%%%%%%%%%%%
%% Look up the events 
%%%%%%%%%%%%%%%%%%%%%%%%%

% Align the timing with the sampling frequency 

for aa = 1: length(Data.Events.Messages.time)
    if mod(Data.Events.Messages.time(aa),2) % If the timing is at an unequal number it does not match with the 500 hz sampling 
        Timing(aa)= Data.Events.Messages.time(aa)-1;
    else
        Timing(aa)= Data.Events.Messages.time(aa);
    end
end

% Find the messages that signal the start and end of the trial 
for aa = 1:size(Data.Events.Messages.info,2)
    Begin_v(aa) =strncmp(Data.Events.Messages.info{aa} , 'TrialID',6);
    if isempty(strfind(Data.Events.Messages.info{aa} , 'TRIAL_END'))
        End_v (aa) =0;     
    else
        End_v (aa) =1;
    end
       
end

% Get the time of the start and end of the trial
Begin = Timing(Begin_v); 
End = Timing(find(End_v==1));


%% Now create the files for each trial 

for t = 1: length(Begin)
    
    comb = find(Data.Samples.time >= Begin(t) &  Data.Samples.time <= End(t)); % Define the duration of one trial 
    trial(:,1) = Data.Samples.time(comb); % Get the timestamps
    trial(:,2) = Data.Samples.gx(comb,1); % Get the x eye position of the left eye
    trial(:,3) = Data.Samples.gy(comb,1);  % Get the y eye position of the right eye
    trial(:,4) = zeros(size(trial,1),1); % initialize the column which will indicate events 
    trial(:,5) = Data.Samples.gx(comb,2);% Get the x eye position of the right eye
    trial(:,6) = Data.Samples.gy(comb,2);% Get the y eye position of the right eye
    trial(:,8) = Data.Samples.pupilSize(comb);% Get the pupil size
    % Look for events that you can mark in the fourth colum
    
    event= find(Timing>=trial(1,1) & Timing<=trial(end,1));
    Time_Event= Timing(event); % Find the events that happened during the trial 
    for num_event = 1: length(event)
        Time = find(trial(:,1)== Time_Event(num_event));
        if isempty(Time)
            
        else
            assign_event(num_event) = Time;
        end
    end
   
    trial(assign_event,4) =1; % Mark an event that you have found earlier
    
    % Look up the saccades or detect them yourself in the analysis
  
    All_Sacc= find(Data.Events.Esacc.start>=trial(1,1) & Data.Events.Esacc.start<=trial(end,1));  % Get the saccade events from the file 
    All_Blink = find(Data.Events.Eblink.start>=trial(1,1) & Data.Events.Eblink.start<=trial(end,1));
    label_blink= zeros(size(trial,1),1); 
    label= zeros(size(trial,1),1); 
    for aa = 1:length(All_Sacc)        
        comb= find(trial(:,1) >= Data.Events.Esacc.start(All_Sacc(aa))& trial(:,1) <=Data.Events.Esacc.end(All_Sacc(aa)));
        label(comb) =1;        
    end
     for aa = 1:length(All_Blink)        
        comb= find(trial(:,1) >= Data.Events.Eblink.start(All_Blink(aa))& trial(:,1) <=Data.Events.Eblink.end(All_Blink(aa)));
        label_blink(comb) =1;        
     end
    
     trial(:,7) = label; % Assign the saccades to the last column
     trial(:,9) = label_blink;% Get the blinks

    % Reset the time
    trial(:,1) = trial(:,1)-trial(1,1);
    
    save(['trial',num2str(t)],'trial')
    
    clear trial
end

cd(epar.path)