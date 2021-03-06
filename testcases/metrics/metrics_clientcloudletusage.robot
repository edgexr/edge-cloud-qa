*** Settings ***
Documentation   Latency Edge Event Metrics Tests

Library  MexMasterController  mc_address=%{AUTOMATION_MC_ADDRESS}
Library  MexDme  dme_address=%{AUTOMATION_DME_ADDRESS}
Library  Collections

Resource  /Users/andyanderson/go/src/github.com/mobiledgex/edge-cloud-qa/testcases/metrics/metrics_dme_library.robot

Suite Setup	Setup
Suite Teardown	Teardown Settings  ${settings_pre}

Test Timeout    240s

*** Variables ***
${region}=  US
${device_os}=  Android
${device_model}=  platos S20
${data_network_type}=  5G
${signal_strength}=  5

${cloudlet1}=  ${cloudlet_name_fake}
${cloudlet2}=  tmocloud-2

${cloud1_lat}=  31
${cloud1_long}=  -91
${cloud2_lat}=  35
${cloud2_long}=  -95
${cloud11_lat}=  32
${cloud11_long}=  -92
${cloudlet1_tile}=  2-1713,5065-2
${cloudlet2_tile}=  2-1990,5343-2
${cloudlet11_tile}=  2-1713,5065-2

${dme_conn_lat}=  ${cloud11_lat}
${dme_conn_long}=  ${cloud11_long}

*** Test Cases ***
# ECQ-
DMEMetrics - Shall be able to get the last DME Client App Latency metric
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get the last client cloudlet usage metric  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${cloudlet1}  ${metrics}  

DMEMetrics - Shall be able to get the last DME Client App DeviceInfo metric
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get the last client cloudlet usage metric  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}  

DMEMetrics - Shall be able to get DME Client App Latency metrics with apporg only
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get all client app usage metrics  app_name=${None}  app_version=${None}  developer_org_name=${developer_org_name_automation}  selector=latency

   #Metrics Headings Should Be Correct  ${metrics}

   Latency App Should Be Found  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6  cloudlet=${cloudlet1}

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with apporg only
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get all client app usage metrics  app_name=${None}  app_version=${None}  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo App Should Be Found  ${app_name}1  ${metrics} 

DMEMetrics - Shall be able to get all DME Client App Latency metric
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get all client app usage metrics  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get all DME Client App DeviceInfo metric
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get all client app usage metrics  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}  

DMEMetrics - Shall be able to get DME Client App Latency metrics with starttime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with starttime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App Latency metrics with endtime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with endtime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with endtime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with endtime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App Latency metrics with starttime and endtime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime and endtime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with starttime and endtime
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime and endtime   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App Latency metrics with starttime and endtime and last
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime and endtime and last   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with starttime and endtime and last
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with starttime and endtime and last   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App Latency metrics with locationtile
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with locationtile   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency  location_tile=${cloudlet1_tile}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - Shall be able to get DME Client App Latency metrics with rawdata
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with rawdata   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

   Latency Metrics Headings Should Be Correct  ${metrics}  raw=${True}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6  raw=${True}

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with rawdata
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with rawdata   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}  raw=${True}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}  raw=${True}

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with deviceos
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with deviceinfo   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo  device_os=${device_os}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}  

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with devicemodel
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with deviceinfo   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo  device_model=${device_model}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics} 

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with datanetworktype
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with deviceinfo   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo  data_network_type=${data_network_type}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with all deviceinfo
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  Get client app usage metrics with deviceinfo   app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=deviceinfo  device_os=${device_os}  device_model=${device_model}  data_network_type=${data_network_type}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - DeveloperManager shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperManager shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - DeveloperManager shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperManager shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - DeveloperContributor shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperContributor shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - DeveloperContributor shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperContributor shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - DeveloperViewer shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperViewer shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}1  ${metrics}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6

DMEMetrics - DeveloperViewer shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  DeveloperViewer shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}1  app_version=1.0

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}1  ${metrics}

DMEMetrics - OperatorManager shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorManager shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}3  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=tmocloud-2

DMEMetrics - OperatorManager shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorManager shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}3  ${metrics}  cloudlet=tmocloud-2

DMEMetrics - OperatorContributor shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorContributor shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}3  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=tmocloud-2

DMEMetrics - OperatorContributor shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorContributor shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}3  ${metrics}  cloudlet=tmocloud-2 

