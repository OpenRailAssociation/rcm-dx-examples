# Load_demo_data_rcmdx.py
## Description
# The code auto loads and stores in the folder 'data'the provided demo Data available on :
# https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html


#  SBB Open source 2025
#
#  Modifications
#  Ver. | Date       | Description
#   1.0 | 17.03.2025 | First edition
#   1.01| 31.03.2025 | minor imporvements
#

## imports

import os
import wget

## Definition


def wgetDownload(url, outputPath=None):
    try:
        # Download file and save to specified path
        if outputPath:
            wget.download(url, outputPath)
        else:
            wget.download(url)
        return {"success": True, "message": "Download completed successfully."}
    except Exception as e:
        return {"success": False, "message": f"Download failed: {e}"}


## inputs
# filename of position data
filenamPositionData = "20220428-114946_DFZ00_TLS_v001_created-20220429-065432.rcmdx"

# filename of video data
filenameVideoData = "20220428-114946_DFZ00_TVS_v001_created-20220429-065432.rcmdx"

# filename of image data
filenameImgData = "20220428-114946_DFZ00_TSIMS-RAW-COMP_v001_created-20220429-065432.rcmdx"

# filename of track geometry data
filenameGeometryData = "20220428-114946_DFZ00_TGMS_v003_created-20220429-065432.rcmdx"

## main

# We create a folder named 'data' to store the loaded RCMDX demo files
if not os.path.exists("data"):
    os.makedirs("data")

# load position Data from web page
wgetDownload(
    url="https://rcmdx.files.sbb.ch/" + filenamPositionData,
    outputPath=os.path.join(os.curdir, "data", filenamPositionData),
)

# load video Data from web page
wgetDownload(
    url="https://rcmdx.files.sbb.ch/" + filenameVideoData,
    outputPath=os.path.join(os.curdir, "data", filenameVideoData),
)

# load Image Data from web page
wgetDownload(
    url="https://rcmdx.files.sbb.ch/" + filenameImgData,
    outputPath=os.path.join(os.curdir, "data", filenameImgData),
)

# load Geometry Data from web page
wgetDownload(
    url="https://rcmdx.files.sbb.ch/" + filenameGeometryData,
    outputPath=os.path.join(os.curdir, "data", filenameGeometryData),
)
