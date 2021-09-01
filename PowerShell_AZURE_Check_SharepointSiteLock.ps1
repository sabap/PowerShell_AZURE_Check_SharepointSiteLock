If ($null -eq (Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable | Select-Object Name,Version)) {Install-Module -Name Microsoft.Online.SharePoint.PowerShell}
Connect-SPOService -Url https://sgmc365-admin.sharepoint.com

Function FetchSharepointSite {
    $Global:UserToSearch = Read-Host -Prompt "Please enter the user's email address or AD Username"
    If ($Global:UserToSearch -notlike "*@*.*")
        {
        $Global:UserToSearch = Get-ADUser $Global:UserToSearch -Properties EmailAddress | Select-Object EmailAddress
        $Global:UserToSearch = $Global:UserToSearch.EmailAddress
        }
}
Do {
    $Continue = "N"
    Clear-Host
    FetchSharepointSite
    Write-Host "Fetching Sharepoint site for $Global:UserToSearch ..."
    Write-Host ""
    $UserSite = Get-SPOSite -IncludePersonalSite:$true -Limit ALL | Where-Object Owner -eq $Global:UserToSearch | Select-Object LockState, Url, Status, Title, Owner
    Write-Host "_______________________________________________________________________"
    Write-Host "Site Title - "$UserSite.Title
    Write-Host "Site Status - "$UserSite.Status
    Write-Host "Site Owner - "$UserSite.Owner
    Write-Host "Site URL - "$UserSite.Url
    If ($UserSite.LockState -eq "Unlock"){Write-Host "UNLOCKED" -ForegroundColor Green}
    If ($UserSite.LockState -eq "NoAccess"){Write-Host "LOCKED" -ForegroundColor Red}
    Write-Host "_______________________________________________________________________"
    Write-Host ""
    Write-Host "*******************************************************" -ForegroundColor Yellow
    Write-Host "**                 MAKE A SELECTION                  **" -ForegroundColor Yellow
    If ($UserSite.LockState -eq "NoAccess"){Write-Host "**  1. Unlock the Sharepoint Site                    **" -ForegroundColor Yellow}
    If ($UserSite.LockState -eq "Unlock"){Write-Host "**  1. Lock the Sharepoint Site                      **" -ForegroundColor Yellow}
    Write-Host "**  2. Search for another Site                       **" -ForegroundColor Yellow
    Write-Host "**  3. Exit                                          **" -ForegroundColor Yellow
    Write-Host "**                                                   **" -ForegroundColor Yellow
    Write-Host "*******************************************************" -ForegroundColor Yellow
    $Selection = Read-Host "Enter your selection"
    If ($Selection -eq "1")
        {
        If ($UserSite.LockState -eq "NoAccess")
            {
            Set-SPOSite -Identity $UserSite.Url -LockState "Unlock"
            Write-Host "Site UNLOCKED"
            $Continue = Read-Host -Prompt "Would you like to manage another site? [Y/N]"
            }
        If ($UserSite.LockState -eq "Unlock")
            {
            Set-SPOSite -Identity $UserSite.Url -LockState "NoAccess"
            Write-Host "Site LOCKED"
            $Continue = Read-Host -Prompt "Would you like to manage another site? [Y/N]"
            }
        }
    If ($Selection -eq "2"){$Continue = "Y"}
    If ($Selection -eq "3"){Exit}
} While ($Continue = "Y")