DMEMetrics - OperatorViewer shall be able to get DME Client App Latency metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorViewer shall be able to get client app usage metrics  selector=latency  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   Latency Metrics Headings Should Be Correct  ${metrics}

   Latency Values Should Be Correct  ${app_name}3  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=tmocloud-2

DMEMetrics - OperatorViewer shall be able to get DME Client App DeviceInfo metrics
   [Documentation]
   ...  request the DME RegisterClient metrics as DeveloperManager
   ...  verify metrics are returned

   ${metrics}=  OperatorViewer shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${developer_org_name_automation}  app_name=${app_name}3  app_version=1.0  operator_org_name=${operator_name_fake}

   DeviceInfo Metrics Headings Should Be Correct  ${metrics}

   DeviceInfo Values Should Be Correct  ${app_name}3  ${metrics}  cloudlet=tmocloud-2

DMEMetrics - Shall be able to get DME Client App Latency metrics with cloudletorg only
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  OperatorManager shall be able to get client app usage metrics  selector=latency  developer_org_name=${None}  app_name=${None}  app_version=${None}  operator_org_name=${operator_name_fake}

   Latency App Should Be Found  ${app_name}3  ${metrics}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2  cloudlet=tmocloud-2

DMEMetrics - Shall be able to get DME Client App DeviceInfo metrics with cloudletorg only
   [Documentation]
   ...  request DME RegisterClient metrics with last=1
   ...  verify info is correct

   ${metrics}=  OperatorManager shall be able to get client app usage metrics  selector=deviceinfo  developer_org_name=${None}  app_name=${None}  app_version=${None}  operator_org_name=${operator_name_fake}

   DeviceInfo App Should Be Found  ${app_name}3  ${metrics}  cloudlet=tmocloud-2 

*** Keywords ***
Setup
    ${epoch}=  Get Time  epoch

    ${app_name}=  Get Default App Name

    Create Flavor  region=${region}

    @{cloudlet_list}=  Create List  tmocloud-2
    ${pool_return}=  Create Cloudlet Pool  region=${region}  operator_org_name=${operator_name_fake}  cloudlet_list=${cloudlet_list}

    Create App  region=${region}  app_name=${app_name}1  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=tmocloud-2  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    Create App  region=${region}  app_name=${app_name}2  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}2  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    Create App  region=${region}  app_name=${app_name}3  access_ports=tcp:1
    Create App Instance  region=${region}  app_name=${app_name}3  cloudlet_name=tmocloud-2  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster

    
    Set Suite Variable  ${app_name}

    ${settings_pre}=   Show Settings  region=${region}
    Set Suite Variable  ${settings_pre}

    @{collection_intervals}=  Create List  10s  1m10s  2m10s
    Update Settings  region=${region}  edge_events_metrics_collection_interval=10s  edge_events_metrics_continuous_queries_collection_intervals=@{collection_intervals}

    ${r1}=  Register Client  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}	
    ${cloudlet1}=  Find Cloudlet   carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud2_long}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    Should Be Equal As Numbers  ${cloudlet1.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet1.edge_events_cookie}') > 100
    Should Be Equal  ${cloudlet1.fqdn}  tmocloud-1.dmuus.mobiledgex.net

    ${r2}=  Register Client  app_name=${app_name}2  app_version=1.0  developer_org_name=${developer_org_name_automation}
    ${cloudlet2}=  Find Cloudlet  carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud2_long}
    Should Be Equal As Numbers  ${cloudlet2.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet2.edge_events_cookie}') > 100

    ${r3}=  Register Client  app_name=${app_name}3  app_version=1.0  developer_org_name=${developer_org_name_automation}
    ${cloudlet3}=  Find Cloudlet  carrier_name=${operator_name_fake}  latitude=${cloud1_lat}  longitude=${cloud2_long}  device_os=${device_os}  device_model=${device_model}  signal_strength=${signal_strength}  data_network_type=${data_network_type}
    Should Be Equal As Numbers  ${cloudlet3.status}  1  #FIND_FOUND
    Should Be True  len('${cloudlet3.edge_events_cookie}') > 100

    @{samples1}=  Create List  ${10.4}  ${4.20}  ${30}  ${440}  ${0.50}  ${6.00}  ${170.45}
    ${num_samples1}=  Get Length  ${samples1}

    Create DME Persistent Connection  carrier_name=${operator_name_fake}x  session_cookie=${r1.session_cookie}  edge_events_cookie=${cloudlet1.edge_events_cookie}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}
    ${latency11}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency21}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency31}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency41}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency51}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency61}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${lu}=  Send Location Update Edge Event  carrier_name=${operator_name_fake}  latitude=${cloud2_lat}  longitude=${cloud2_long}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    Should Be Equal As Numbers  ${lu.new_cloudlet.status}  1  #FIND_FOUND
    Should Be Equal  ${lu.new_cloudlet.fqdn}  tmocloud-2.dmuus.mobiledgex.net
