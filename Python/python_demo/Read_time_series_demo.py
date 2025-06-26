# Time_series_demo.py
## Description
# The following code provides an example of how to read and export data from a measurement system based on some position input.
# The code exports a CSV file with the system data to the project folder.
# The code works on the provided demo Data available on :
# https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html

#  SBB Open source 2025
#
#  Modifications
#  Ver. | Date       | Description
#   1.0 | 10.03.2025 | First edition
#

## Import
import pandas as pd
import h5py
import numpy as np
import os

## Inputs

# The network of tracks is divided into different sections identified by track_id. These sections are characterized by a distance that allows localization on the same section using a trackoffset.
# Thus, a geographical position can be associated with a track_id and a trackoffset value, or a segment can be characterized by a track_id and two trackoffset values.
# For our Demo we will take a segement of our network.

# trackoffset (km)
PositionStart = 180
PositionEnd = 190

# track ID (-)
TrackId = 123834

# path to the rcmdx file
RCMdxFilePath = R"data\20220428-114946_DFZ00_TGMS_v003_created-20220429-065432.rcmdx"

# List of path where postitioning information linked to timestamps are located
TrackIdPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id"
TrackoffsetPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset"
TimestampPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/timestamp"

# List of the path to the timestamps corresponding to the differnt channels
TgmsSystemTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TGMS/DFZ00.TGMS.TGPAR_111/timestamp"

# List of the path to the measurment system datasets
TgmsCantData = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TGMS/DFZ00.TGMS.TGPAR_111/DFZ00.TGMS.TGPAR_111.CANT/data"
TgmsCurvatureData = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TGMS/DFZ00.TGMS.TGPAR_111/DFZ00.TGMS.TGPAR_111.CURVATURE/data"
TgmsGaugeData = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TGMS/DFZ00.TGMS.TGPAR_111/DFZ00.TGMS.TGPAR_111.GAUGE/data"
TgmsTwistData = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TGMS/DFZ00.TGMS.TGPAR_111/DFZ00.TGMS.TGPAR_111.TWIST/data"

## main

# Open the rcmdx file in read mode
with h5py.File(RCMdxFilePath, "r") as H5File:

    # We create a combined table with the positioning data components.
    TrackIdData = H5File[TrackIdPositionData][:]
    TrackoffsetData = H5File[TrackoffsetPositionData][:]
    TimestampData = H5File[TimestampPositionData][:]
    # We create a table with the positionning data
    d = {"TrackId": TrackIdData, "Trackoffset": TrackoffsetData, "Timestamp": TimestampData}

    # Make a dataframe of the position data
    PosData = pd.DataFrame(data=d)

    # get the corresponding timestamps for a defined position defined as inputs
    filteredPositionData = PosData[
        (PosData["TrackId"] == TrackId)
        & (PosData["Trackoffset"] >= min(PositionStart, PositionEnd))
        & (PosData["Trackoffset"] <= max(PositionStart, PositionEnd))
    ]

    # From the list of timestamp we extract the limits, in other term we extract the smallest value and the highest value
    TimestampBegin = np.nanmin(filteredPositionData["Timestamp"])
    TimestampStop = np.nanmax(filteredPositionData["Timestamp"])

    # For each system data channel, we join the dataset into a table and at the end we extract the lines
    # corresponding to our range of timestamps obtained from the corresponding position.
    TimestampTable = {}
    TimestampTable["Timestamp"] = H5File[TgmsSystemTimestamps][:]
    TimestampTable["Cant"] = H5File[TgmsCantData][:]
    TimestampTable["Curvature"] = H5File[TgmsCurvatureData][:]
    TimestampTable["Gauge"] = H5File[TgmsGaugeData][:]
    TimestampTable["Twist"] = H5File[TgmsTwistData][:]

    # We create a dataframe with the our measument data before filtring with the timestamp range
    d = {
        "Timestamp": TimestampTable["Timestamp"],
        "Cant": TimestampTable["Cant"],
        "Curvature": TimestampTable["Curvature"],
        "Gauge": TimestampTable["Gauge"],
        "Twist": TimestampTable["Twist"],
    }
    TgmsMeasurementData = pd.DataFrame(data=d)
    # we extract the corresponding lines from the dataframe that have timestamp values which are greater or egal as TimestampBegin and smaller or egal to timestampStop
    TgmsDataList = TgmsMeasurementData[(TgmsMeasurementData["Timestamp"] >= TimestampBegin) & (TgmsMeasurementData["Timestamp"] <= TimestampStop)]

    # create save folder if it does not exist yet
    if not os.path.exists("processed_data"):
        os.makedirs("processed_data")

    # Store the system data list in a csv file
    TgmsMeasurementData.to_csv(os.path.join(os.path.curdir, "processed_data", "TgmsDataList.csv"), index=False)
