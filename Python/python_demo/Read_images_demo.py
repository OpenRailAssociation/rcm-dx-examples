# Read_images_demo.py
## Description
# The following code provives an example how to read and export, according to some position input, the images from channels cameras.
# The codes exports a list with the corresponding image dataset as well as the images as PNG in an additional folder (IMG).
# The code works on the provided demo Data available on :
# https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html

#  SBB Open source 2025
#
#  Modifications
#  Ver. | Date       | Description
#   1.0 | 27.02.2025 | First edition
#   1.1 | 05.03.2025 | Simplification of the code and improvement of the comments
#   1.2 | 05.03.2025 | Simplification of the code and improvement of the comments
#   1.21| 05.03.2025 | Standardisation of the code
#


## Import
import os
import pandas as pd
import h5py
import numpy as np
from PIL import Image
import io

## Definition


# We create a function to list the image paths for each channel. The inputs for each channel are:
# the path to the timestamp dataset, the path to the folder where the image datasets are located,
# and the start and end timestamps to set the boundaries.
def getChannelImageList(TimestampDatasetPath, IMGgroupPath, TimestampBegin, TimestampStop):
    # we load the dataset which contains the timestamp array
    timestamp_array = H5File[TimestampDatasetPath][:]
    # We create the list of image paths corresponding to the chosen camera channel.
    # Since the folder where the images are located is not a dataset, we need to look inside and list its contents (datasets).
    ChannelImgPaths = []
    for dataset in H5File[IMGgroupPath].keys():
        ChannelImgPaths.append(IMGgroupPath + "/" + dataset)
    # we create a datarframe with the timestamp and the corresponding image path (the size of both arrays is the same)
    d = {"Timestamp": timestamp_array, "IMGpath": ChannelImgPaths}
    TimestampsIndex = pd.DataFrame(data=d)
    # we extract the corresponding lines from the dataframe that have timestamp values which are greater or egal as TimestampBegin and smaller or egal to timestampStop
    ChannelIMGlist = TimestampsIndex["IMGpath"][(TimestampsIndex["Timestamp"] >= TimestampBegin) & (TimestampsIndex["Timestamp"] <= TimestampStop)]
    return ChannelIMGlist


## Inputs

# The network of tracks is divided into different sections identified by TrackId. These sections are characterized by a distance that allows localization on the same section using a trackoffset.
# Thus, a geographical position can be associated with a TrackId and a trackoffset value, or a segment can be characterized by a TrackId and two trackoffset values.
# For our Demo we will take a segement of our network.

# trackoffset (m)
PositionStart = 0
PositionEnd = 15

# track ID (-)
TrackId = 34873

# path to the rcmdx file
RCMdxFilePath = R"data\20220428-114946_DFZ00_TSIMS-RAW-COMP_v001_created-20220429-065432.rcmdx"

# List of path where postitioning information linked to timestamps are located
TrackIdPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id"
TrackoffsetPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset"
TimestampPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/timestamp"

# List of the path to the timestamps corresponding to the differnt channels
TSISLChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_L_DATA_108/timestamp"
TSISCChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_C_DATA_108/timestamp"
TSISRChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_R_DATA_108/timestamp"
RHISLChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.RHIS_L_IMAGE_108/timestamp"
RHISRChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.RHIS_R_IMAGE_108/timestamp"

# List of the path to the image folder corresponding to the differnt channels
TSISLChannelIMGRepository = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_L_IMAGE_108/DFZ00.TSIMS.TSIS_L_IMAGE_108.IMAGEDATA/IMG"
TSISCChannelIMGRepository = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_C_IMAGE_108/DFZ00.TSIMS.TSIS_C_IMAGE_108.IMAGEDATA/IMG"
TSISRChannelIMGRepository = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.TSIS_R_IMAGE_108/DFZ00.TSIMS.TSIS_R_IMAGE_108.IMAGEDATA/IMG"
RHISLChannelIMGRepository = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.RHIS_L_IMAGE_108/DFZ00.TSIMS.RHIS_L_IMAGE_108.IMAGEDATA/IMG"
RHISRChannelIMGRepository = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TSIMS/DFZ00.TSIMS.RHIS_R_IMAGE_108/DFZ00.TSIMS.RHIS_R_IMAGE_108.IMAGEDATA/IMG"

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
    FilteredPositionData = PosData[
        (PosData["TrackId"] == TrackId)
        & (PosData["Trackoffset"] >= min(PositionEnd, PositionStart))
        & (PosData["Trackoffset"] <= max(PositionStart, PositionEnd))
    ]

    # From the list of timestamp we extract the limits, in other term we extract the smallest value and the highest value
    TimestampBegin = np.nanmin(FilteredPositionData["Timestamp"])
    TimestampStop = np.nanmax(FilteredPositionData["Timestamp"])

    # For each channel, we execute our function to get the lists of image paths
    # corresponding to our range of timestamps obtained from the corresponding position.
    TSISLImgList = getChannelImageList(TSISLChannelsTimestamps, TSISLChannelIMGRepository, TimestampBegin, TimestampStop)
    TSISCImgList = getChannelImageList(TSISCChannelsTimestamps, TSISCChannelIMGRepository, TimestampBegin, TimestampStop)
    TSISRImgList = getChannelImageList(TSISRChannelsTimestamps, TSISRChannelIMGRepository, TimestampBegin, TimestampStop)
    RHISLImgList = getChannelImageList(RHISLChannelsTimestamps, RHISLChannelIMGRepository, TimestampBegin, TimestampStop)
    RHISRImgList = getChannelImageList(RHISRChannelsTimestamps, RHISRChannelIMGRepository, TimestampBegin, TimestampStop)

    # Now, from the table with the list of images per channel, we create a single array containing all the image paths
    ImgPositionData = np.concatenate([TSISLImgList, TSISCImgList, TSISRImgList, RHISLImgList, RHISRImgList])

    # create save folder if it does not exist yet
    if not os.path.exists("processed_data/IMG"):
        os.makedirs("processed_data/IMG")

    # Store the list of images from ImgPositioningData in a text file
    with open(os.path.join(os.path.curdir, "processed_data", "IMGsummary.txt"), "w") as f:
        for line in ImgPositionData:
            f.write(f"{line}\n")

    # Now we will export our list of images in the created folder 'IMG'
    for row in ImgPositionData:
        # prepare the name of the images. Indeed, for each channel (camera), an image can have the same name. Therefore,
        # to clearly organize the images, we will extract elements that can more precisely identify their source.
        # In our case, we will extract the vehicle code (DFZ00), the acquisition system code (TSIMS), and the channel (TSIS-L, RHIS-R, etc.).
        ChannelName = ("_".join(row.split("/")[-3].split("_")[:2])).replace(".", "_")
        # prepare the index of the images
        ImageIndice = row.split(".")[-1]
        # We read the image and export and save it as png
        ImgDataset = H5File[row]
        ImgData = io.BytesIO(np.array(ImgDataset))
        Img = Image.open(ImgData)
        ImgPath = os.path.join(os.curdir, "processed_data", "IMG", f"image_{ChannelName}_{ImageIndice}.png")
        Img.save(ImgPath)
