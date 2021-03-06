*** Settings ***
Documentation   Login to console

Library		MexConsole  %{AUTOMATION_CONSOLE_ADDRESS}
#Library         SeleniumLibrary
	
Test Teardown   Close Browser

Test Timeout    40 minutes
	
*** Variables ***
${browser}           Chrome
${console_username}  mexadmin
${console_password}  mexadmin123

*** Test Cases ***
Login to console
    [Documentation]
    ...  Create 2 clusters and cluster instances at the same time on openstack
    ...  Verify both are created successfully

    Log to console  login
    sleep  5s
    Login to Mex Console  browser=${browser}  #username=${console_username}  password=${console_password}
    Open Compute

    #Get Organization Data
    Get Table Data

    Open Flavors

    Get Table Data

    #Change Region  region=US

    #Get Table Data

    Add New Flavor  region=EU  flavor_name=andyFlavor  ram=1024  vcpus=1  disk=1
	
    Sleep  10s
	
