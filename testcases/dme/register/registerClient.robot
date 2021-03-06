*** Settings ***
Documentation  RegisterClient

Library  MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library  MexController  controller_address=%{AUTOMATION_CONTROLLER_ADDRESS}
#Variables  shared_variables.py

Test Setup	Setup
Test Teardown	Cleanup provisioning

*** Variables ***
${operator_name}  dmuus
${cloudlet_name}  tmocloud-2  #has to match crm process startup parms
${app_name}  someapplication   #has to match crm process startup parms
${developer_name}  AcmeAppCo
${app_version}  1.0

${token_server_url}  http://mextest.tok.mobiledgex.net:9999/its?followURL=https://dme.mobiledgex.net/verifyLoc
#${token_server_local_url}  http://127.0.0.1:9999/its?followURL=https://dme.mobiledgex.net/verifyLoc

*** Test Cases ***
RegisterClient - request without auth shall return proper JWT
   [Documentation]
   ...  Send RegisterClient without auth token to register a client for an app that doesnt contains an authpublickey
   ...  Verify returned JWT is correct

   Register Client	
   ${decoded_cookie}=  decoded session cookie
   ${token_server}=    token server uri

#   ${status}  ${value}=  Run Keyword And Ignore Error  Should Contain  %{AUTOMATION_DME_ADDRESS}  127.0.0.1
#   Run Keyword If   '${status}' == 'PASS'   Should Be Equal  ${token_server}  ${token_server_local_url} 
#   ...  ELSE  Should Be Equal  ${token_server}  ${token_server_url}

   Should Be Equal  ${token_server}  ${token_server_url}

   ${developer_name_default}=  Get Default Developer Name
   ${app_name_default}=        Get Default App Name
   ${app_version_default}=     Get Default App Version

   ${uuid_length}=  Get Length  ${decoded_cookie['key']['uniqueid']}

   ${expire_time}=  Evaluate  (${decoded_cookie['exp']} - ${decoded_cookie['iat']}) / 60 / 60
   Should Be Equal As Numbers  ${expire_time}  24   #expires in 24hrs

   #Should Be Equal  ${decoded_cookie['key']['peerip']}   ${peer_ip} 
   Should Match Regexp         ${decoded_cookie['key']['peerip']}  \\b\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\b
   Should Be Equal             ${decoded_cookie['key']['orgname']}  ${developer_name_default}	
   Should Be Equal             ${decoded_cookie['key']['appname']}  ${app_name_default}	
   Should Be Equal             ${decoded_cookie['key']['appvers']}  ${app_version_default}	
   Should Be Equal As Numbers  ${uuid_length}  27 
   Should Be Equal             ${decoded_cookie['key']['uniqueidtype']}  dme-ksuid 

*** Keywords ***
Setup
    #Create Operator             operator_name=${operator_name} 
    #Create Developer            
    Create Flavor
    #Create Cloudlet		cloudlet_name=${cloudlet_name}  operator_name=${operator_name}
    #Create Cluster
    Create App                  
    Create App Instance         cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name}  cluster_instance_name=autocluster

