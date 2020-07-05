param([string]$From='D:\',[string]$To='C:\Test\')

$ImgsFound = gci -Path $From -Include *.jpeg, *.png, *.gif, *.jpg, *.bmp, *.png, *.mov, *.tiff, *.heic, *.mp4, *.avi, *.wmv, *.mpg -Recurse | select -Property FullName, Name, BaseName, Extension

Write-Host -Object ("# of pictures suitable for renaming in " + $Path + ": " + $ImgsFound.Count + "`n") 
$videoFormats = ".mov", ".mp4", ".avi", ".wmv", ".mpg", ".MOV", ".MP4", ".AVI", ".WMV", ".MPG", ".heic", ".HEIC"

foreach ($Img in $ImgsFound)
{	
	if (-Not $videoFormats.Contains([System.IO.Path]::GetExtension($Img.Name)))
	{
		$ImgData = New-Object System.Drawing.Bitmap($Img.FullName) 
		try 
		{
			[byte[]]$ImgBytes = $ImgData.GetPropertyItem(36867).Value 
			[string]$dateString = [System.Text.Encoding]::ASCII.GetString($ImgBytes)
			$year = $dateString.SubString(0,4)
			$month = $dateString.SubString(5,2)
			[string]$dateTaken = [datetime]::ParseExact($dateString,"yyyy:MM:dd HH:mm:ss`0",$Null).ToString('yyyy-MM-dd_HH.mm.ss.ms') 
		}
		catch [System.Management.Automation.MethodInvocationException], [System.InvalidOperationException]
		{
			[string]$ErrorMessage = (
				(Get-Date).ToString('yyyyMMdd HH:mm:ss') + " EXIF date not found. Taking file change date for " + $Img.Name
			)
			Write-Host -ForegroundColor Yellow -Object $ErrorMessage
			$Item = Get-Item $Img.FullName
			$year = Get-Date -Date $Item.LastWriteTime -Format yyyy
			$month = Get-Date -Date $Item.LastWriteTime -Format MM
			[string]$dateTaken = Get-Date -Date $Item.LastWriteTime -Format 'yyyy-MM-dd_HH.mm.ss.ms'
		}
	}
	else
	{
	[string]$Message = (
				(Get-Date).ToString('yyyyMMdd HH:mm:ss') + " Video file. Taking file change date for " + $Img.Name
			)
			Write-Host -ForegroundColor Yellow -Object $Message
			$Item = Get-Item $Img.FullName
			$year = Get-Date -Date $Item.LastWriteTime -Format yyyy
			$month = Get-Date -Date $Item.LastWriteTime -Format MM
			[string]$dateTaken = Get-Date -Date $Item.LastWriteTime -Format 'yyyy-MM-dd_HH.mm.ss.ms'
	}
	[string]$NewFileName = $dateTaken + [System.IO.Path]::GetExtension($Img.Name)
	if (-Not $videoFormats.Contains([System.IO.Path]::GetExtension($Img.Name)))
	{
		$ImgData.Dispose() 
	}
#	Rename-Item -NewName $NewFileName -Path $Img.FullName -ErrorAction Stop 
	Write-Host -Object ("Renamed " + $Img.Name + " to " + $NewFileName) 
	
	$num = 1
	while(Test-Path -Path $To\$year\$month\$NewFileName)
	{
	   $NewFileName = $dateTaken + "_"+ $num + [System.IO.Path]::GetExtension($Img.Name)  
	   $num+=1   
	}
	ni $To\$year\$month\$NewFileName -Force
	cp $Img.FullName $To\$year\$month\$NewFileName -Force
}