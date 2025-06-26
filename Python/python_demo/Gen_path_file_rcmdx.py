# Gen_path_file_rcmdx.py
## Description
# The following code provides an example of to generate a basic CSV file which contains all the path usable in a specific RCMDX file.
# The code works on the provided demo Data available on :
# https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html

#  SBB Open source 2025
#
#  Modifications
#  Ver. | Date       | Description
#   1.0 | 12.03.2025 | First edition
#

## Import
import pandas as pd
import h5py
import os


# Definitions
# Function to list all paths in the h5 file without reading the content
def listPathsInH5(h5FilePath):
    def ReadH5PathLevels(H5Obj, path=""):
        paths = []
        for key in H5Obj.keys():
            item = H5Obj[key]
            CurrentPath = path + key
            paths.append(CurrentPath)
            if isinstance(item, h5py.Group):
                paths.extend(ReadH5PathLevels(item, CurrentPath + "/"))
        return paths

    with h5py.File(h5FilePath, "r") as h5File:
        paths = ReadH5PathLevels(h5File)

    return paths


## Inputs
# path to the rcmdx file
RCMdxFilePath = R"data\20220428-114946_DFZ00_TGMS_v003_created-20220429-065432.rcmdx"

## main

# Open the rcmdx file in read mode and list all the Path of the
RCMDXPathList = listPathsInH5(RCMdxFilePath)

# create a table with prealocated columns for the information we would like to get when loading the data
d = {"LevelName": RCMDXPathList}

# create a dataframe to store the all the tables
ConfigFile = pd.DataFrame(data=d)

# create save folder if it does not exist yet
if not os.path.exists("processed_data"):
    os.makedirs("processed_data")

# Store the system data list in a csv file
ConfigFile.to_csv(os.path.join(os.curdir, "processed_data", "PathFile.csv"), index=False)
