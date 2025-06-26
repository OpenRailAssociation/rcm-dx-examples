Minimal Configuration to Use the Python Scripts

Requirements:

- Python 3.11.x
- requirements.txt
You can download Python from the official website: Python Downloads.
https://www.python.org/downloads/

The requirements.txt file specifies the necessary libraries (packages and versions) needed to run the example scripts. To install the required packages, use the following command:

pip install -r requirements.txt

In order to use all the script it will be required to load the application ffmpeg.exe if it doen't exist already on your computer.
you can download it from https://www.ffmpeg.org/download.html#build-windows and locate the .exe in the project folder

## Data Source

The dataset used in this project is provided by SBB (Swiss Federal Railways) and can be accessed from their official website. The data is available at the following link:
https://bahninfrastruktur.sbb.ch/de/produkte-dienstleistungen/bahninformatiksysteme/anlagenmanagement/rail-condition-monitoring.html 

## Rail Condition Monitoring Data

This dataset includes measurement data from various diagnostic systems, such as track geometry and overhead line data, in the RCM-DX open-source format.

## Validity of Scripts

The scripts provided in this repository are specifically designed to work with the dataset from the above source. They have been tested and validated using this data to ensure compatibility and accuracy.

## Use

1-Create a virtual environnement

2-Install the needed python library

3-Load the needed excecutable (ffmpeg.exe)

4-Run the code Load_RCMDX_demo_Data to load the demo Data

5-Run the other codes 

## Script descriptions

**Gen_path_file_rcmdx**: The code generates a path list, which provides an overview of the RCMDX file structure and its available content. It outputs the results as a CSV file.

**Load_demo_data_rcmdx**: This script automatically loads the required demo data from the SBB webpage, which can then be used with other scripts.

**Read_dfz_video_demo**: This script reads and exports images from an RCMDX file according to a defined position. It compiles the images into a video and saves it in a separate folder.

**Read_gdfz_video_demo**: This script reads and exports videos from an RCMDX file according to a defined position. It compiles them into a single video and saves it in a separate folder.

**Read_images_demo**: This script reads and exports images from an RCMDX file according to a defined position. The images are saved in a separate folder.

**Read_time_series_demo**: This script reads and exports data from an RCMDX file according to a defined position. The data is exported as a table and saved in a separate folder.