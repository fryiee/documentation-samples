param($installPath, $toolsPath, $package, $project)

 # This is the MSBuild targets file to add
    $targetsFile = [System.IO.Path]::Combine($toolsPath, 'RazorGenerator.MsBuild.targets')

    # Need to load MSBuild assembly if it's not loaded yet.
    Add-Type -AssemblyName 'Microsoft.Build, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
    # Grab the loaded MSBuild project for the project
    $msbuild = [Microsoft.Build.Evaluation.ProjectCollection]::GlobalProjectCollection.GetLoadedProjects($project.FullName) | Select-Object -First 1
    $projPath = Split-Path $project.FileName;

    if(Test-Path (Join-Path $projPath "Build\RazorGenerator.MsBuild\build\RazorGenerator.MsBuild.targets")){
        # Add the import and save the project
        $msbuild.Xml.AddImport("Build\RazorGenerator.MsBuild\build\RazorGenerator.MsBuild.targets") | out-null
    }

    if(Test-Path (Join-Path $projPath "Build\FeatherPrecompilation.targets")){
        # Add the import and save the project
        $msbuild.Xml.AddImport("Build\FeatherPrecompilation.targets") | out-null
    }
    $project.Save()
	
	$assemblyInfoPath = Join-Path $projPath "Properties\AssemblyInfo.cs"
	if (Test-Path $assemblyInfoPath)
	{
		$assemblyInfoPathTemp = "$assemblyInfoPath.tmp"
		$controllerContainerRegex = "\[\s*assembly\s*\:\s*(?:(?:(?:(?:(?:(?:(?:Telerik\.)?Sitefinity\.)?Frontend\.)?Mvc\.)?Infrastructure\.)?Controllers\.)?Attributes\.)?ControllerContainer(?:Attribute)?\s*\]"
        $resourcePackageRegex = "\[\s*assembly\s*\:\s*(?:(?:(?:(?:(?:(?:(?:Telerik\.)?Sitefinity\.)?Frontend\.)?Mvc\.)?Infrastructure\.)?Controllers\.)?Attributes\.)?ResourcePackage(?:Attribute)?\s*\]"
		Get-Content $assemblyInfoPath | ? { $_ -notmatch $controllerContainerRegex } | ? { $_ -notmatch $resourcePackageRegex } | Set-Content $assemblyInfoPathTemp -Force
		Remove-Item $assemblyInfoPath
		Rename-Item $assemblyInfoPathTemp $assemblyInfoPath
	}

