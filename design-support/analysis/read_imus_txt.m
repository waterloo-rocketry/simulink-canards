% Define the file path
filename = 'design-support/analysis/imus.txt';  % Change this
fid = fopen(filename, 'r');

% Initialize storage
movellaCells = {};
pololuCells = {};

% Initialize unique field tracking
movellaFieldSet = ["timestamp"];
pololuFieldSet = ["timestamp"];

% Initialize empty values (dynamic sized)
currentMovella = nan(1, 1);  % start with timestamp slot
currentPololu = nan(1, 1);


while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line), continue; end
    
    % Fast check for new block
    if line(1) == '['
        % Save previous
        if ~isnan(currentMovella(1))
            movellaCells{end+1,1} = currentMovella; % #ok<AGROW>
            currentMovella(:) = nan;
        end
        if ~isnan(currentPololu(1))
            pololuCells{end+1,1} = currentPololu; % #ok<AGROW>
            currentPololu(:) = nan;
        end
        
        % Parse timestamp and sensor
        C = textscan(line, '[%f] %s (type %d)', 'Delimiter', '', 'MultipleDelimsAsOne', true);
        timestamp = C{1};
        sensor = string(C{2});
        
        if sensor == "movella"
            currentMovella(1) = timestamp;
        elseif sensor == "pololu"
            currentPololu(1) = timestamp;
        end
       elseif contains(line, ':')
        kv = split(line, ':');
        key = strtrim(kv{1});
        valStr = strtrim(kv{2});
        
        % Convert value
        if strcmpi(valStr, 'True')
            val = 1;
        elseif strcmpi(valStr, 'False')
            val = 0;
        else
            val = str2double(valStr);
        end
        
        % Fill into current
        if startsWith(key, 'movella')
            idx = find(movellaFieldSet == key, 1);
            if isempty(idx)
                movellaFieldSet(end+1) = key;
                currentMovella(end+1) = nan;
                idx = numel(currentMovella);
            end
            currentMovella(idx) = val;
        elseif startsWith(key, 'polulu')
            idx = find(pololuFieldSet == key, 1);
            if isempty(idx)
                pololuFieldSet(end+1) = key;
                currentPololu(end+1) = nan;
                idx = numel(currentPololu);
            end
            currentPololu(idx) = val;
        end
    end
end
fclose(fid);

% Save last block
if ~isnan(currentMovella(1))
    movellaCells{end+1,1} = currentMovella;
end
if ~isnan(currentPololu(1))
    pololuCells{end+1,1} = currentPololu;
end

% Convert movella
movellaMat = cell2mat(movellaCells);
movellaFields = movellaFieldSet;
movellaTable = array2table(movellaMat, 'VariableNames', movellaFields);

% Convert pololu
pololuMat = cell2mat(pololuCells);
pololuFields = pololuFieldSet;
pololuTable = array2table(pololuMat, 'VariableNames', pololuFields);

% Fix logical columns
if any(contains(movellaFields, 'is_dead'))
    movellaTable.movella_is_dead = movellaTable.movella_is_dead > 0.5;
end
if any(contains(pololuFields, 'is_dead'))
    pololuTable.pololu_is_dead = pololuTable.pololu_is_dead > 0.5;
end

disp('Done loading large file.');


% === Synchronize ===
movellaTT = table2timetable(movellaTable, 'RowTimes', seconds(movellaTable.timestamp));
pololuTT = table2timetable(pololuTable, 'RowTimes', seconds(pololuTable.timestamp));

syncedTT = synchronize(movellaTT, pololuTT, 'union', 'linear');

disp('Done synchronizing tables.');

% === Quick plot check ===
figure;
plot(syncedTT.Time, syncedTT.movella_acc_x, 'DisplayName', 'Movella');
hold on;
plot(syncedTT.Time, syncedTT.polulu_acc_x, 'DisplayName', 'Pololu');
legend; grid on;
title('Large File: Acceleration X');
