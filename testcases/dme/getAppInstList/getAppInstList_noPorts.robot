*** Settings ***
Documentation   GetAppInstList - request shall return app with no ports

Library         MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library		MexController  controller_address=%{AUTOMATION_CONTROLLER_ADDRESS}
Variables       shared_variables.py

Test Setup	Setup
Test Teardown	Cleanup provisioning

*** Variables ***
${operator_name}  dmuus
${cloudlet_name}  tmocloud-1
${mobile_latitude}  1
${mobile_longitude}  1

*** Test Cases ***
GetAppInstList - request shall return app with no ports
    [Documentation]
    ...  registerClient
    ...  send GetAppInstList for app with no ports
    ...  verify returns 1 result without ports section

      Register Client
      ${appfqdns}=  Get App Instance List  carrier_name=${operator_name}  latitude=${mobile_latitude}  longitude=${mobile_longitude}

      @{origin}=  Create List  ${mobile_latitude}  ${mobile_longitude}
      @{dest}=    Create List  ${appfqdns[0].gps_location.latitude}  ${appfqdns[0].gps_location.longitude}
      ${distance}=  Calculate Distance  ${origin}  ${dest} 
      ${distance_round}=  Convert To Number  ${distance}  1
      ${appfqdns_distance_round}=  Convert To Number  ${appfqdns[0].distance}  1  

      Should Be Equal             ${appfqdns[0].carrier_name}                             ${dmuus_appinst.key.cluster_inst_key.cloudlet_key.organization}
      Should Be Equal             ${appfqdns[0].cloudlet_name}                            ${dmuus_appinst.key.cluster_inst_key.cloudlet_key.name}
      Should Be Equal             ${appfqdns[0].gps_location.latitude}                    ${dmuus_appinst.cloudlet_loc.latitude}
      Should Be Equal             ${appfqdns[0].gps_location.longitude}                   ${dmuus_appinst.cloudlet_loc.longitude}
      Should Be Equal             ${appfqdns_distance_round}                             ${distance_round}
      Should Be Equal             ${appfqdns[0].appinstances[0].app_name}                 ${dmuus_appinst.key.app_key.name}
      Should Be Equal             ${appfqdns[0].appinstances[0].app_vers}                 ${dmuus_appinst.key.app_key.version}
      Should Be Equal             ${appfqdns[0].appinstances[0].fqdn}                    ${dmuus_appinst.uri}

      Length Should Be   ${appfqdns}  1
      Length Should Be   ${appfqdns[0].appinstances}  1
      Length Should Be   ${appfqdns[0].appinstances[0].ports}  0

*** Keywords ***
Setup
    #Create Developer            
    Create Flavor
    #Create Cluster	
    Create App		       app_name=default  app_version=default  developer_org_name=default  cluster_name=default  image_path=default  image_type=ImageTypeDocker  default_flavor_name=default  use_defaults=${False} 
    ${dmuus_appinst}=           Create App Instance  cloudlet_name=${cloudlet_name}  operator_org_name=${operator_name}  cluster_instance_name=autocluster

    Set Suite Variable  ${dmuus_appinst} 


