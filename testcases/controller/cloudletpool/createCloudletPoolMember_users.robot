*** Settings ***
Documentation  CreateCloudletPoolMember for users

Library         MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}   root_cert=%{AUTOMATION_MC_CERT}
Library  DateTime

Suite Setup  Setup
Suite Teardown  Cleanup Provisioning

*** Variables ***
${username}=  mextester06
${password}=  ${mextester06_gmail_password}
${operator}=  dmuus

*** Test Cases ***
# ECQ-1666
# show cloudlet pool member no longer supported
#ShowCloudletPoolMember - users shall get empty list 
#   [Documentation]
#   ...  send ShowCloudletPoolMember with user token 
#   ...  verify empty list is received 
#
#   ${pool_return}=  Show Cloudlet Pool Member  region=US  token=${userToken}
#   log to console  xxx ${pool_return}
#
#   Should Be Empty  ${pool_return}

# ECQ-1667
CreateCloudletPoolMember - users shall get error when creating cloudlet pool 
   [Documentation]
   ...  - send CreateCloudletPoolMember with user token
   ...  - verify proper error is received

   #EDGECLOUD-1740 - MC API error message not consistent for 400 and 403 errors

   ${error}=  Run Keyword and Expect Error  *  Add Cloudlet Pool Member  region=US  token=${userToken}

   Should Contain  ${error}   403
   Should Contain  ${error}   {"message":"Forbidden"}

# ECQ-1668
DeleteCloudletPoolMember - users shall get error when deleting cloudlet pool
   [Documentation]
   ...  - send DeleteCloudletPoolMember with user token
   ...  - verify proper error is received 

   #EDGECLOUD-1740 - MC API error message not consistent for 400 and 403 errors

   ${error}=  Run Keyword and Expect Error  *  Remove Cloudlet Pool Member  region=US  token=${userToken}

   Should Contain  ${error}   403
   Should Contain  ${error}   {"message":"Forbidden"}

*** Keywords ***
Setup
   ${epoch}=  Get Current Date  result_format=epoch
   ${emailepoch}=  Catenate  SEPARATOR=  ${username}  +  ${epoch}  @gmail.com
   ${epochusername}=  Catenate  SEPARATOR=  ${username}  ${epoch}

   Skip Verify Email
   Create User  username=${epochusername}   password=${password}   email_address=${emailepoch}
   #Verify Email  email_address=${emailepoch}
   Unlock User

   ${userToken}=  Login  username=${epochusername}  password=${password}

   Set Suite Variable  ${userToken}
