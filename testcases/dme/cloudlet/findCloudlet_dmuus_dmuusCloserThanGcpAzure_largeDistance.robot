*** Settings ***
Documentation   FindCloudlet - request shall return dmuus with gcp/azure cloudlet provisioned and dmuus closer and with large distances
...		dmuus tmocloud-2 cloudlet at: 35 -95
...             gcp gcpcloud-1  cloudlet at: 37 -94
...             azure azurecloud-1  cloudlet at: 37 -95
...		find cloudlet closest to   : -90 -180
...                15006.44km from dmuus
...                15226.61km  from gcp
...                15228.78km  from azure
...             dmuus closer than gcp/azure. return dmuus cloudlet
...
...             ShowCloudlet
...             - key:
...                 operatorkey:
...                   name: dmuus
...                 name: tmocloud-2
...               location:
...                 lat: 35
...                 long: -95
...             - key:
...                 operatorkey:
...                   name: azure
...                 name: azurecloud-1
...               location:
...                 lat: 37
...                 long: -95
...             - key:
...                 operatorkey:
...                   name: gcp
...                 name: gcpcloud-1
...               location:
...                 lat: 37
...                 long: -94
...

Library         MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library		MexController  controller_address=%{AUTOMATION_CONTROLLER_ADDRESS}

Test Setup	Setup
Test Teardown	Cleanup provisioning

*** Variables ***
${azure_operator_name}  azure
${gcp_operator_name}  gcp
${dmuus_operator_name}  dmuus
${dmuus_cloudlet_name}  tmocloud-2  #has to match crm process startup parms
${azure_cloudlet_name}  azurecloud-1  #has to match crm process startup parms
${gcp_cloudlet_name}  gcpcloud-1  #has to match crm process startup parms
${app_name}  someapplication2   
${developer_name}  AcmeAppCo
${app_version}  1.0
${flavor}	  x1.medium
${number_nodes}	  3
${max_nodes}	  4
${num_masters}	  1

${azure_cloudlet_latitude}	  37
${azure_cloudlet longitude}	  -95
${gcp_cloudlet_latitude}	  37
${gcp_cloudlet longitude}	  -94
${dmuus_cloudlet_latitude}	  35
${dmuus_cloudlet longitude}	  -95

*** Test Cases ***
FindCloudlet - request shall return dmuus with gcp/azure cloudlet provisioned and dmuus closer and with large distances
    [Documentation]
    ...  send findcloudlet with dmuus/gcp/azure provisioned with large distances. dmuus closer. return dmuus
    ...             dmuus tmocloud-2 cloudlet at: 35 -95
    ...             gcp gcpcloud-1  cloudlet at: 37 -94
    ...             azure azurecloud-1  cloudlet at: 37 -95
    ...             find cloudlet closest to   : -90 -180
    ...                15006.44km from dmuus
    ...                15226.61km  from gcp
    ...                15228.78km  from azure
    ...             dmuus closer than gcp/azure. return dmuus cloudlet
    ...
    ...             ShowCloudlet
    ...             - key:
    ...                 operatorkey:
    ...                   name: dmuus
    ...                 name: tmocloud-2
    ...               location:
    ...                 lat: 35
    ...                 long: -95
    ...             - key:
    ...                 operatorkey:
    ...                   name: azure
    ...                 name: azurecloud-1
    ...               location:
    ...                 lat: 37
    ...                 long: -95
    ...             - key:
    ...                 operatorkey:
    ...                   name: gcp
    ...                 name: gcpcloud-1
    ...               location:
    ...                 lat: 37
    ...                 long: -94

      Register Client	
      #${cloudlet}=  Find Cloudlet	carrier_name=${dmuus_operator_name}  latitude=-100  longitude=-100
      ${cloudlet}=  Find Cloudlet      carrier_name=${dmuus_operator_name}  latitude=-90  longitude=-180     #maximum GPS coord

      Should Be Equal As Numbers  ${cloudlet.status}  1  #FIND_FOUND

      Should Be Equal             ${cloudlet.fqdn}                         ${dmuus_appinst.uri}
      Should Be Equal As Numbers  ${cloudlet.cloudlet_location.latitude}   ${dmuus_cloudlet_latitude}
      Should Be Equal As Numbers  ${cloudlet.cloudlet_location.longitude}  ${dmuus_cloudlet_longitude}

      Should Be True  len('${cloudlet.edge_events_cookie}') > 100

      Should Be Equal As Numbers  ${cloudlet.ports[0].proto}          ${dmuus_appinst.mapped_ports[0].proto}  #LProtoTCP
      Should Be Equal As Numbers  ${cloudlet.ports[0].internal_port}  ${dmuus_appinst.mapped_ports[0].internal_port}
      Should Be Equal As Numbers  ${cloudlet.ports[0].public_port}    ${dmuus_appinst.mapped_ports[0].public_port}
      Should Be Equal             ${cloudlet.ports[0].fqdn_prefix}    ${dmuus_appinst.mapped_ports[0].fqdn_prefix}

*** Keywords ***
Setup
    ${epoch}=  Get Time  epoch
    ${gcp_cloudlet_name}=  Catenate  SEPARATOR=  ${gcp_cloudlet_name}  ${epoch}
    ${azure_cloudlet_name}=  Catenate  SEPARATOR=  ${azure_cloudlet_name}  ${epoch}

    #Create Developer            
    Create Flavor
    Create Cloudlet		cloudlet_name=${azure_cloudlet_name}  operator_org_name=${azure_operator_name}  latitude=${azure_cloudlet_latitude}  longitude=${azure_cloudlet_longitude}
    Create Cloudlet		cloudlet_name=${gcp_cloudlet_name}  operator_org_name=${gcp_operator_name}  latitude=${gcp_cloudlet_latitude}  longitude=${gcp_cloudlet_longitude}
    #Create Cloudlet		cloudlet_name=${dmuus_cloudlet_name}  operator_org_name=${dmuus_operator_name}  latitude=${dmuus_cloudlet_latitude}  longitude=${dmuus_cloudlet_longitude}
    #Create Cluster		
    Create App			access_ports=tcp:1  
    ${dmuus_appinst}=            Create App Instance		cloudlet_name=${dmuus_cloudlet_name}  operator_org_name=${dmuus_operator_name}  cluster_instance_name=autocluster
    Create App Instance		cloudlet_name=${azure_cloudlet_name}  operator_org_name=${azure_operator_name}  cluster_instance_name=autocluster
    Create App Instance		cloudlet_name=${gcp_cloudlet_name}  operator_org_name=${gcp_operator_name}  cluster_instance_name=autocluster

    Set Suite Variable  ${dmuus_appinst} 