#    Terminate DME Persistent Connection

    Create DME Persistent Connection  carrier_name=${operator_name_fake}  session_cookie=${r2.session_cookie}  edge_events_cookie=${cloudlet2.edge_events_cookie}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}
    ${latency12}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency22}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
#    Terminate DME Persistent Connection
#
    Create DME Persistent Connection  carrier_name=${operator_name_fake}  session_cookie=${r3.session_cookie}  edge_events_cookie=${cloudlet3.edge_events_cookie}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}
    ${latency13}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    ${latency23}=  Send Latency Edge Event  carrier_name=${operator_name_fake}  latitude=${dme_conn_lat}  longitude=${dme_conn_long}  samples=${samples1}  device_info_os=${device_os}  device_info_model=${device_model}  device_info_signal_strength=${signal_strength}  device_info_data_network_type=${data_network_type}
    #Terminate DME Persistent Connection

    Sleep  20s
#    ${metrics1}=  Get Client App Metrics  region=${region}  app_name=${app_name}  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency

    Sleep  60s
#    ${metrics2}=  Get Client App Metrics  region=${region}  app_name=${app_name}  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
    
    Sleep  70s
#    ${metrics31}=  Get Client App Metrics  region=${region}  app_name=${app_name}1  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#    ${metrics32}=  Get Client App Metrics  region=${region}  app_name=${app_name}2  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#    ${metrics33}=  Get Client App Metrics  region=${region}  app_name=${app_name}3  app_version=1.0  developer_org_name=${developer_org_name_automation}  selector=latency
#
#    Should Be Equal  ${metrics31['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics31['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics31['data'][0]['Series'][2]['name']}  latency-metric-10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics32['data'][0]['Series'][2]['name']}  latency-metric-10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][0]['name']}  latency-metric-2m10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][1]['name']}  latency-metric-1m10s
#    Should Be Equal  ${metrics33['data'][0]['Series'][2]['name']}  latency-metric-10s
#    
#    Metrics Headings Should Be Correct  ${metrics31['data'][0]['Series'][0]['columns']}
#    Metrics Headings Should Be Correct  ${metrics32['data'][0]['Series'][1]['columns']}
#    Metrics Headings Should Be Correct  ${metrics33['data'][0]['Series'][2]['columns']}
#
#    Values Should Be Correct  ${app_name}1  ${metrics31['data'][0]['Series'][0]['values']}  ${latency11.statistics.max}  ${latency11.statistics.min}  ${latency11.statistics.avg}  ${latency11.statistics.std_dev}  ${latency11.statistics.variance}  ${num_samples1}  6
#    Values Should Be Correct  ${app_name}2  ${metrics32['data'][0]['Series'][1]['values']}  ${latency12.statistics.max}  ${latency12.statistics.min}  ${latency12.statistics.avg}  ${latency12.statistics.std_dev}  ${latency12.statistics.variance}  ${num_samples1}  2
#    Values Should Be Correct  ${app_name}3  ${metrics33['data'][0]['Series'][2]['values']}  ${latency13.statistics.max}  ${latency13.statistics.min}  ${latency13.statistics.avg}  ${latency13.statistics.std_dev}  ${latency13.statistics.variance}  ${num_samples1}  2

    Set Suite Variable  ${latency11}
    Set Suite Variable  ${latency13}
    Set Suite Variable  ${num_samples1}

#*** Keywords ***
#Setup
#    ${epoch}=  Get Time  epoch
#
#    ${app_name}=  Get Default App Name
#
#    Create Flavor  region=${region}
#  
#    Create App  region=${region}  app_name=${app_name}1  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}1  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
# 
#    Create App  region=${region}  app_name=${app_name}2  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}2  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
#
#    Create App  region=${region}  app_name=${app_name}3  access_ports=tcp:1
#    Create App Instance  region=${region}  app_name=${app_name}3  cloudlet_name=${cloudlet_name_fake}  operator_org_name=${operator_name_fake}  cluster_instance_name=autocluster
#   
#    Set Suite Variable  ${app_name}

