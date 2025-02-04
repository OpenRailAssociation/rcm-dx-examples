%% Load_rcmdx_fromConfig
%  Load RCM-DX file in matlab from a configuration.
%
%% Syntax
%  data = load_rcmdx_fromConfig(filename)
%  [data, config] = load_rcmdx_fromConfig(filename)
%  [data, config] = load_rcmdx_fromConfig(filename, 'optionNameX', optionValueX)
%  data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx','myPath\myConfig.csv')
%  data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', config)
%  data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', '.\load_rcmdx_fromConfig.csv')
%  [~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
% 
%  Please refer to examples, input and output arguments sections for more
%  informations about how to use this function.
%
%% Description
%  Load_rcmdx_fromConfig load the data and metadata of a RCM-DX file in
%  matlab. 
% 
%  By default the function read the whole content of the RCM-DX file. 
%  For example: data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
% 
%  It is possible to ouput a configuration (config) as table or as
%  csv-file. By editing this config and passing it as option input, it is
%  possible to read only certain data and/or metadata of a RCM-DX file.
%  This can be usefull to access the data you really need and so improve
%  the performance.
% 
%  Read the whole RCM-DX file and output only the config without data
%  (output example: [~, config]) is really useful if you are not
%  familiarized with RCM-DX structure. It allows to know the strucutre,
%  generate a config and then access the needed data. To avoid reading data 
%  and metadata, which want be time consuming, use the option
%  processConfigOnly.
%  For example: [~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
% 
%  Please refer to examples section for more informations about how to use
%  this function.
% 
%  For more info about RCM-DX format, please refer to the format
%  specification available open source on
%  https://github.com/OpenRailAssociation/rcm-dx/blob/main/RCM-DX-Specification_EN.md
%
%% Examples
%  Example 1 without options. Options are not mandatory.
%       Read everything in RCM-DX file
%           data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
%
%  Example 2 without options. Options are not mandatory.
%       Return only config as matlab table.
%           [~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
%       data is readen inside the function, which can be time consuming.
%       Used instead: 
%           [~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
%
%  Example 3 without options. Options are not mandatory.
%       Return only config as matlab table and read everything in RCM-DX file
%           [data, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
%
%  Example 4 with 'config' option.
%       Read only parts of RCM-DX file defined in config, where config is
%       matlab table.
%           data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', config)
%
%       Read only parts of RCM-DX file defined by 'config', where the value
%       of the option is a table written in the argument of the function
%       itself.
%           data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', table("a","a","a","/RCMDX",'variableNames',["Data", "Attributes", "ObjectInfo", "LevelName"]))
%       In this example 'variableNames',["Data", "Attributes",
%       "ObjectInfo", "LevelName"] is the definition of name of the table
%       column (header). Those names can not be changed.
%       "a","a","a","/RCMDX" are the values of the table. Here the table
%       has only one row at looks like that with its header:
%                Column 1 | Column 2     | Column 3     | Column 4
%       Header : "Data"   | "Attributes" | "ObjectInfo" | "LevelName"
%       Row 1  : "a"      | "a"          | "a"          | "/RCMDX"
% 
%       Read only parts of RCM-DX file defined by 'config', where the value
%       of the option is a table.
%           config = array2table(...
%              ["","x","","/RCMDX/[PLATFORM]/[SESSION_NAME]"; ...
%              "x","","","/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/timestamp"; ...
%              "x","","","/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id"; ...
%              "x","","","/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset"], ...
%              'variableNames',["Data", "Attributes", "ObjectInfo", "LevelName"]);
%           data = load_rcmdx_fromConfig(filename.rcmdxFile.File(incrFile),'config',config);
%       In this example 'variableNames',["Data", "Attributes",
%       "ObjectInfo", "LevelName"] is the definition of name of the table
%       column (header). Those names can not be changed.
%       Here the table has only one row at looks like that with its header:
%                Column 1 | Column 2     | Column 3     | Column 4
%       Header : "Data"   | "Attributes" | "ObjectInfo" | "LevelName"
%       Row 1  : ""       | "x"          | ""           | "/RCMDX/[PLATFORM]/[SESSION_NAME]"
%       Row 2  : "x"       | ""          | ""           | "/POSITION/POSITION.SOURCE/timestamp"
%       Row 3  : "x"       | ""          | ""           | "/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id"
%       Row 4  : "x"       | ""          | ""           | "/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset"
%
%       Read only parts of RCM-DX file defined by 'config', where the value
%       of the option is a csv file.
%           data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', '.\load_rcmdx_fromConfig.csv')
%       the csv file contains the config table with the first line as
%       header. For example: 
%       Data,Attributes,ObjectInfo,LevelName
%        ,x, ,/RCMDX/[PLATFORM]/[SESSION_NAME]
%       x, , ,/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/timestamp
%       x, , ,/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id
%       x, , ,/RCMDX/[PLATFORM]/[SESSION_NAME]/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset
%
%
%% Input Arguments
%  filename: Name of hdf5 file with path and extension (.rcmdx).
%
%  Options:
%   Options are not mandatory. The order of the options in the function is
%   not relevant. Default value is defined between brackets [] here below.
%   To use an option, write the option name and value in the function. 
%   For ex. 'optionName', optionValue 
%   The optionName is not case sensitive.
%   data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'optionName1', optionValue1, 'optionName2', optionValue2, 'optionName3', optionValue3)
%
%   'config':
%       argument of option 'config' is a csv-file (with "," or ";" as separator)
%       or a table with 4 columns (columnsname are Data, Attributes, ObjectInfo, LevelName)
%       where Data, Attributes, ObjectInfo are filled with [x], [a] or
%       nothing (for ex. [ ]).
%       [x] stays for read the corresponding element of LevelName. See example load_rcmdx_fromConfig.csv
%       [a] stays for read the corresponding element of LevelName and
%       every subelement. See example load_rcmdx_fromConfig.csv. For
%       ex. [a,a,a,/RCMDX] read the whole RCM-DX file.
%       load_rcmdx_fromConfig.csv is delivered as example with this
%       function. 
%       Here a description of the 4 columns:
%       1. Data are corresponding to values stored in RCM-DX file. For
%          example measurment values.
%       2. Attributes are the metadata of the Data.
%       3. ObjectInfo are an other type of metadata of the Data. For
%          example it could contain the size of the Data.
%       4. LevelName is the path of the Data in RCM-DX file.
%       For more info about RCM-DX format please refer to the format
%       specification available open source on
%       https://github.com/OpenRailAssociation/rcm-dx/blob/main/RCM-DX-Specification_EN.md
%
%   'processConfigOnly':
%       The function has two outputs [data, config]. The computing of data
%       can be time consuming. This option allows to reduce the computing
%       time by processing only config.
%       ['off'] - process data and config, even if the outputs are 
%                 [~, config].  Time consuming.   
%       'on'    - process only config. data is not processed. 
%                 For ex.: [~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
%                 If data is put in output, data only contains info.
%                 For ex.: [data, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
% 
%   'configLevelNameUsed': change the fieldnames of the output data structure
%       You can choose to outut the RCM-DX in a similar structure as in
%       RCMDX by using 'longreal'. 'shortreal' remove the replication to
%       improve readability. 'longabst' and 'shortabst' do the same thing
%       but used abstracted fieldnames for PLATFORM and SESSION_NAME
%       instead the real fieldnames, to make the structure more generical.
%       ['shortabst'] - short fieldnames abstracted (remove replication)
%                       Only PLATFORM and SESSION_NAME is abstracted.
%                       for ex. RCMDX.PLATFORM.SESSION_NAME.OLWMS.OLPAR_103.WIRE01_HEIGHT
%       'longabst'    - long fieldnames abstracted
%                       Only PLATFORM and SESSION_NAME is abstracted.
%                       for ex. RCMDX.PLATFORM.SESSION_NAME.PLATFORM_OLWMS.PLATFORM_OLWMS_OLPAR_103.PLATFORM_OLWMS_OLPAR_103_WIRE01_HEIGHT
%       'shortreal'   - short fieldnames real (remove replication)
%                       for ex. RCMDX.DFZ00.20240911_102800.000.OLWMS.OLPAR_103.WIRE01_HEIGHT
%       'longreal'    - long fieldnames real
%                       for ex. RCMDX.DFZ00.20240911_102800.000.DFZ00_OLWMS.DFZ00_OLWMS_OLPAR_103.DFZ00_OLWMS_OLPAR_103_WIRE01_HEIGHT
%
%   'mergeToTable':
%       ['on'] - merge data as Datasource, EVENTS SECTIONS,
%       POSITION_SOURCE, AVAILABILITY, CONSISTENCY, MEASUREMENTMODE, etc.
%       into table for better readability.
%       'off'  - do nothing. Keep the same strucutre as in RCM-DX file
%
%   'warning':
%       warning messages are displayed when the function try to read
%       unexisting data or metadata. This happens if you try the read a
%       whole RCM-DX file or a whole node of a RCM-DX file. Not all the
%       nodes of RCM-DX file have data and/or metadata.
%       ['on'] - display warning messages
%       'off'  - do not display warning messages
%
%   'writecsvConfig'
%       Write config to csv. Delimiter of csv is comma [','].
%       Argument of 'writecsvConfig' must be a full path of type 'char' or
%       'off'. 
%       ['off']  - do nothing. 
%       'fullpath' - where 'fullpath' is the full path
%       ('path\filename.extension') of the csv file. For example:
%          'C:\Users\[user]\Desktop\load_rcmdx_fromConfig.csv' - to write
%          the csv config on the desktop.
%          '.\load_rcmdx_fromConfig.csv'  - to write the csv config in the
%          same folder as this function
%
%   'matSave':
%       'on'   -  save data and config to a mat file. See option
%                 'matFilename' for the destination.
%       ['off'] - (default) do not save data to a mat file.
%
%   'matFilename': .mat filename with path. By default the filename
%       .mat is the current folder and date_time data.mat
%       (currentFolder/YYYYMMDD-HHMMSS_data.mat).
%
%% Output Arguments
%  Output options:
%   data:
%       structure with info, metadata (attributes and objectInfo) and data of RCMDX-file.
%
%   config:
%       config table. See input arguments under options for more
%       informations about the content of config table.
%
%% See also
%  See also .
%
%% Copyright
%  The RCM-DX contributors
%
%% Modifications
%  Ver. | Date       | Autor                        | Description
%   0.1 | 10.09.2024 | jean-frederic.bonjour@sbb.ch | First edition (beta version)
%   1.0 | 11.09.2024 | jean-frederic.bonjour@sbb.ch | First release
%   2.0 | 12.09.2024 | jean-frederic.bonjour@sbb.ch | Add [a] in config to read sublevels
%                                                     Add [/] as first character in config LevelName
%                                                     Minor changes and bug fixes.
%   2.1 | 12.09.2024 | jean-frederic.bonjour@sbb.ch | Add examples in help
%   2.2 | 19.09.2024 | jean-frederic.bonjour@sbb.ch | Small bugfixing
%   2.3 | 06.12.2024 | jean-frederic.bonjour@sbb.ch | Bug fix: support of several MEASURINGSYSTEM per RCM-DX-file.
%                                                     Add warning option
%   2.4 | 20.01.2025 | jean-frederic.bonjour@sbb.ch | Improve help documentation
%                                                     Add config to output variables
%                                                     Replace config by option config
%                                                     Add option 'writecsvConfig'
%   2.5 | 28.01.2025 | jean-frederic.bonjour@sbb.ch | Improve help documentation
%                                                     Bugfix the output file of option 'writecsvConfig' 
%                                                     Add config in the generate .mat-file by option 'matSave'
%   2.6 | 30.01.2025 | jean-frederic.bonjour@sbb.ch | Modify copyright

%% Function
function [varargout] = load_rcmdx_fromConfig(filename, varargin)

%% Options
% Initialization (default)
opt.config = table("a","a","a","/RCMDX",'variableNames',["Data", "Attributes", "ObjectInfo", "LevelName"]);
opt.matSave = 'off'; % Save workspace to .mat, 'on' = yes (save), ['off'] = no (not save).
opt.matFilename = fullfile(cd,[char(datetime('now','Format','yyyyMMdd-HHmmss')) '_data.mat']);
opt.configLevelNameUsed = 'shortabst'; % 'shortabst', 'longabst', 'shortreal', 'longreal'
opt.writecsvConfig = 'off';
opt.processConfigOnly = 'off';
opt.mergeToTable = 'on';
opt.warning = 'on';

% check and set option
for incrOpt = 1:2:length(varargin)
    switch lower(varargin{incrOpt})
        case 'config'
            if istable(varargin{incrOpt+1})
                opt.config = varargin{incrOpt+1};
            elseif exist(varargin{incrOpt+1}, 'file')
                % Read read csv config if not a table
                csvConfigFilename = varargin{incrOpt+1};
                opt.config = readcsvConfig(csvConfigFilename);
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must be a table or a csv file.'])
            end
        case 'matsave'
            if ischar(varargin{incrOpt+1})
                if strcmpi(varargin{incrOpt+1},'on') || strcmpi(varargin{incrOpt+1},'off')
                    opt.matSave = lower(varargin{incrOpt+1});
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
            end
        case 'matfilename'
            if ischar(varargin{incrOpt+1})
                opt.matFilename = varargin{incrOpt+1};
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must be a string.'])
            end
        case 'configlevelnameused'
            if ischar(varargin{incrOpt+1})
                varargin{incrOpt+1} = lower(varargin{incrOpt+1});
                if matches(varargin{incrOpt+1},{'shortabst', 'longabst', 'shortreal', 'longreal'})
                    opt.configLevelNameUsed = varargin{incrOpt+1};
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''shortabst'', ''longabst'', ''shortreal'', ''longreal''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument.'])
            end
        case 'mergetotable'
            if ischar(varargin{incrOpt+1})
                if strcmpi(varargin{incrOpt+1},'on') || strcmpi(varargin{incrOpt+1},'off')
                    opt.mergeToTable = lower(varargin{incrOpt+1});
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
            end
        case 'writecsvconfig'
            if ischar(varargin{incrOpt+1})
                if ischar(varargin{incrOpt+1}) || strcmpi(varargin{incrOpt+1},'off')
                    opt.writecsvConfig = lower(varargin{incrOpt+1});
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''a string'' or ''off''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument.'])
            end
        case 'processconfigonly'
            if ischar(varargin{incrOpt+1})
                if strcmpi(varargin{incrOpt+1},'on') || strcmpi(varargin{incrOpt+1},'off')
                    opt.processConfigOnly = lower(varargin{incrOpt+1});
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
            end
        case 'warning'
            if ischar(varargin{incrOpt+1})
                if strcmpi(varargin{incrOpt+1},'on') || strcmpi(varargin{incrOpt+1},'off')
                    opt.warning = lower(varargin{incrOpt+1});
                else
                    error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
                end
            else
                error(['Option ' varargin{incrOpt} ': Invalid argument. Argument must ''on'' or ''off''.'])
            end
        otherwise
            error(['Unknown option n°' num2str((incrOpt+1)/2) ': ' varargin{incrOpt} '.'])
    end
end



%% Code
data = getMainFileInfo(filename); % get main file info

opt.config = processConfig(data, opt.config, opt); % process opt.config (remove empty lines and add subelements in case of [a]

if strcmpi(opt.processConfigOnly,'off')
    % -------------------------------------------------------------------------
    % read rcmdx file
    for incr = 1:size(opt.config,1)
        try
            [data, ~] = rcmdxReadAtt(data,opt.config,incr);
            data = rcmdxReadObjectInfo(data,opt.config,incr,opt);
            data = rcmdxReadData(data,opt.config,incr,opt);
        catch ME
            if strcmpi(opt.warning,'on')
                warning(strcat("Error on configuration line ",num2str(incr),": ",opt.config.LevelNameLongReal_r(incr)))
            end
            rethrow(ME)
        end
    end
    % -------------------------------------------------------------------------

    % -------------------------------------------------------------------------
    % Merge Datasource, POSITION and so on to table
    if strcmpi(opt.mergeToTable, 'on')
        % CONFIGURATION TOPOLOGY
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.LINE',                       opt,1);
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.PROPERTY',                   opt,1);
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.SWITCHTRACK',                opt,1);
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.TRACK',                      opt,1);
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.TRACKOBJECT',                opt,1);
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.CONFIGURATION.TOPOLOGY.TRACKPOINT',                 opt,1);

        % MEASURINGSYSTEM DATASOURCE
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.MEASURINGSYSTEM_NAME.DATASOURCE_NAME.CHANNEL_NAME', opt,2); % DATASOURCE
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.MEASURINGSYSTEM_NAME.LOGGING.AVAILABILITY',         opt,1); % AVAILABILITY
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.MEASURINGSYSTEM_NAME.LOGGING.CONSISTENCY',          opt,1); % CONSISTENCY
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.MEASURINGSYSTEM_NAME.MEASUREMENTMODE',              opt,1); % MEASUREMENTMODE

        % EVENTS
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.EVENTS',                                            opt,1);

        % POSITION
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.POSITION.LOGGING.AVAILABILITY',                     opt,1); % AVAILABILITY
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.POSITION.LOGGING.CONSISTENCY',                      opt,1); % CONSISTENCY
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.POSITION.MEASUREMENTMODE',                          opt,1); % MEASUREMENTMODE
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.POSITION.POSITION_SOURCE.POSITION_SOURCE_DATA',     opt,2); % POSITION_SOURCE

        % SECTIONS
        data = merge2table(data, 'RCMDX.PLATFORM.SESSION_NAME.SECTIONS',                                          opt,1);

        % FILE
        data = merge2table(data, 'RCMDX.FILE.DATAPROCESSING.CLEARANCE',                                           opt,1);
        data = merge2table(data, 'RCMDX.FILE.DATAPROCESSING.CONVERTERSOURCE',                                     opt,1);
        data = merge2table(data, 'RCMDX.FILE.DATAPROCESSING.PROCESSINGLOG',                                       opt,1);
    end
    % -------------------------------------------------------------------------

    % -------------------------------------------------------------------------
    if strcmpi(opt.matSave,'on')
        % Save .mat
        config = opt.config(:,1:4);
        save(opt.matFilename,'data', 'config')
        clear temp config
    end
    % -------------------------------------------------------------------------
end

% -------------------------------------------------------------------------
% write csv config to a file
if ~strcmpi(opt.writecsvConfig,'off')
    try
        writetable(opt.config(:,1:4),opt.writecsvConfig,'Delimiter',',') % ,'QuoteStrings','all'
        disp(' ')
        disp(['config written in ' opt.writecsvConfig])
        disp(' ')
    catch
        warning(' ')
        warning(['config not written in ' opt.writecsvConfig])
        warning(' ')
    end
end
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
varargout{1} = data;
varargout{2} = opt.config(:,1:4);
% -------------------------------------------------------------------------

end

%% ------------------------------------------------------------------------
% read csv configuration
function config = readcsvConfig(csvConfigFilename)
dataLines = [2, Inf]; % file size, number of lines

% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 4);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = [";",","];

% Specify column names and types
opts.VariableNames = ["Data", "Attributes", "ObjectInfo", "LevelName"];
opts.VariableTypes = ["string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Data", "Attributes", "ObjectInfo", "LevelName"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Data", "Attributes", "ObjectInfo", "LevelName"], "EmptyFieldRule", "auto");

% Import the data
config = readtable(csvConfigFilename, opts);

end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% Process config
function config = processConfig(data, config, opt)

% lower variables
config.Data       = lower(config.Data);
config.Attributes = lower(config.Attributes);
config.ObjectInfo = lower(config.ObjectInfo);

% remove empty lines. For ex. [ , , ,'blabla']
config = config(contains(strcat(config.Data,config.Attributes,config.ObjectInfo),["x", "a"]),:);

config = processConfigFormat(data,config, opt);

if any(contains(strcat(config.Data,config.Attributes,config.ObjectInfo),"a")) % Check if it's needed to execute this part at all.
    % [a] stays for read the corresponding element of LevelName and every subelement.
    % Add all subelement to config.

    % Initialization
    tempConfig = config(1,:);
    tempConfig(:,:) = [];

    for incr = 1:size(config,1)
        if any(contains(strcat(config.Data(incr),config.Attributes(incr),config.ObjectInfo(incr)),"a"))
            config.Data(incr)       = replace(config.Data(incr),"a","x");
            config.Attributes(incr) = replace(config.Attributes(incr),"a","x");
            config.ObjectInfo(incr) = replace(config.ObjectInfo(incr),"a","x");

            tempConfigLevelNameLongReal_r = config.LevelNameLongReal_r(incr);

            h5Var.idx_type = 'H5_INDEX_NAME';
            h5Var.order = 'H5_ITER_INC';

            h5Var.fid = H5F.open(fullfile(data.info.file.path, data.info.file.filename_wExt));

            tempConfig = processConfigSublevel(data, config, incr, opt, tempConfig, tempConfigLevelNameLongReal_r, h5Var, 1);

            H5F.close(h5Var.fid);
        end
    end

    tempConfig = processConfigFormat(data,tempConfig, opt);
    config = [config;tempConfig];
    config = unique(config,'stable'); % remove duplicate

end
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
function tempConfig = processConfigSublevel(data, config, incr, opt, tempConfig, tempConfigLevelNameLongReal_r, h5Var, level)
H5_type = 'GROUP';
while matches(H5_type,'GROUP')
    H5_type = [];
    try % GROUP
        h5Var.(['level' num2str(level)]).gid = H5G.open(h5Var.fid,tempConfigLevelNameLongReal_r);
        H5_type = 'GROUP';
    catch
        % Do nothing
    end
    try % DATASET
        h5Var.(['level' num2str(level)]).gid = H5D.open(h5Var.fid,tempConfigLevelNameLongReal_r);
        H5_type = 'DATASET';
    catch
        % Do nothing
    end
    if matches(H5_type,'GROUP')
        h5Var.(['level' num2str(level)]).info = H5G.get_info(h5Var.(['level' num2str(level)]).gid);
        for h5Var_incr = 1:h5Var.(['level' num2str(level)]).info.nlinks
            h5Var.(['level' num2str(level)]).obj_id = H5O.open_by_idx(h5Var.fid,tempConfigLevelNameLongReal_r,h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
            tempConfig(end+1,:) = {""};
            tempConfig.LevelName(end) = H5I.get_name(h5Var.(['level' num2str(level)]).obj_id);
            tempConfig.Data(end)       = config.Data(incr);
            tempConfig.Attributes(end) = config.Attributes(incr);
            tempConfig.ObjectInfo(end) = config.ObjectInfo(incr);
            tempConfig = processConfigSublevel(data, config, incr, opt, tempConfig, tempConfig.LevelName(end), h5Var, level+1);
            H5O.close(h5Var.(['level' num2str(level)]).obj_id);
        end
        H5G.close(h5Var.(['level' num2str(level)]).gid);
        break
    end
end
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
function config = processConfigFormat(data,config, opt)

for incr = 1:size(config,1)
    % ---------------------------------------------------------------------
    % Format configuration
    config.LevelNameLongReal_r(incr)  = replace(config.LevelName(incr)          , {'[PLATFORM]','[SESSION_NAME]'}, {data.info.PLATFORM,data.info.SESSION.SESSION_NAME}); % Name long real read
    config.LevelNameLongReal_w(incr)  = extractAfter(replace(replace(replace(config.LevelNameLongReal_r(incr),data.info.SESSION.SESSION_NAME,['SESSION_' data.info.SESSION.SESSION_NAME]), '.','_'),{'@','/0','/1','/2','/3','/4','/5','/6','/7','/8','/9'},{'_','/PAR_0','/PAR_1','/PAR_2','/PAR_3','/PAR_4','/PAR_5','/PAR_6','/PAR_7','/PAR_8','/PAR_9'}),1); % Name long real write

    temp = [{[data.info.PLATFORM '_']}, strcat({data.info.MEASURINGSYSTEM.MEASURINGSYSTEM_NAME_woREP}, '_')];
    for incrSystem = 1:size(data.info.MEASURINGSYSTEM,1)
        temp = [temp, [strcat({data.info.MEASURINGSYSTEM(incrSystem).DATASOURCE.DATASOURCE_NAME_woREP}, '_')]];
    end
    config.LevelNameShortReal_w(incr) = replace(config.LevelNameLongReal_w(incr), temp,repmat({''},size(temp))); % Name short real write
    clear temp

    config.LevelNameLongAbst_w(incr)  = extractAfter(replace(replace(config.LevelNameLongReal_r(incr), {data.info.PLATFORM,data.info.SESSION.SESSION_NAME,'.'}, {'PLATFORM','SESSION_NAME','_'})   ,{'@','/0','/1','/2','/3','/4','/5','/6','/7','/8','/9'},{'_','/PAR_0','/PAR_1','/PAR_2','/PAR_3','/PAR_4','/PAR_5','/PAR_6','/PAR_7','/PAR_8','/PAR_9'}),1); % Name long abstracted write

    temp = [{'PLATFORM_'}, strcat({data.info.MEASURINGSYSTEM.MEASURINGSYSTEM_NAME_woREP}, '_')];
    for incrSystem = 1:size(data.info.MEASURINGSYSTEM,1)
        temp = [temp, [strcat({data.info.MEASURINGSYSTEM(incrSystem).DATASOURCE.DATASOURCE_NAME_woREP}, '_')]];
    end
    config.LevelNameShortAbst_w(incr) = replace(config.LevelNameLongAbst_w(incr), temp,repmat({''},size(temp))); % Name short abstracted write
    clear temp

    switch lower(opt.configLevelNameUsed)
        case 'shortreal'
            config.LevelNameUsed_w(incr) = config.LevelNameShortReal_w(incr);
        case 'longreal'
            config.LevelNameUsed_w(incr) = config.LevelNameLongReal_w(incr);
        case 'shortabst'
            config.LevelNameUsed_w(incr) = config.LevelNameShortAbst_w(incr);
        case 'longabst'
            config.LevelNameUsed_w(incr) = config.LevelNameLongAbst_w(incr);
    end
    % ---------------------------------------------------------------------
end
config.LevelNameLongReal_w  = replace(config.LevelNameLongReal_w ,'-','_');
config.LevelNameShortReal_w = replace(config.LevelNameShortReal_w,'-','_');
config.LevelNameLongAbst_w  = replace(config.LevelNameLongAbst_w ,'-','_');
config.LevelNameShortAbst_w = replace(config.LevelNameShortAbst_w,'-','_');
config.LevelNameUsed_w = replace(config.LevelNameUsed_w     ,'-','_');
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
function data = getMainFileInfo(filename)
%----------------------------------------------------------------------
% file info
data.info.file.fullpath = filename;
[data.info.file.filename_wExt,data.info.file.path] = strtok(reverse(replace(data.info.file.fullpath,'/','\')),'\');
data.info.file.filename_wExt = reverse(data.info.file.filename_wExt);
data.info.file.path = reverse(data.info.file.path);
[~, data.info.file.filename_woExt] = strtok(reverse(data.info.file.filename_wExt),'.');
data.info.file.filename_woExt = reverse(data.info.file.filename_woExt(2:end));
data.info.file.ext = ['.' reverse(strtok(reverse(data.info.file.fullpath),'.'))];
clear filename
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% get PLATFORM (DFZ##), SESSIONS_NAME YYYYMMDD_hhmmss_##.ok and system
h5Var.idx_type = 'H5_INDEX_NAME';
h5Var.order = 'H5_ITER_INC';
h5Var.fid = H5F.open(fullfile(data.info.file.path, data.info.file.filename_wExt));
h5Var.level2.gid = H5G.open(h5Var.fid,'/RCMDX');
h5Var.level2.info = H5G.get_info(h5Var.level2.gid);
for h5Var_incr = 1:h5Var.level2.info.nlinks
    h5Var.level2.obj_id = H5O.open_by_idx(h5Var.fid,'/RCMDX',h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
    temp = H5I.get_name(h5Var.level2.obj_id);
    temp = reverse(strtok(reverse(temp),'/'));
    if ~contains(temp,'FILE')
        data.info.PLATFORM = temp;
    end
    clear temp
    H5O.close(h5Var.level2.obj_id);
end
H5G.close(h5Var.level2.gid);

% SESSION
h5Var.level3.gid = H5G.open(h5Var.fid,['/RCMDX/' data.info.PLATFORM]);
h5Var.level3.info = H5G.get_info(h5Var.level3.gid);
for h5Var_incr = 1:h5Var.level3.info.nlinks
    h5Var.level3.obj_id = H5O.open_by_idx(h5Var.fid,['/RCMDX/' data.info.PLATFORM],h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
    data.info.SESSION.level_name = H5I.get_name(h5Var.level3.obj_id);
    data.info.SESSION.SESSION_NAME = reverse(strtok(reverse(data.info.SESSION.level_name),'/'));
    H5O.close(h5Var.level3.obj_id);
end
H5G.close(h5Var.level3.gid);

% MEASURINGSYSTEM_NAME
h5Var.level4.gid = H5G.open(h5Var.fid,data.info.SESSION.level_name);
h5Var.level4.info = H5G.get_info(h5Var.level4.gid);
incrSystem = 1;
for h5Var_incr = 1:h5Var.level4.info.nlinks
    h5Var.level4.obj_id = H5O.open_by_idx(h5Var.fid,data.info.SESSION.level_name,h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
    temp = H5I.get_name(h5Var.level4.obj_id);
    if ~contains(temp,["CONFIGURATION","POSITION","SECTIONS","EVENTS"])
        data.info.MEASURINGSYSTEM(incrSystem,1).level_name = temp;
        data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME = reverse(strtok(reverse(data.info.MEASURINGSYSTEM(incrSystem,1).level_name),'/'));
        data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME_woREP = replace(data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME,[data.info.PLATFORM '.'],''); % without repetitions
        incrSystem = incrSystem+1;
    end
    clear temp
    H5O.close(h5Var.level4.obj_id);
end
H5G.close(h5Var.level4.gid);

% DATASOURCE
for incrSystem = 1:size(data.info.MEASURINGSYSTEM,1)
    h5Var.level5.gid = H5G.open(h5Var.fid,data.info.MEASURINGSYSTEM(incrSystem,1).level_name);
    h5Var.level5.info = H5G.get_info(h5Var.level5.gid);
    incrDatasource = 1;
    for h5Var_incr = 1:h5Var.level5.info.nlinks
        h5Var.level5.obj_id = H5O.open_by_idx(h5Var.fid,data.info.MEASURINGSYSTEM(incrSystem,1).level_name,h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
        temp = H5I.get_name(h5Var.level5.obj_id);
        if ~contains(temp,["CONFIGURATION","LOGGING","MEASUREMENTMODE"])
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).level_name = temp;
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).DATASOURCE_NAME = reverse(strtok(reverse(data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).level_name),'/'));
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).DATASOURCE_NAME_woREP = replace(data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).DATASOURCE_NAME,[data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME '.'],''); % without repetitions
            incrDatasource = incrDatasource+1;
        end
        clear temp
        H5O.close(h5Var.level5.obj_id);
    end
    H5G.close(h5Var.level5.gid);
end

% CHANNEL
for incrSystem = 1:size(data.info.MEASURINGSYSTEM,1)
    for incrDatasource = 1:size(data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE,1)
        h5Var.level6.gid = H5G.open(h5Var.fid,data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).level_name);
        h5Var.level6.info = H5G.get_info(h5Var.level6.gid);
        incrChannel = 1;
        for h5Var_incr = 1:h5Var.level6.info.nlinks
            h5Var.level6.obj_id = H5O.open_by_idx(h5Var.fid,data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).level_name,h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');
            temp = H5I.get_name(h5Var.level6.obj_id);
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).CHANNEL(incrChannel,1).level_name = temp;
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).CHANNEL(incrChannel,1).CHANNEL_NAME = reverse(strtok(reverse(data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).CHANNEL(incrChannel,1).level_name),'/'));
            data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).CHANNEL(incrChannel,1).CHANNEL_NAME_woREP = replace(data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).CHANNEL(incrChannel,1).CHANNEL_NAME,[data.info.MEASURINGSYSTEM(incrSystem,1).DATASOURCE(incrDatasource,1).DATASOURCE_NAME '.'],''); % without repetitions
            incrChannel = incrChannel+1;
            clear temp
            H5O.close(h5Var.level6.obj_id);
        end
        H5G.close(h5Var.level6.gid);
    end
end

H5F.close(h5Var.fid);
%----------------------------------------------------------------------

%----------------------------------------------------------------------
% get StructureVersion
data.info.StructureVersion = h5readatt(fullfile(data.info.file.path, data.info.file.filename_wExt),'/RCMDX/FILE/','StructureVersion');
%----------------------------------------------------------------------

end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
%  Read rcmdx attributes
function [data, attributes]= rcmdxReadAtt(data,config,incr)
h5Var.idx_type = 'H5_INDEX_NAME';
h5Var.order = 'H5_ITER_INC';

if matches(config.Attributes(incr),"x")
    h5Var.fid = H5F.open(fullfile(data.info.file.path, data.info.file.filename_wExt));
    try % GROUP
        h5Var.gid = H5G.open(h5Var.fid,config.LevelNameLongReal_r(incr));
        H5_type = 'GROUP';
    catch
        % Do nothing
    end
    try % DATASET
        h5Var.gid = H5D.open(h5Var.fid,config.LevelNameLongReal_r(incr));
        H5_type = 'DATASET';
    catch
        % Do nothing
    end

    h5Var.info = H5O.get_info(h5Var.gid);
    for h5Var_incr = 1:h5Var.info.num_attrs
        h5Var.obj_id = H5A.open_by_idx(h5Var.gid,config.LevelNameLongReal_r(incr),h5Var.idx_type,h5Var.order,h5Var_incr-1);
        attributes.Name{h5Var_incr,:} = H5A.get_name(h5Var.obj_id);
        attributes.Value{h5Var_incr,:} = h5readatt(fullfile(data.info.file.path, data.info.file.filename_wExt),config.LevelNameLongReal_r(incr),attributes.Name{h5Var_incr,:});
        H5A.close(h5Var.obj_id);
    end
    if h5Var.info.num_attrs == 0
        attributes.Name = [];
        attributes.Value = [];
    end
    attributes = struct2table(attributes);
    temp.level_name = split(strcat('metadata.',replace(config.LevelNameUsed_w(incr),'/','.'), '.attributes'),'.');
    data = setfield(data,temp.level_name{:},attributes);
    switch H5_type
        case 'GROUP'
            H5G.close(h5Var.gid);
        case 'DATASET'
            H5D.close(h5Var.gid);
    end

    H5F.close(h5Var.fid);
else
    attributes.Name = [];
    attributes.Value = [];
end
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
%  Read rcmdx object info
function data = rcmdxReadObjectInfo(data,config,incr,opt)
h5Var.idx_type = 'H5_INDEX_NAME';
h5Var.order = 'H5_ITER_INC';

if matches(config.ObjectInfo(incr),"x")
    h5Var.fid = H5F.open(fullfile(data.info.file.path, data.info.file.filename_wExt));
    try % GROUP
        h5Var.gid = H5G.open(h5Var.fid,config.LevelNameLongReal_r(incr));
        H5_type = 'GROUP';
    catch
        % Do nothing
    end
    try % DATASET
        h5Var.gid = H5D.open(h5Var.fid,config.LevelNameLongReal_r(incr));
        H5_type = 'DATASET';
    catch
        % Do nothing
    end
    switch H5_type
        case 'GROUP'
            h5Var.info = H5G.get_info(h5Var.gid);
            for h5Var_incr = 1:h5Var.info.nlinks
                h5Var.obj_id = H5O.open_by_idx(h5Var.fid, config.LevelNameLongReal_r(incr),h5Var.idx_type,h5Var.order,h5Var_incr-1,'H5P_DEFAULT');

                objectInfo.Name{h5Var_incr,:} = H5I.get_name(h5Var.obj_id);
                objectInfo.Name{h5Var_incr,:} = reverse(strtok(reverse(objectInfo.Name{h5Var_incr,:}),'/'));
                switch H5I.get_type(h5Var.obj_id)
                    case 1
                        objectInfo.Type{h5Var_incr,:} = 'FILE';
                    case 2
                        objectInfo.Type{h5Var_incr,:} = 'GROUP';
                    case 3
                        objectInfo.Type{h5Var_incr,:} = 'DATATYPE';
                    case 4
                        objectInfo.Type{h5Var_incr,:} = 'DATASPACE';
                    case 5
                        objectInfo.Type{h5Var_incr,:} = 'DATASET';
                    case 6
                        objectInfo.Type{h5Var_incr,:} = 'ATTR';
                    case 7
                        objectInfo.Type{h5Var_incr,:} = 'BADID';
                    otherwise
                        objectInfo.Type{h5Var_incr,:} = 'Type unknown';
                        if strcmpi(opt.warning,'on')
                            warning(strcat('Type unknown: ', string(H5I.get_name(h5Var.obj_id))))
                        end
                end
                H5O.close(h5Var.obj_id);
            end
            if h5Var.info.nlinks == 0
                objectInfo.Name = [];
                objectInfo.Type = [];
            end
            objectInfo = struct2table(objectInfo);
            temp.level_name = split(strcat('metadata.', replace(config.LevelNameUsed_w(incr),'/','.'), '.objectInfo'),'.');
            data = setfield(data,temp.level_name{:},objectInfo);
            H5G.close(h5Var.gid);
        case 'DATASET'
            objectInfo.Name = [];
            objectInfo.Type = [];
            objectInfo = struct2table(objectInfo);
            temp.level_name = split(strcat('metadata.', replace(config.LevelNameUsed_w(incr),'/','.'), '.objectInfo'),'.');
            data = setfield(data,temp.level_name{:},objectInfo);
    end
    H5F.close(h5Var.fid);
end
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
%  Read rcmdx data
function data = rcmdxReadData(data,config,incr,opt)
if matches(config.Data(incr),"x")
    tempData = [];
    try
        tempData = h5read(fullfile(data.info.file.path, data.info.file.filename_wExt),config.LevelNameLongReal_r(incr));
    catch ME
        if strcmpi(opt.warning,'on')
            warning(strcat("There is maybe an error in configuration (config). LevelName is not a dataset: ", config.LevelNameLongReal_r(incr)))
        end
    end
    if ~isempty(tempData)
        temp.level_name = split(strcat(replace(config.LevelNameUsed_w(incr),'/','.'), ''),'.');
        data = setfield(data,temp.level_name{:},tempData);
    end
end
end
% -------------------------------------------------------------------------

%% ------------------------------------------------------------------------
% Merge structure to table
function data = merge2table(data,LevelNameAbst,opt,mergeLevel)
try
    if contains(opt.configLevelNameUsed,'real')
        temp.level_name = split(replace(LevelNameAbst,{'PLATFORM','SESSION_NAME'},{data.info.PLATFORM,replace(['SESSION_' data.info.SESSION.SESSION_NAME],'.','_')}),'.');
    else
        temp.level_name = split(LevelNameAbst,'.');
    end
    if contains(LevelNameAbst,"MEASURINGSYSTEM_NAME")
        temp.level_name = repmat(temp.level_name,1,size(data.info.MEASURINGSYSTEM,1));
        for incrSystem = 1:size(data.info.MEASURINGSYSTEM,1)
            switch lower(opt.configLevelNameUsed)
                case {'shortreal', 'shortabst'}
                    temp.level_name{4,incrSystem} = data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME_woREP;
                case 'longreal'
                    temp.level_name{4,incrSystem} = replace(data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME,'.','_');
                case 'longabst'
                    temp.level_name{4,incrSystem} = replace(data.info.MEASURINGSYSTEM(incrSystem,1).MEASURINGSYSTEM_NAME,[data.info.PLATFORM '.'],'PLATFORM_');
            end

        end
    end
    if ~contains(LevelNameAbst,"DATASOURCE_NAME")
        for incr = 1:size(temp.level_name,2)
            temp.data = getfield(data,temp.level_name{:,incr});
            temp.data = struct2table(temp.data);
            temp.level_name_end = size(temp.level_name,1);
            if mergeLevel == 2 % for ex. for datasources of SYSTEM
                temp.data2 = getfield(data,temp.level_name{1:end-1,incr});
                temp.data2 = rmfield(temp.data2, temp.level_name{end,incr});
                temp.data  = [temp.data, struct2table(temp.data2)];
                temp.level_name_end = size(temp.level_name,1)-1;
            end
            data = setfield(data,temp.level_name{1:temp.level_name_end,incr},temp.data);
        end
    else
        % for DATATSOURCE of MEASURINGSYSTEM
        for incr = 1:size(temp.level_name,2)
            temp.DATASOURCE_NAME = fieldnames(data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}));
            temp.DATASOURCE_NAME = temp.DATASOURCE_NAME(~matches(temp.DATASOURCE_NAME,{'CONFIGURATION','LOGGING','MEASUREMENTMODE'}));
            for incrDatasource = 1:size(temp.DATASOURCE_NAME,1)
                temp.CHANNEL_NAME = fieldnames(data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}));
                temp.CHANNEL_NAME = temp.CHANNEL_NAME(~matches(temp.CHANNEL_NAME,{'timestamp','duration'}));
                for incrChannel = 1:size(temp.CHANNEL_NAME,1)
                    if matches(fieldnames(data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}).(temp.CHANNEL_NAME{incrChannel})),{'data'})
                        data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}).(temp.CHANNEL_NAME{incrChannel}) = data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}).(temp.CHANNEL_NAME{incrChannel}).data;
                    end
                end
                data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}) = struct2table(data.(temp.level_name{1,incr}).(temp.level_name{2,incr}).(temp.level_name{3,incr}).(temp.level_name{4,incr}).(temp.DATASOURCE_NAME{incrDatasource}));
            end
        end
    end
catch
    % Do nothing
end
end
% -------------------------------------------------------------------------