# SIG # Begin signature block
# MIIZxgYJKoZIhvcNAQcCoIIZtzCCGbMCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmXiwmB1TGVVDLZ2Kqn1rsOqC
# 6dygghTUMIIE/jCCA+agAwIBAgIQDUJK4L46iP9gQCHOFADw3TANBgkqhkiG9w0B
# AQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFz
# c3VyZWQgSUQgVGltZXN0YW1waW5nIENBMB4XDTIxMDEwMTAwMDAwMFoXDTMxMDEw
# NjAwMDAwMFowSDELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMu
# MSAwHgYDVQQDExdEaWdpQ2VydCBUaW1lc3RhbXAgMjAyMTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAMLmYYRnxYr1DQikRcpja1HXOhFCvQp1dU2UtAxQ
# tSYQ/h3Ib5FrDJbnGlxI70Tlv5thzRWRYlq4/2cLnGP9NmqB+in43Stwhd4CGPN4
# bbx9+cdtCT2+anaH6Yq9+IRdHnbJ5MZ2djpT0dHTWjaPxqPhLxs6t2HWc+xObTOK
# fF1FLUuxUOZBOjdWhtyTI433UCXoZObd048vV7WHIOsOjizVI9r0TXhG4wODMSlK
# XAwxikqMiMX3MFr5FK8VX2xDSQn9JiNT9o1j6BqrW7EdMMKbaYK02/xWVLwfoYer
# vnpbCiAvSwnJlaeNsvrWY4tOpXIc7p96AXP4Gdb+DUmEvQECAwEAAaOCAbgwggG0
# MA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsG
# AQUFBwMIMEEGA1UdIAQ6MDgwNgYJYIZIAYb9bAcBMCkwJwYIKwYBBQUHAgEWG2h0
# dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAfBgNVHSMEGDAWgBT0tuEgHf4prtLk
# YaWyoiWyyBc1bjAdBgNVHQ4EFgQUNkSGjqS6sGa+vCgtHUQ23eNqerwwcQYDVR0f
# BGowaDAyoDCgLoYsaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL3NoYTItYXNzdXJl
# ZC10cy5jcmwwMqAwoC6GLGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9zaGEyLWFz
# c3VyZWQtdHMuY3JsMIGFBggrBgEFBQcBAQR5MHcwJAYIKwYBBQUHMAGGGGh0dHA6
# Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBPBggrBgEFBQcwAoZDaHR0cDovL2NhY2VydHMu
# ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0U0hBMkFzc3VyZWRJRFRpbWVzdGFtcGluZ0NB
# LmNydDANBgkqhkiG9w0BAQsFAAOCAQEASBzctemaI7znGucgDo5nRv1CclF0CiNH
# o6uS0iXEcFm+FKDlJ4GlTRQVGQd58NEEw4bZO73+RAJmTe1ppA/2uHDPYuj1UUp4
# eTZ6J7fz51Kfk6ftQ55757TdQSKJ+4eiRgNO/PT+t2R3Y18jUmmDgvoaU+2QzI2h
# F3MN9PNlOXBL85zWenvaDLw9MtAby/Vh/HUIAHa8gQ74wOFcz8QRcucbZEnYIpp1
# FUL1LTI4gdr0YKK6tFL7XOBhJCVPst/JKahzQ1HavWPWH1ub9y4bTxMd90oNcX6X
# t/Q/hOvB46NJofrOp79Wz7pZdmGJX36ntI5nePk2mOHLKNpbh6aKLzCCBTAwggQY
# oAMCAQICEAQJGBtf1btmdVNDtW+VUAgwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UE
# BhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2lj
# ZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4X
# DTEzMTAyMjEyMDAwMFoXDTI4MTAyMjEyMDAwMFowcjELMAkGA1UEBhMCVVMxFTAT
# BgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEx
# MC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIENvZGUgU2lnbmluZyBD
# QTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAPjTsxx/DhGvZ3cH0wsx
# SRnP0PtFmbE620T1f+Wondsy13Hqdp0FLreP+pJDwKX5idQ3Gde2qvCchqXYJawO
# eSg6funRZ9PG+yknx9N7I5TkkSOWkHeC+aGEI2YSVDNQdLEoJrskacLCUvIUZ4qJ
# RdQtoaPpiCwgla4cSocI3wz14k1gGL6qxLKucDFmM3E+rHCiq85/6XzLkqHlOzEc
# z+ryCuRXu0q16XTmK/5sy350OTYNkO/ktU6kqepqCquE86xnTrXE94zRICUj6whk
# PlKWwfIPEvTFjg/BougsUfdzvL2FsWKDc0GCB+Q4i2pzINAPZHM8np+mM6n9Gd8l
# k9ECAwEAAaOCAc0wggHJMBIGA1UdEwEB/wQIMAYBAf8CAQAwDgYDVR0PAQH/BAQD
# AgGGMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHkGCCsGAQUFBwEBBG0wazAkBggrBgEF
# BQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRw
# Oi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0Eu
# Y3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20v
# RGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsMDqgOKA2hjRodHRwOi8vY3JsMy5k
# aWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3JsME8GA1UdIARI
# MEYwOAYKYIZIAYb9bAACBDAqMCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdp
# Y2VydC5jb20vQ1BTMAoGCGCGSAGG/WwDMB0GA1UdDgQWBBRaxLl7KgqjpepxA8Bg
# +S32ZXUOWDAfBgNVHSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG
# 9w0BAQsFAAOCAQEAPuwNWiSz8yLRFcgsfCUpdqgdXRwtOhrE7zBh134LYP3DPQ/E
# r4v97yrfIFU3sOH20ZJ1D1G0bqWOWuJeJIFOEKTuP3GOYw4TS63XX0R58zYUBor3
# nEZOXP+QsRsHDpEV+7qvtVHCjSSuJMbHJyqhKSgaOnEoAjwukaPAJRHinBRHoXpo
# aK+bp1wgXNlxsQyPu6j4xRJon89Ay0BEpRPw5mQMJQhCMrI2iiQC/i9yfhzXSUWW
# 6Fkd6fp0ZGuy62ZD2rOwjNXpDd32ASDOmTFjPQgaGLOBm0/GkxAG/AeB+ova+YJJ
# 92JuoVP6EpQYhS6SkepobEQysmah5xikmmRR7zCCBTEwggQZoAMCAQICEAqhJdbW
# Mht+QeQF2jaXwhUwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UEBhMCVVMxFTATBgNV
# BAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIG
# A1UEAxMbRGlnaUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTE2MDEwNzEyMDAw
# MFoXDTMxMDEwNzEyMDAwMFowcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lD
# ZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGln
# aUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQTCCASIwDQYJKoZI
# hvcNAQEBBQADggEPADCCAQoCggEBAL3QMu5LzY9/3am6gpnFOVQoV7YjSsQOB0Uz
# URB90Pl9TWh+57ag9I2ziOSXv2MhkJi/E7xX08PhfgjWahQAOPcuHjvuzKb2Mln+
# X2U/4Jvr40ZHBhpVfgsnfsCi9aDg3iI/Dv9+lfvzo7oiPhisEeTwmQNtO4V8CdPu
# XciaC1TjqAlxa+DPIhAPdc9xck4Krd9AOly3UeGheRTGTSQjMF287DxgaqwvB8z9
# 8OpH2YhQXv1mblZhJymJhFHmgudGUP2UKiyn5HU+upgPhH+fMRTWrdXyZMt7HgXQ
# hBlyF/EXBu89zdZN7wZC/aJTKk+FHcQdPK/P2qwQ9d2srOlW/5MCAwEAAaOCAc4w
# ggHKMB0GA1UdDgQWBBT0tuEgHf4prtLkYaWyoiWyyBc1bjAfBgNVHSMEGDAWgBRF
# 66Kv9JLLgjEtUYunpyGd823IDzASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB
# /wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB5BggrBgEFBQcBAQRtMGswJAYI
# KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBDBggrBgEFBQcwAoY3
# aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9v
# dENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2NybDQuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDigNoY0aHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDBQBgNV
# HSAESTBHMDgGCmCGSAGG/WwAAgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cu
# ZGlnaWNlcnQuY29tL0NQUzALBglghkgBhv1sBwEwDQYJKoZIhvcNAQELBQADggEB
# AHGVEulRh1Zpze/d2nyqY3qzeM8GN0CE70uEv8rPAwL9xafDDiBCLK938ysfDCFa
# KrcFNB1qrpn4J6JmvwmqYN92pDqTD/iy0dh8GWLoXoIlHsS6HHssIeLWWywUNUME
# aLLbdQLgcseY1jxk5R9IEBhfiThhTWJGJIdjjJFSLK8pieV4H9YLFKWA1xJHcLN1
# 1ZOFk362kmf7U2GJqPVrlsD0WGkNfMgBsbkodbeZY4UijGHKeZR+WfyMD+NvtQEm
# tmyl7odRIeRYYJu6DC0rbaLEfrvEJStHAgh8Sa4TtuF8QkIoxhhWz0E0tmZdtnR7
# 9VYzIi8iNrJLokqV2PWmjlIwggVlMIIETaADAgECAhAJxv/QnBC46R7MSSFut0Jb
# MA0GCSqGSIb3DQEBCwUAMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lD
# ZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EwHhcNMjEwMzE2MDAw
# MDAwWhcNMjIwMzIwMjM1OTU5WjCBojELMAkGA1UEBhMCVVMxEDAOBgNVBAgTB0dl
# b3JnaWExETAPBgNVBAcTCFZhbGRvc3RhMTYwNAYDVQQKEy1Tb3V0aCBHZW9yZ2lh
# IE1lZGljYWwgQ2VudGVyIEZvdW5kYXRpb24sIEluYy4xNjA0BgNVBAMTLVNvdXRo
# IEdlb3JnaWEgTWVkaWNhbCBDZW50ZXIgRm91bmRhdGlvbiwgSW5jLjCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAMsoHiQGx6XndY7pz1s+AEMc3piiN1/1
# Zfz0Omu/YbEOQmwOdxXiGOhb9B/9X9bFQo2SE6UOHzM91rlB/FSqx6Pa4UJtg5p/
# +NQm3L2qu3zYV4UsDaH0HGk+xQ0K5Gl0CJ3EhWnXt9T3xQMcrbsUc05eIg2I6kxO
# tKNEC1u0PEXdD7GOOpUeO/D1cAaKy2Ia0WNjLV9gGAbfB+r619+uirWSykVICI7J
# SgTgkmiEFMTeDqK9DkZauazvwZA+ZuH41gtoUMTTbgM7P6c+YiAgL7MMZ5XKGGog
# QIMPMkRyfbEsiNw9x5STe+1Hvr6MjvN5be882jZNuhx4b8cCJTMfmOECAwEAAaOC
# AcQwggHAMB8GA1UdIwQYMBaAFFrEuXsqCqOl6nEDwGD5LfZldQ5YMB0GA1UdDgQW
# BBQj3iq2ZKBWiXnnKdAr/q/SsGChJzAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwdwYDVR0fBHAwbjA1oDOgMYYvaHR0cDovL2NybDMuZGlnaWNl
# cnQuY29tL3NoYTItYXNzdXJlZC1jcy1nMS5jcmwwNaAzoDGGL2h0dHA6Ly9jcmw0
# LmRpZ2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtY3MtZzEuY3JsMEsGA1UdIAREMEIw
# NgYJYIZIAYb9bAMBMCkwJwYIKwYBBQUHAgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQu
# Y29tL0NQUzAIBgZngQwBBAEwgYQGCCsGAQUFBwEBBHgwdjAkBggrBgEFBQcwAYYY
# aHR0cDovL29jc3AuZGlnaWNlcnQuY29tME4GCCsGAQUFBzAChkJodHRwOi8vY2Fj
# ZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRTSEEyQXNzdXJlZElEQ29kZVNpZ25p
# bmdDQS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAQEAdg+/Prqk
# txudfkA+/YQXp2FrWA6m+21SjDL/Hoa1PFOvmpvgC+vQ4AwXnQFPwdn1Kp5OFz1f
# wqKc8T5N8MVsePNhRNO5ViCsBGFSBfhmYStIHarYFgkyOQD/JP8r4S8MIftdJxtD
# zn4Ao+UyXCoHi+zy8X5bJ9V/ttcwvgYItekz4KBGYv5hidPvbMXBU0lIXNNfTr+q
# 8xOH0nihCRXTW9uXh0aVsyC14q7+VolhUaQyGpLcNyn2UJUd+54QIvqEmpnAk+Y+
# UxRnuuT9oIKG5sn1m9RO/bPgMD+gFr+6T3jfwZlGBUByRl2EX5tc0qUXoPNxMIKE
# heKWKHOgDGeP+DGCBFwwggRYAgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNV
# BAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0ECEAnG
# /9CcELjpHsxJIW63QlswCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKA
# AKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFJ1Pe6l8oD5LFtcdN/wPicql
# U660MA0GCSqGSIb3DQEBAQUABIIBAERTjMuninYskmjOmluQVgXBKnS97DrxY738
# Kpq98OCRVz0muOKUAIspSJEcJ79hXfSycqMdu5jPth16zrlNyL2ZHyYMPtPPr/TN
# bQjnGC3hSVo+DdmGGG2YycA2JTF0oiIsRshxEvjw+H5gVGoXQGctzoKWB3Ztyb8f
# Pvq2CFgBKdz3qmGg31B0yjzCx0R6P5lXm4HoKXhvQlqe4Q9i1s8jJHNP4Kp3Oa48
# KE+CYg7+JJG8lpkJ48cBqry0MvlQ5RRQCKNsMoJkcEuK30k4nZWjxYIGckmwuwhI
# IkxwephAuV4pRGR+hANQiNew/3uVRo2sRGbgOC9KV0s4jIiCQ2qhggIwMIICLAYJ
# KoZIhvcNAQkGMYICHTCCAhkCAQEwgYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoT
# DERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UE
# AxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQQIQDUJK
# 4L46iP9gQCHOFADw3TANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3DQEJAzELBgkq
# hkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkwMTE4NTEwM1owLwYJKoZIhvcN
# AQkEMSIEIG0ea0/UNQVCkJAQb1QhI82M6FJN1rUrh7zPU5W7pmltMA0GCSqGSIb3
# DQEBAQUABIIBALgmv6kKmxhhJmNSRWeCkiU656FV9DJn6+5Lals+u3KhQJjUzJZB
# AFbxZO2WoQGf4Y2KCDvAxXK80mVCsWrH6YASBi4T5VLHiHv3yylhsVF7fgTeASx+
# K+lh4QHhWO7HA63ov/76yy3Uwi4RjjN2ut5P4RW02f2j2XyGngH0fvEQD5LYVzNC
# vVdKmaHvShO6DE0OkIT1E/svm88M/8aiBKQfoayGozAKJhNjChsyX2u1MDaSxIRe
# 6z23bf2xxI1epxAinACYc0mZEXwbPIz8bYenFZX2w7FqY0y3RzqeNg3OeEO8x0xV
# yYUMHWQ/T1TGH0oyMj2fBsqBk+7+M9Wm+yk=
# SIG # End signature block
