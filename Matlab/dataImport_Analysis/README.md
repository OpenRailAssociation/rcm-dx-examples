## Load_rcmdx_fromConfig

Load_rcmdx_fromConfig loads the data and metadata of an RCM-DX file in
matlab. 

By default the function reads the whole content of the RCM-DX file. 
For example: `data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')`

It is possible to output a configuration (config) as table or as
csv-file. By editing this config and passing it as option input, it is
possible to read only certain data and/or metadata of an RCM-DX file.
This can be useful to access the data you really need and so improve
the performance.

Reading the whole RCM-DX file and outputing only the config without data
(output example: `[~, config]`) is really useful if you are not
familiarized with RCM-DX structure. It allows you to know the structure,
generate a config and then access the needed data. To avoid reading data 
and metadata, which would be time consuming, use the option
processConfigOnly.
For example: `[~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')`

Please refer to the [examples](#Examples) section for more information about how to use
this function.

### Examples

#### Example 1

Read everything in RCM-DX file
```matlab
data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
```

#### Example 2
Return only config as matlab table.
```matlab
[~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
```
data is read inside the function, which can be time consuming.
Use instead: 
```matlab
[~, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'processConfigOnly', 'on')
```

#### Example 3
Return only config as matlab table and read everything in RCM-DX file
```matlab
[data, config] = load_rcmdx_fromConfig('myPath\myfilename.rcmdx')
```

#### Example 4 with 'config' option.
Read only parts of the RCM-DX file defined in config, where config is a matlab table.
```matlab
data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', config)
```

Read only parts of RCM-DX file defined by 'config', where the value of the
option is a table written in the argument of the function itself.
```matlab
data = load_rcmdx_fromConfig('myPath\myfilename.rcmdx', 'config', table("a","a","a","/RCMDX",'variableNames',["Data", "Attributes", "ObjectInfo", "LevelName"]))
```
In this example `'variableNames',["Data", "Attributes", "ObjectInfo",
"LevelName"]` is the definition of name of the table column (header). Those
names can not be changed. `"a","a","a","/RCMDX"` are the values of the table.
Here the table has only one row at looks like that with its header:

|        | Column 1 | Column 2     | Column 3     | Column 4    |
|--------|----------|--------------|--------------|-------------|
| Header | "Data"   | "Attributes" | "ObjectInfo" | "LevelName" |
| Row 1  | "a"      | "a"          | "a"          | "/RCMDX"    |
