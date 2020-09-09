*** Settings ***
Documentation  use UpdateAppInst to manage VM based App Inst on openstack

Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}
Library  MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library  MexOpenstack   environment_file=%{AUTOMATION_OPENSTACK_VM_ENV}
Library  MexApp
Library  String

Test Setup      Setup
Test Teardown   Cleanup provisioning

Test Timeout    ${test_timeout_crm}

*** Variables ***
${region}  EU
${cloudlet_name_openstack_vm}  automationBuckhornCloudlet
${operator_name_openstack}  GDDT
${latitude}       32.7767
${longitude}      -96.7970
${mobiledgex_domain}  mobiledgex.net
${qcow_centos_image}    https://artifactory.mobiledgex.net/artifactory/qa-repo-automationdevorg/server_ping_threaded_centos7.qcow2#md5:eddafc541f1642b76a1c30062116719d

${test_timeout_crm}  30 min

*** Test Cases ***
VM - healthcheck shows HealthCheckFailRootlbOffline when docker container is stopped on rootlb 
    [Documentation]
    ...  create VM based App Inst on openstack with AccessTypeLoadBalancer
    ...  stop docker container on rootlb and verify healthcheck
    ...  start docker container and verify healthcheck

    #EDGECLOUD-3577 - Healthcheck does not work for VM based app instance behind Loadbalancerr
    ${cluster_name_default}=  Get Default Cluster Name
    ${app_name_default}=  Get Default App Name
    ${developer_name_default}=  Get Default Developer Name
    ${version_default}=  Get Default App Version

    ${rootlb}=  Catenate  SEPARATOR=.  ${cloudlet_name_openstack_vm}  ${operator_name_openstack}  ${mobiledgex_domain}
    ${rootlb}=  Convert To Lowercase  ${rootlb}
    ${vm}=  Convert To Lowercase  ${developer_name_default}${app_name_default}${version_default}
    ${vm}=  Remove String  ${vm}  .
    ${clusterlb}=  Catenate  SEPARATOR=.  ${vm}  ${rootlb}

    Log To Console  Creating App and App Instance
    Create App  image_type=ImageTypeQCOW  deployment=vm  image_path=${qcow_centos_image}  access_ports=tcp:2016,udp:2015   access_type=loadbalancer  region=${region}
    Create App Instance  cloudlet_name=${cloudlet_name_openstack_vm}  operator_org_name=${operator_name_openstack}  cluster_instance_name=dummycluster  region=${region}

    Wait For App Instance Health Check OK  region=${region}  app_name=${app_name_default}

    Register Client
    ${cloudlet}=  Find Cloudlet  latitude=${latitude}  longitude=${longitude}
    ${fqdn_0}=  Catenate  SEPARATOR=   ${cloudlet.ports[0].fqdn_prefix}  ${cloudlet.fqdn}
    ${fqdn_1}=  Catenate  SEPARATOR=   ${cloudlet.ports[1].fqdn_prefix}  ${cloudlet.fqdn}

    TCP Port Should Be Alive  ${fqdn_0}  ${cloudlet.ports[0].public_port}
    UDP Port Should Be Alive  ${fqdn_1}  ${cloudlet.ports[1].public_port}

    Stop Docker Container Rootlb   root_loadbalancer=${clusterlb}
    Wait For App Instance Health Check Fail  region=${region}  app_name=${app_name_default}  state=HealthCheckFailRootlbOffline

    Start Docker Container Rootlb  root_loadbalancer=${clusterlb}
    Wait For App Instance Health Check OK  region=${region}  app_name=${app_name_default}


VM - healthcheck shows HealthCheckFailServerFail when VM is powered off 
    [Documentation]
    ...  create VM based App Inst on openstack with AccessTypeLoadBalancer
    ...  UpdateAppInst to poweroff the VM and verify healthcheck
    ...  UpdateAppInst to poweron the VM and verify healthcheck

    #EDGECLOUD-3577 - Healthcheck does not work for VM based app instance behind Loadbalancer
    ${cluster_name_default}=  Get Default Cluster Name
    ${app_name_default}=  Get Default App Name
    ${developer_name_default}=  Get Default Developer Name
    ${version_default}=  Get Default App Version

    ${rootlb}=  Catenate  SEPARATOR=.  ${cloudlet_name_openstack_vm}  ${operator_name_openstack}  ${mobiledgex_domain}
    ${rootlb}=  Convert To Lowercase  ${rootlb}
    ${vm}=  Convert To Lowercase  ${developer_name_default}${app_name_default}${version_default}
    ${vm}=  Remove String  ${vm}  .
    ${clusterlb}=  Catenate  SEPARATOR=.  ${vm}  ${rootlb}

    Log To Console  Creating App and App Instance
    Create App  image_type=ImageTypeQCOW  deployment=vm  image_path=${qcow_centos_image}  access_ports=tcp:2016,udp:2015   access_type=loadbalancer  region=${region}
    Create App Instance  cloudlet_name=${cloudlet_name_openstack_vm}  operator_org_name=${operator_name_openstack}  cluster_instance_name=dummycluster  region=${region}

    Wait For App Instance Health Check OK  region=${region}  app_name=${app_name_default}

    Register Client
    ${cloudlet}=  Find Cloudlet  latitude=${latitude}  longitude=${longitude}
    ${fqdn_0}=  Catenate  SEPARATOR=   ${cloudlet.ports[0].fqdn_prefix}  ${cloudlet.fqdn}
    ${fqdn_1}=  Catenate  SEPARATOR=   ${cloudlet.ports[1].fqdn_prefix}  ${cloudlet.fqdn}

    TCP Port Should Be Alive  ${fqdn_0}  ${cloudlet.ports[0].public_port}
    UDP Port Should Be Alive  ${fqdn_1}  ${cloudlet.ports[1].public_port}

    Log To Console  Updating App Instance
    Update App Instance  cloudlet_name=${cloudlet_name_openstack_vm}  operator_org_name=${operator_name_openstack}  cluster_instance_name=dummycluster  region=${region}  powerstate=PowerOff

    FOR  ${x}  IN RANGE  0  5
        ${vm_info}=  Get Server List  name=${vm}
        Exit For Loop If  '${vm_info[0]['Status']}' == 'SHUTOFF'
        Sleep  2s
    END

    Should Be Equal   ${vm_info[0]['Status']}  SHUTOFF

    Wait For App Instance Health Check Fail  region=${region}  app_name=${app_name_default}  state=HealthCheckFailServerFail

    Log To Console  Updating App Instance
    Update App Instance  cloudlet_name=${cloudlet_name_openstack_vm}  operator_org_name=${operator_name_openstack}  cluster_instance_name=dummycluster  region=${region}  powerstate=PowerOn

    FOR  ${x}  IN RANGE  0  5
        ${vm_info}=  Get Server List  name=${vm}
        Exit For Loop If  '${vm_info[0]['Status']}' == 'ACTIVE'
        Sleep  2s
    END

    Should Be Equal   ${vm_info[0]['Status']}  ACTIVE

    Wait For App Instance Health Check OK  region=${region}  app_name=${app_name_default} 

*** Keywords ***
Setup
    Create Flavor  disk=80  region=${region}

