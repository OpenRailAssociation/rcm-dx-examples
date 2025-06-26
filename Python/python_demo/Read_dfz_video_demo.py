# Read_dfz_video_demo.py
## Description
# The following code provives an example how to read the corresponding channel video according to some position inputs.
# The codes exports a resized video to the corresponding timestamps range in current ptoject folder.
# The code works on the provided demo Data available on :
# https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html

#  SBB Open source 2025
#
#  Modifications
#  Ver. | Date       | Description
#   1.0 | 05.03.2025 | First edition
#   1.01| 06.03.2025 | Standardisation of the code
#

## Import
import os
import pandas as pd
import h5py
import numpy as np
from PIL import Image
import io
import cv2
import shutil

## Definition


# We create a function to list the image paths for each channel. The inputs for each channel are:
# the path to the timestamp dataset, the path to the folder where the image datasets are located,
# and the start and end timestamps to set the boundaries.
def getChannelImagelist(TimestampDatasetPath, IMGgroupPath, TimestampBegin, TimestampStop):
    # we load the dataset which contains the timestamp array
    timestamp_array = H5File[TimestampDatasetPath][:]
    # We create the list of image paths corresponding to the chosen camera channel.
    # Since the folder where the images are located is not a dataset, we need to look inside and list its contents (datasets).
    ChannelImgPaths = []
    for dataset in H5File[IMGgroupPath].keys():
        ChannelImgPaths.append(IMGgroupPath + "/" + dataset)
    # we create a datarframe with the timestamp and the corresponding image path (the size of both arrays is the same)
    d = {"timestamp": timestamp_array, "IMGpath": ChannelImgPaths}
    TimestampsIndex = pd.DataFrame(data=d)
    # we extract the corresponding lines from the dataframe that have timestamp values which are greater or egal as TimestampBegin and smaller or egal to timestampStop
    ChannelIMGList = TimestampsIndex["IMGpath"][(TimestampsIndex["timestamp"] >= TimestampBegin) & (TimestampsIndex["timestamp"] <= TimestampStop)]
    return ChannelIMGList


# We create a function to export our image_list into a defined IMG_folderName
def ExportImgInFolder(ImageList, IMGfolderName):
    for row in ImageList.values:
        # prepare the name of the images. Indeed, for each channel (camera), an image can have the same name. Therefore,
        # to clearly organize the images, we will extract elements that can more precisely identify their source.
        # In our case, we will extract the vehicle code (DFZ00), the acquisition system code (TSIMS), and the channel (TSIS-L, RHIS-R, etc.).
        ChannelName = ("_".join(row.split("/")[-3].split("_")[:2])).replace(".", "_")
        # prepare the index of the images
        ImageIndice = row.split(".")[-1]
        # We read the image and export and save it as png
        Img_array = H5File[row][:]
        ImgData = io.BytesIO(Img_array)
        Img = Image.open(ImgData)
        ImgPath = f"{IMGfolderName}/image_{ChannelName}_{ImageIndice}.png"
        Img.save(ImgPath)


# Create a function to export our images into a video and save it in the project folder.
def ExportVideo(ImageFolder, VideoName):
    # we look at all the images that ends with the extension *.png
    images = [img for img in os.listdir(ImageFolder) if img.endswith(".png")]
    # we look at the 1st image to get its properties such as size
    frame = cv2.imread(os.path.join(ImageFolder, images[0]))
    height, width, layers = frame.shape
    # we create the video object
    video = cv2.VideoWriter(VideoName, 0, 1, (width, height))
    # we add our images in our video
    for image in images:
        video.write(cv2.imread(os.path.join(ImageFolder, image)))
    cv2.destroyAllWindows()
    video.release()


## Inputs

# The network of tracks is divided into different sections identified by track_id. These sections are characterized by a distance that allows localization on the same section using a trackoffset.
# Thus, a geographical position can be associated with a track_id and a trackoffset value, or a segment can be characterized by a track_id and two trackoffset values.

# trackoffset (km)
PositionStart = 480
PositionEnd = 515

# track ID (-)
TrackId = 123834

# path to the rcmdx file
RCMdxFilePath = R"data\20220428-114946_DFZ00_TVS_v001_created-20220429-065432.rcmdx"

