#------------------------------------------------------------------#
#- Clear-WindowsUserCacheFiles                                     #
#------------------------------------------------------------------#
Function Clear-WindowsUserCacheFiles {
    param([string]$localAppData=$env:LOCALAPPDATA)
    Remove-CacheFiles "$localAppData\Temp"
    Remove-CacheFiles "$localAppData\Microsoft\Windows\WER"
    Remove-CacheFiles "$localAppData\Microsoft\Windows\Temporary Internet Files"    
}

#------------------------------------------------------------------#
#- Clear-GlobalWindowsCache                                        #
#------------------------------------------------------------------#
Function Clear-GlobalWindowsCache {
    Remove-CacheFiles 'C:\Windows\Temp' 
    Remove-CacheFiles "C:\`$Recycle.Bin"
    Remove-CacheFiles "C:\Windows\Prefetch"
    C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 255
    C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351
}

#------------------------------------------------------------------#
#- Clear-DownloadFolder                                            #
#------------------------------------------------------------------#
Function Clear-DownloadFolder {
    param([string]$user=$env:USERNAME)
    Remove-CacheFiles "C:\users\$user\Downloads"
}

#------------------------------------------------------------------#
#- Clear-ChromeCache                                               #
#------------------------------------------------------------------#
Function Clear-ChromeCache {
    param([string]$localAppData=$env:LOCALAPPDATA)

    $folders = Get-ChildItem "$($localAppData)\Google\Chrome\User Data" | ?{ $_.PSIsContainer -and $_.Name -eq "Default" -or $_.Name -like "Profile*"}
    
    ForEach ($chromeFolder in $folders) {
        $chromeAppData = "$($localAppData)\Google\Chrome\User Data\$chromeFolder"
        if((Test-Path "$chromeAppData"))
        {
            $possibleCachePaths = @('Cache','Cache2\entries\','Cookies','History','Top Sites','VisitedLinks','Web Data','Media Cache','Cookies-Journal','ChromeDWriteFontCache')
            ForEach($cachePath in $possibleCachePaths)
            {
                Remove-CacheFiles "$chromeAppData\$cachePath"
            }      
        }
    } 
}

#------------------------------------------------------------------#
#- Clear-EdgeCache #
#------------------------------------------------------------------#
Function Clear-EdgeCache {
    param([string]$localAppData=$env:LOCALAPPDATA)

    if((Test-Path "$localAppData\Microsoft\Edge\User Data\Default"))
    {
        $edgeAppData = "$localAppData\Microsoft\Edge\User Data\Default"
        $possibleCachePaths = @('Cache','Cache2\entries','Cookies','History','Top Sites','Visited Links','Web Data','Media History','Cookies-Journal')
        ForEach($cachePath in $possibleCachePaths)
        {
            Remove-CacheFiles "$edgeAppData\$cachePath"
        }
    }
}

#------------------------------------------------------------------#
#- Clear-UserCacheFiles                                            #
#------------------------------------------------------------------#
Function Clear-UserCacheFiles {
    $localUser = $env:UserName
    Kill-BrowserSessions
    Clear-ChromeCache
    Clear-FirefoxCache
    Clear-EdgeCache
    Clear-DownloadFolder
}

#------------------------------------------------------------------#
#- Clear-FirefoxCacheFiles                                         #
#------------------------------------------------------------------#
Function Clear-FirefoxCache {
    param([string]$localAppData=$env:LOCALAPPDATA)

    if((Test-Path "$localAppData\Mozilla\Firefox\Profiles"))
    {
        $possibleCachePaths = @('cache','cache2\entries','thumbnails','cookies.sqlite','webappsstore.sqlite','chromeappstore.sqlite','places.sqlite')
        $firefoxLocalAppDataProfiles = (Get-ChildItem "$localAppData\Mozilla\Firefox\Profiles" | Where-Object { $_.Name -match 'Default' }[0]).FullName
        ForEach($profile in $firefoxLocalAppDataProfiles)
        {
            ForEach($cachePath in $possibleCachePaths)
            {
                Remove-CacheFiles "$profile\$cachePath"
            }
        }
    }

    $appData = $env:APPDATA
    if((Test-Path "$appData\Mozilla\Firefox\Profiles"))
    {
        $possibleCachePaths = @('cache','cache2\entries','thumbnails','cookies.sqlite','webappsstore.sqlite','chromeappstore.sqlite','places.sqlite')
        $firefoxRoamingAppDataProfiles = (Get-ChildItem "$appData\Mozilla\Firefox\Profiles" | Where-Object { $_.Name -match 'Default' }[0]).FullName
        ForEach($profile in $firefoxRoamingAppDataProfiles)
        {
            ForEach($cachePath in $possibleCachePaths)
            {
                Remove-CacheFiles "$profile\$cachePath"
            }
        }
    } 
}

#------------------------------------------------------------------#
#- Kill-BrowserSessions                                            #
#------------------------------------------------------------------#
Function Kill-BrowserSessions {
    $activeBrowsers = Get-Process Firefox*,Chrome*,Edge*
    ForEach($browserProcess in $activeBrowsers)
    {
        try 
        {
            $browserProcess.CloseMainWindow() | Out-Null 
        } catch { }
    }
}

#------------------------------------------------------------------#
#- Remove-CacheFiles                                               #
#------------------------------------------------------------------#
Function Remove-CacheFiles {
    param([Parameter(Mandatory=$true)][string]$path)    
    BEGIN 
    {
        $originalVerbosePreference = $VerbosePreference
        $VerbosePreference = 'Continue'  
    }
    PROCESS 
    {
     Write-Host "$path test-path = $(Test-Path $path)"
        if((Test-Path -Path $path))
        {
            Write-Host "Path-tested $path"
            if([System.IO.Directory]::Exists($path))
            {
                Write-Host "Directory::exists $path"
                try 
                {
                    if($path[-1] -eq '\')
                    {
                        [int]$pathSubString = $path.ToCharArray().Count - 1
                        $sanitizedPath = $path.SubString(0, $pathSubString)
                        Remove-Item -Path "$sanitizedPath\*" -Recurse -Force -ErrorAction SilentlyContinue -Verbose
                    }
                    else 
                    {
                        Remove-Item -Path "$path\*" -Recurse -Force -ErrorAction SilentlyContinue -Verbose              
                    } 
                } catch { }
            }
            else 
            {
                try 
                {
                    Write-Host "File to delete : $path"
                    Remove-Item -Path $path -Force -ErrorAction SilentlyContinue -Verbose
                } catch { }
            }
        }    
    }
    END 
    {
        $VerbosePreference = $originalVerbosePreference
    }
}

#------------------------------------------------------------------#
#- MAIN                                                            #
#------------------------------------------------------------------#

Clear-UserCacheFiles
Clear-GlobalWindowsCache