Teardown Settings
   [Arguments]  ${settings}

   Login

   @{collection_intervals}=  Create List  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][0]['interval']}  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][1]['interval']}  ${settings['edge_events_metrics_continuous_queries_collection_intervals'][2]['interval']}
   Update Settings  region=${region}  edge_events_metrics_collection_interval=${settings['appinst_client_cleanup_interval']}  edge_events_metrics_continuous_queries_collection_intervals=@{collection_intervals}

   Teardown

Teardown
   Terminate DME Persistent Connection
   Cleanup Provisioning

Latency Metrics Headings Should Be Correct
  [Arguments]  ${metrics}  ${raw}=${False}

   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  latency-metric-2m10s
   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][1]['name']}  latency-metric-1m10s
   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][2]['name']}  latency-metric-10s
   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   Run Keyword If   ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  latency-metric

   FOR  ${i}  IN RANGE  0  ${count} 
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][0]}  time
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][1]}  cloudlet
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][2]}  cloudletorg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][3]}  signalstrength
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][4]}  0s
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][5]}  5ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][6]}  10ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][7]}  25ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][8]}  50ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][9]}  100ms
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][10]}  max
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][11]}  min
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][12]}  avg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][13]}  variance 
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][14]}  stddev
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][15]}  numsamples
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][16]}  locationtile
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][17]}  devicecarrier
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][18]}  datanetworktype
   END

DeviceInfo Metrics Headings Should Be Correct
  [Arguments]  ${metrics}  ${raw}=${False}

   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  device-metric-2m10s
   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][1]['name']}  device-metric-1m10s
   #Run Keyword If   not ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][2]['name']}  device-metric-10s
   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   Run Keyword If   ${raw}  Should Be Equal  ${metrics['data'][0]['Series'][0]['name']}  device-metric

   FOR  ${i}  IN RANGE  0  ${count}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][0]}  time
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][1]}  cloudlet
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][2]}  cloudletorg
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][3]}  deviceos
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][4]}  devicemodel
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][5]}  numsessions
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['columns'][6]}  datanetworktype
   END

Latency Values Should Be Correct
   [Arguments]  ${cloudlet}  ${metrics}  ${max}=${None}  ${min}=${None}  ${avg}=${None}  ${variance}=${None}  ${stddev}=${None}  ${numsamples}=${None}  ${numrequests}=${None}  ${raw}=${False}

   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   FOR  ${i}  IN RANGE  0  ${count}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][1]}  ${cloudlet}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][2]}  ${operator_name_fake}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][8]}  75 

      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][4]} >= 0  
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][5]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][6]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][7]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][8]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][9]} >= 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][10]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][11]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][12]} > 0
#      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][13]} > 0
#      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][14]} > 0
      Should Be True  ${metrics['data'][0]['Series'][${i}]['values'][0][15]} > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][16]}") > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][17]}") > 0
      Should Be True  len("${metrics['data'][0]['Series'][${i}]['values'][0][18]}") > 0

#      ${r9}=  Evaluate  ${2}*${numrequests}
#      ${r10}=  Evaluate  ${1}*${numrequests}
#      ${r11}=  Evaluate  ${1}*${numrequests}
#      ${r12}=  Evaluate  ${1}*${numrequests}
#      ${r13}=  Evaluate  ${0}*${numrequests}
#      ${r14}=  Evaluate  ${2}*${numrequests}
#      ${r20}=  Evaluate  ${numsamples}*${numrequests}
#
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][4]}   ${r9}
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][5]}  ${r10}
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][6]}  ${r11}
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][7]}  ${r12}
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][8]}  ${r13}
#      Should Be Equal As Numbers  ${metrics['data'][0]['Series'][${i}]['values'][0][9]}  ${r14}
#
#      ${latency_avg}=  Evaluate  round(${avg})
#      ${metrics_avg}=  Evaluate  round(${metrics['data'][0]['Series'][${i}]['values'][0][17]})
#
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][15]}  ${max}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][16]}  ${min}
#      Should Be Equal  ${metrics_avg}  ${latency_avg} 
##      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][18]}  ${variance}
##      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][19]}  ${stddev}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][20]}  ${r20}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][21]}  ${cloudlet1_tile}
   END

DeviceInfo Values Should Be Correct
   [Arguments]  ${app_name}  ${metrics}  ${cloudlet}=${cloudlet2}  ${raw}=${False}

   ${count}=  Run Keyword If   not ${raw}  Set Variable  3
   ...   ELSE  Set Variable  1

   FOR  ${i}  IN RANGE  0  ${count}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][1]}  ${cloudlet}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][2]}  ${operator_name_fake}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][3]}  ${device_os}
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][4]}  ${device_model}
      Should Be Equal As Integers  ${metrics['data'][0]['Series'][${i}]['values'][0][5]}  1
      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][6]}  ${data_network_type}
   END