# List of path where postitioning information linked to timestamps are located
TrackIdPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.track_id"
TrackoffsetPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/POSITION.SOURCE.DATA/data.trackoffset"
TimestampPositionData = "RCMDX/DFZ00/20220428_114946.000/POSITION/POSITION.SOURCE/timestamp"

# List of the path to the timestamps corresponding to the different video channels.
NormalChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TVS/DFZ00.TVS.MMJ_NORMAL_IMAGE_107/timestamp"
ReverseChannelsTimestamps = "RCMDX/DFZ00/20220428_114946.000/DFZ00.TVS/DFZ00.TVS.MMJ_REVERSE_IMAGE_107/timestamp"

# List of the path to the Image video folder corresponding to the different video channels
NormalChannelIMGrepository = (
    "RCMDX/DFZ00/20220428_114946.000/DFZ00.TVS/DFZ00.TVS.MMJ_NORMAL_IMAGE_107/DFZ00.TVS.MMJ_NORMAL_IMAGE_107.COMPRESSEDFRAME/IMG"
)
ReverseChannelIMGrepository = (
    "RCMDX/DFZ00/20220428_114946.000/DFZ00.TVS/DFZ00.TVS.MMJ_REVERSE_IMAGE_107/DFZ00.TVS.MMJ_REVERSE_IMAGE_107.COMPRESSEDFRAME/IMG"
)

## main

# Open the rcmdx file in read mode
with h5py.File(RCMdxFilePath, "r") as H5File:
    # We create a combined table with the positioning data components.
    TrackIdData = H5File[TrackIdPositionData][:]
    TrackoffsetData = H5File[TrackoffsetPositionData][:]
    TimestampData = H5File[TimestampPositionData][:]

    d = {"TrackId": TrackIdData, "Trackoffset": TrackoffsetData, "Timestamp": TimestampData}

    # Make a dataframe of the position data
    pos_data = pd.DataFrame(data=d)

    # get the corresponding timestamps for a defined position defined as inputs
    FilteredPositionData = pos_data[
        (pos_data["TrackId"] == TrackId)
        & (pos_data["Trackoffset"] >= min(PositionEnd, PositionStart))
        & (pos_data["Trackoffset"] <= max(PositionEnd, PositionStart))
    ]

    # From the list of timestamp we extract the limits, in other term we extract the smallest value and the highest value
    TimestampBegin = np.nanmin(FilteredPositionData["Timestamp"])
    TimestampStop = np.nanmax(FilteredPositionData["Timestamp"])

    # we load the dataset from the h5 Dataset for each video channel
    # As the vehicle has a camera that looks in front and behind we thus have 2 channels.
    NormalImgList = getChannelImagelist(NormalChannelsTimestamps, NormalChannelIMGrepository, TimestampBegin, TimestampStop)
    ReverseImgList = getChannelImagelist(ReverseChannelsTimestamps, ReverseChannelIMGrepository, TimestampBegin, TimestampStop)

    # We create a folder named IMG_Normal or IMG_Reverse to store the images that correspond to our track segment
    if not os.path.exists("IMG_Normal"):
        os.makedirs("IMG_Normal")
    if not os.path.exists("IMG_Reverse"):
        os.makedirs("IMG_Reverse")

    # We export the corresponding channel images that match the range of timestamps we are examining.
    ExportImgInFolder(NormalImgList, "IMG_Normal")
    ExportImgInFolder(ReverseImgList, "IMG_Reverse")

    # create save folder if it does not exist yet
    if not os.path.exists("processed_data"):
        os.makedirs("processed_data")

    # We execute the export into video using our data corresponding to the vehicle's direction.
    ExportVideo(
        ImageFolder="IMG_normal",
        VideoName=os.path.join(os.curdir, "processed_data", "Normal.avi"),
    )
    ExportVideo(
        ImageFolder="IMG_reverse",
        VideoName=os.path.join(os.curdir, "processed_data", "Reverse.avi"),
    )

    # We remove the folder where we temporarily stored the images.
    if os.path.exists("IMG_Normal"):
        shutil.rmtree("IMG_Normal")
    if os.path.exists("IMG_Reverse"):
        shutil.rmtree("IMG_Reverse")
