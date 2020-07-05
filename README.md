# copy_photos
PowerShell script to copy photos to tree folder structure and change.

This script has two optional parameters:
-From: a folder from which the files will be taken;
-To: a folder to which the files will be copied.

By default -From directs to folder C:\Test. In case if it doesn't exist, the folder will be created. -To directs to disk D:\ by default.

The script will copy images with file extensions *.jpeg, *.png, *.gif, *.jpg, *.bmp, *.png,*.tiff,*.heic and video files with extensions *.mp4, *.avi, *.wmv, *.mpg.

For images (except *.heic) EXIF data will be checked first. If date a photo was taken is not found, change date from file metadata will be taken.
For video files only metadata is concerned.
