﻿##############################################
# Demo Preparation
##############################################
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Remove-VIRole -Role "custom*"
Get-VM | Get-Snapshot | Remove-Snapshot
Get-VM | Get-Random -Count 2 | New-Snapshot -Name "Before_Demo_Snaps"

Clear-Host

###############################################
# What is Powershell
###############################################

$PSVersionTable


################################################
# What is PowerCLI ?
################################################

Get-PSSnapin

# What Powershell Snapins do we get with PowerCLI ?
Get-PSSnapin -Registered

#Let's load all of them into our Powershell session :
Add-PSSnapin -Name vmware*

Get-PSSnapin

#How many cmdlets does the main PowerCLI snapin provide ?
Get-Command -PSSnapin VMware.VimAutomation.Core | Measure-Object 

#How many cmdlets does PowerCLI provide in total ?
Get-Command -PSSnapin VMware* | Measure-Object

#Besides cmdlets , it also adds 2 Powershell providers
Get-PSProvider | Where-Object { $_.Name -like "Vim*" } |
Select-Object -Property Name,Drives

cd vmstores:

# Checking the PowerCLI version
Get-PowerCLIVersion

# Let's connect to a vCenter Server :
Connect-VIServer 192.168.1.10

# and verify our connection :
$DefaultVIServer

clear-host

###################################################
# Feature number 1 : discoverability
###################################################

Get-Verb

# Let's say we want to configure Distributed vSwitches but you are not sure of the cmdlet name
Get-Command -Verb Set -noun "*switch*"

# Let's find out how we can start SSH on a host with IntelliSense (Ctrl+Space)
Get-VMHost esxi55ga-1.vcloud.local | Start-V

# Learning how to use a cmdlet with a little bit of GUI
Show-Command Set-VMHostAuthentication

# Get the help information in a separate window
Get-Help Set-VMHostAuthentication -ShowWindow

# If you learn better by looking at examples :
Get-Help Remove-Datastore -Examples

# To get all sections from the cmdlet help :
Get-Help Remove-Datastore -full

Clear-Host

#####################################################
# Interpreting the cmdlet help
#####################################################

Get-Help Set-VMHostAuthentication -Full | more

# This cmdlet has 2 parameter sets : one to join a domain, and one to leave a domain

# -WhatIf
# Looking at what a potentially destructive command would do, without actually doing it
Get-VMHost | Remove-Inventory -WhatIf


help Get-Snapshot -Full

Get-Snapshot -VM (Get-VM) -Name "*snap*"

# When parameter names are explicitly typed, the order doesn't matter :
Get-Snapshot -Name "*snap*"-VM (Get-VM)

# These are positional parameters :
Get-Snapshot (Get-VM) "*snap*"

# Now, the order (or position) matters :
Get-Snapshot "*snap*" (Get-VM)

Clear-Host

#####################################################
# Aliases
#####################################################

# cd works just like in the traditional command prompt
cd $env:USERPROFILE

# dir as well
dir

# Even ls !
ls

# But these are just aliases to a cmdlet
Get-Alias -Name dir
Get-Alias -name ls

# Which itself, has yet another alias : gci
Get-Alias -Definition Get-ChildItem

# Listing all the alias using the Alias Powershell drive
ls alias:\

# PowerCLI doesn't add any aliases :
Get-Alias -Definition "*vm*"

# But you can create your own :
New-Alias -Name scratch -Value Set-VMHostDiagnosticPartition

# The path of our current Powershell profile
$profile

Clear-Host

#####################################################
# What is an object and what is it made of ?​
#####################################################

# Everything is an object :
$TextVariable = "I'm just plain text"

# This is an object of the type [string] :
$TextVariable.GetType() | Select-Object -Property Name, Fullname

$NumberVariable = 19

# This is an object of the type [int] :
$NumberVariable | Get-Member

# Apparently, [int] objects have no properties but they have quite a few methods

# Let's see what we can do with a [datetime] object :
Get-Date | Get-Member

# Let's look at a few of its properties :
Get-Date | Select-Object -Property Day, DayOfWeek, DayOfYear

# We can very easily extract the month information from a date :
Get-Date | Select-Object -Property Month

# To see all the properties and thir values :
Get-Date | Format-List *

# Let's try one of its methods :
(Get-Date).AddDays(-7)

Clear-Host

#####################################################
# Variables
#####################################################

$MyVar = Get-VMHost 

# Looking at its content :
$MyVar

# Looking at it by its name :
Get-Variable -Name MyVar

# Listing all the variables in the current Powershell session
gci variable:\

# We can expand our variable from inside double quotes :
Write-Output "Here is a list of ESXi hosts : $MyVar"

# But not from inside single quotes :
Write-Output 'Here is a list of ESXi hosts : $MyVar'