App Should Be Found
   [Arguments]  ${app_name}  ${cloudlet_name}  ${metrics}

   ${metric_found}=  Set Variable  ${None}
   FOR  ${m}  IN  @{metrics['data'][0]['Series']}
      FOR  ${v}  IN  @{m['values']}
          IF  '${v[1]}' == '${app_name}' and '${v[6]}' == '${cloudlet_name}'
              ${metric_found}=  Set Variable  ${v}
          END
      END
   END

   [Return]  ${metric_found}

Latency App Should Be Found
   [Arguments]  ${app_name}  ${metrics}  ${max}  ${min}  ${avg}  ${variance}  ${stddev}  ${numsamples}  ${numrequests}  ${cloudlet}=${cloudlet2}  ${raw}=${False}

   ${metric_found}=  App Should Be Found  ${app_name}  ${cloudlet}  ${metrics}

   Should Be Equal  ${metric_found[1]}  ${app_name}
   Should Be Equal  ${metric_found[2]}  ${developer_org_name_automation}
   Should Be Equal  ${metric_found[3]}  1.0
   Should Be Equal  ${metric_found[4]}  autocluster
   Should Be Equal  ${metric_found[5]}  MobiledgeX
   Should Be Equal  ${metric_found[6]}  ${cloudlet}
   Should Be Equal  ${metric_found[7]}  ${operator_name_fake}

   ${r9}=  Evaluate  ${2}*${numrequests}
   ${r10}=  Evaluate  ${1}*${numrequests}
   ${r11}=  Evaluate  ${1}*${numrequests}
   ${r12}=  Evaluate  ${1}*${numrequests}
   ${r13}=  Evaluate  ${0}*${numrequests}
   ${r14}=  Evaluate  ${2}*${numrequests}
   ${r20}=  Evaluate  ${numsamples}*${numrequests}

   Should Be Equal As Numbers  ${metric_found[9]}   ${r9}
   Should Be Equal As Numbers  ${metric_found[10]}  ${r10}
   Should Be Equal As Numbers  ${metric_found[11]}  ${r11}
   Should Be Equal As Numbers  ${metric_found[12]}  ${r12}
   Should Be Equal As Numbers  ${metric_found[13]}  ${r13}
   Should Be Equal As Numbers  ${metric_found[14]}  ${r14}

   ${latency_avg}=  Evaluate  round(${avg})
   ${metrics_avg}=  Evaluate  round(${metric_found[17]})

   Should Be Equal  ${metric_found[15]}  ${max}
   Should Be Equal  ${metric_found[16]}  ${min}
   Should Be Equal  ${metrics_avg}  ${latency_avg}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][18]}  ${variance}
#      Should Be Equal  ${metrics['data'][0]['Series'][${i}]['values'][0][19]}  ${stddev}
   Should Be Equal  ${metric_found[20]}  ${r20}
   Should Be Equal  ${metric_found[21]}  ${cloudlet1_tile}

#   IF  '${cloudlet}' == '${cloudlet2}'
#      Should Be Equal  ${metric_found[21]}  ${cloudlet2_tile}
#   ELSE
#      Should Be Equal  ${metric_found[21]}  ${cloudlet1_tile}
#   END

DeviceInfo App Should Be Found
   [Arguments]  ${app_name}  ${metrics}  ${cloudlet}=${cloudlet2}  ${raw}=${False}

   ${metric_found}=  App Should Be Found  ${app_name}  ${cloudlet}  ${metrics}

   Should Be Equal  ${metric_found[1]}  ${app_name}
   Should Be Equal  ${metric_found[2]}  ${developer_org_name_automation}
   Should Be Equal  ${metric_found[3]}  1.0
   Should Be Equal  ${metric_found[4]}  autocluster
   Should Be Equal  ${metric_found[5]}  MobiledgeX
   Should Be Equal  ${metric_found[6]}  ${cloudlet}
   Should Be Equal  ${metric_found[7]}  ${operator_name_fake}
   Should Be Equal  ${metric_found[8]}  ${device_os}
   Should Be Equal  ${metric_found[9]}  ${device_model}
   Should Be Equal As Integers  ${metric_found[10]}  1
   Should Be Equal  ${metric_found[11]}  ${data_network_type}