# SIG # Begin signature block
# MIIXnAYJKoZIhvcNAQcCoIIXjTCCF4kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2LuZU3r8VEYWq5QzN3nCrPIJ
# 9iCgghK8MIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggTUMIIDvKADAgECAhB5ded51rMwoW/To4csnLVUMA0GCSqGSIb3DQEBCwUAMIGE
# MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xHzAd
# BgNVBAsTFlN5bWFudGVjIFRydXN0IE5ldHdvcmsxNTAzBgNVBAMTLFN5bWFudGVj
# IENsYXNzIDMgU0hBMjU2IENvZGUgU2lnbmluZyBDQSAtIEcyMB4XDTE4MDUwMzAw
# MDAwMFoXDTE4MTIyMjIzNTk1OVowZjELMAkGA1UEBhMCQkcxDjAMBgNVBAgMBVNv
# ZmlhMQ4wDAYDVQQHDAVTb2ZpYTEUMBIGA1UECgwLVEVMRVJJSyBFQUQxCzAJBgNV
# BAsMAklUMRQwEgYDVQQDDAtURUxFUklLIEVBRDCCASIwDQYJKoZIhvcNAQEBBQAD
# ggEPADCCAQoCggEBAOWW+Tp+4PgZN9CyAjElsN0psKK+dLDO0FqELfgwXcIE1axv
# WgtCLSQ/1rN8WIxC8Tfu3fFNcqccOsNjP22pKgBsVF1iwzQjIQ895376gZSjvlLo
# UMV3WTV8xcvwPP7VFPmMJ8xYd5LjcKXHqaXSNM4yqSUSRjJ9PJD3QJoReOr+AGXM
# n7xKJNXVvcRJ05hqnTSZ1qZCYoS/0t3PfWXyOJ8S2u1DnGr8dvcEU/uFYpe/k/YV
# HnPQZ6JwO8GtB8pTJLTNRL/aN/QYHVhfXT5CMX/8q2+QdAXaj7mYNpfr3r+pIVTF
# UI/8mmGIXBIicNYHADVvaFT7N93W4TWmNBXHHVECAwEAAaOCAV0wggFZMAkGA1Ud
# EwQCMAAwDgYDVR0PAQH/BAQDAgeAMCsGA1UdHwQkMCIwIKAeoByGGmh0dHA6Ly9y
# Yi5zeW1jYi5jb20vcmIuY3JsMGEGA1UdIARaMFgwVgYGZ4EMAQQBMEwwIwYIKwYB
# BQUHAgEWF2h0dHBzOi8vZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkMF2h0
# dHBzOi8vZC5zeW1jYi5jb20vcnBhMBMGA1UdJQQMMAoGCCsGAQUFBwMDMFcGCCsG
# AQUFBwEBBEswSTAfBggrBgEFBQcwAYYTaHR0cDovL3JiLnN5bWNkLmNvbTAmBggr
# BgEFBQcwAoYaaHR0cDovL3JiLnN5bWNiLmNvbS9yYi5jcnQwHwYDVR0jBBgwFoAU
# 1MAGIknrOUvdk+JcobhHdglyA1gwHQYDVR0OBBYEFKjafrVTZQvLodzhkK2E2QF/
# G94SMA0GCSqGSIb3DQEBCwUAA4IBAQAVjO76Huz5G/CPBMbLrnnZz+BmT+Ht9NO+
# lqlcJkKDsp01L8bAcPyXXGXRlHv1FFVrRttxB82YqKXFad/lgPosyNDRkBu8pyP6
# uRqBHnSMZYM/gUJ1Z/ac+I83cgwIHxqlLauydqslevXjl96a0yOTyAnFNH1iKFtW
# RcFMQKZKcFgiGx6oul9mAnFfzUhJkn36GQqSmUBwZ+CwAUJrxj08P0cHNnfZdHE+
# JKXlk2VgqR6l1x4//aLo557b0K1lBc6PtjvQ5AmRVUu9TsQiCLMi/8FHckLbhY8h
# XFMEgd1zJpgW6n9SiVY641qqIIFTsZg4k+CTDL5akMEMeOmpsxNvMIIFRzCCBC+g
# AwIBAgIQfBs1NUrn23TnQV8RacprqDANBgkqhkiG9w0BAQsFADCBvTELMAkGA1UE
# BhMCVVMxFzAVBgNVBAoTDlZlcmlTaWduLCBJbmMuMR8wHQYDVQQLExZWZXJpU2ln
# biBUcnVzdCBOZXR3b3JrMTowOAYDVQQLEzEoYykgMjAwOCBWZXJpU2lnbiwgSW5j
# LiAtIEZvciBhdXRob3JpemVkIHVzZSBvbmx5MTgwNgYDVQQDEy9WZXJpU2lnbiBV
# bml2ZXJzYWwgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xNDA3MjIw
# MDAwMDBaFw0yNDA3MjEyMzU5NTlaMIGEMQswCQYDVQQGEwJVUzEdMBsGA1UEChMU
# U3ltYW50ZWMgQ29ycG9yYXRpb24xHzAdBgNVBAsTFlN5bWFudGVjIFRydXN0IE5l
# dHdvcmsxNTAzBgNVBAMTLFN5bWFudGVjIENsYXNzIDMgU0hBMjU2IENvZGUgU2ln
# bmluZyBDQSAtIEcyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA15VD
# 1NzfZ645+1KktiYxBHDpt45bKro3aTWVj7vAMOeG2HO73+vRdj+KVo7rLUvwVxhO
# sY2lM9MLdSPVankn3aPT9w6HZbXerRzx9TW0IlGvIqHBXUuQf8BZTqudeakC1x5J
# sTtNh/7CeKu/71KunK8I2TnlmlE+aV8wEE5xY2xY4fAgMxsPdL5byxLh24zEgJRy
# u/ZFmp7BJQv7oxye2KYJcHHswEdMj33D3hnOPu4Eco4X0//wsgUyGUzTsByf/qV4
# IEJwQbAmjG8AyDoAEUF6QbCnipEEoJl49He082Aq5mxQBLcUYP8NUfSoi4T+Idpc
# Xn31KXlPsER0b21y/wIDAQABo4IBeDCCAXQwLgYIKwYBBQUHAQEEIjAgMB4GCCsG
# AQUFBzABhhJodHRwOi8vcy5zeW1jZC5jb20wEgYDVR0TAQH/BAgwBgEB/wIBADBm
# BgNVHSAEXzBdMFsGC2CGSAGG+EUBBxcDMEwwIwYIKwYBBQUHAgEWF2h0dHBzOi8v
# ZC5zeW1jYi5jb20vY3BzMCUGCCsGAQUFBwICMBkaF2h0dHBzOi8vZC5zeW1jYi5j
# b20vcnBhMDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9zLnN5bWNiLmNvbS91bml2
# ZXJzYWwtcm9vdC5jcmwwEwYDVR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/BAQD
# AgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFTeW1hbnRlY1BLSS0xLTcyNDAd
# BgNVHQ4EFgQU1MAGIknrOUvdk+JcobhHdglyA1gwHwYDVR0jBBgwFoAUtnf6aUhH
# n1MS1cLqBzJ2B9GXBxkwDQYJKoZIhvcNAQELBQADggEBAH/ryqfqi3ZC6z6OIFQw
# 47e53PpIPhbHD0WVEM0nhqNm8wLtcfiqwlWXkXCD+VJ+Umk8yfHglEaAGLuh1KRW
# pvMdAJHVhvNIh+DLxDRoIF60y/kF7ZyvcFMnueg+flGgaXGL3FHtgDolMp9Er25D
# KNMhdbuX2IuLjP6pBEYEhfcVnEsRjcQsF/7Vbn+a4laS8ZazrS359N/aiZnOsjhE
# wPdHe8olufoqaDObUHLeqJ/UzSwLNL2LMHhA4I2OJxuQbxq+CBWBXesv4lHnUR7J
# eCnnHmW/OO8BSgEJJA4WxBR5wUE3NNA9kVKUneFo7wjw4mmcZ26QCxqTcdQmAsPA
# WiMxggRKMIIERgIBATCBmTCBhDELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFu
# dGVjIENvcnBvcmF0aW9uMR8wHQYDVQQLExZTeW1hbnRlYyBUcnVzdCBOZXR3b3Jr
# MTUwMwYDVQQDEyxTeW1hbnRlYyBDbGFzcyAzIFNIQTI1NiBDb2RlIFNpZ25pbmcg
# Q0EgLSBHMgIQeXXnedazMKFv06OHLJy1VDAJBgUrDgMCGgUAoHgwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU4uSqLQCk
# vNwKi/qOmLY4qg5FasMwDQYJKoZIhvcNAQEBBQAEggEAfvV8pmg5LQg7Tbm2u/d9
# 0vpwoVbORzFavVlnaJ73NYy63mjK5Ym0pxUsq5bSl9nMN5HNSG3r+6PpBO0GgKYA
# CVuWKW3oEDM5gfJpaFf6wxZQBtYE57oQmBAQm2ir2y8pPNmKC7BNJ1WM+Bd6ODWk
# gAOkxb8ny4a051nBQMdQCjmtBGwUmKU0V5NtMWnoFeCRksY/v/uX1+ZPfbhNZpgt
# MpthMXfhX/5GA5Iu9mPyZU2dvdq/TXFBFF/shIVinZG5c1rPey0G41zE9AvFcK1l
# XNZzqH7s+17rNWCasq8F3P/3t2ZwoYO8ZgrL224jzAVIdqmIQQmVkifgdq3woWj3
# VqGCAgswggIHBgkqhkiG9w0BCQYxggH4MIIB9AIBATByMF4xCzAJBgNVBAYTAlVT
# MR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEwMC4GA1UEAxMnU3ltYW50
# ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBDQSAtIEcyAhAOz/Q4yP6/NW4E2GqY
# GxpQMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
# SIb3DQEJBTEPFw0xODA1MjgwOTM1MTRaMCMGCSqGSIb3DQEJBDEWBBTD5Yz6vPSu
# RTmrQRlETUxZxJlOWTANBgkqhkiG9w0BAQEFAASCAQAqBiR/DlW9lDVu850CyUMo
# g6MoYkEI1qWhJCXqSBM9Kf2YB4lUu36QRx96miYSSL4J+yx4sIKXtEBwOR/dIcHb
# taxLCX9k1d/cpqUMuARX6OYKpY/qDv8YtrBru67Nfow0rSm5p6oYFPyBH6bZZDTb
# eDvccVCM5CTsKNSyFXUCpS+AYGRkdShmiaiHevfXeFtLa/bqoCXtzheQrlsC+H9R
# Cw4RuI2LJ9JFXrJPwoie6cG+a9HztGGVDGo4FaWwtkZjsf2XRgk0bVedTYuDk6FK
# Hz/A/M1A8nG0xu7EI2uVG7AIr3uepZZYocVh5UXMwToY79XsBnus/57rG/Xk8Yvf
# SIG # End signature block
