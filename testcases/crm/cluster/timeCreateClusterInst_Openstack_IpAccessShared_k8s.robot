*** Settings ***
Documentation  Cluster size for openstack with IpAccessShared and Kubernetes

Library	 MexController  controller_address=%{AUTOMATION_CONTROLLER_ADDRESS}
Library  String
Library  OperatingSystem
Library  Collections
Library  DateTime
Library  Process

Suite Teardown  WriteHTML
Test Setup      Setup
Test Teardown   Teardown

Test Timeout     ${test_timeout_crm} 
	
*** Variables ***
${cloudlet_name_openstack}   automationHawkinsCloudlet
#${cloudlet_name_openstack}   automationBuckhornCloudlet
#${cloudlet_name_openstack}   automationBeaconCloudlet
#${cloudlet_name_openstack}   automationGcpCentralCloudlet
#${cloudlet_name_openstack}   automationAzureCentralCloudlet
#${cloudlet_name_openstack}   automationSunnydaleCloudletStage
#${cloudlet_name_openstack}   automationFairviewCloudlet
#${cloudlet_name_openstack}   tmocloud-1
#${operator_name_openstack}   gcp 
#${operator_name_openstack}   azure 
${operator_name_openstack}   GDDT 
#${operator_name_openstack}   dmuus
${mobiledgex_domain}    mobiledgex.net
#${developer_name_openstack}     mobiledgex
	
${test_timeout_crm}  32 min
	
*** Test Cases ***
# ECQ-1775	
ClusterInst shall create single with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create a cluster on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the cluster and write it to a file
	
        ${testtime}=   Get Time  epoch
	${testtime}=   Convert To String    ${testtime}
	${testtime}=   Catenate  SEPARATOR=   ${testtime}  \n
	Create File   ${EXECDIR}/${FileName}
	Append To File   ${EXECDIR}/${FileName}    ${testtime}  
	Clear Thread Dict
	Set Suite Variable    ${testnum}   1
	
	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   11
	 
	${epoch_start_time}=   Get Time  epoch
	Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}      flavor_name=${flavor_name}    number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     	
	${epoch_end_time}=     Get Time  epoch
	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}    
	Write Data   


# ECQ-1776
ClusterInst shall create 2 with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create 2 clusters on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the clusters and write it to a file

	Clear Thread Dict
	Set Suite Variable    ${testnum}   2
	
	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   2
	
	@{handle_list}=  Create List
	
	${epoch_start_time}=   Get Time  epoch
	: FOR  ${INDEX}  IN RANGE  0  2
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
	\  ${handle}=   Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}      flavor_name=${flavor_name}    number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     use_thread=${True}   del_thread=${True}
	\  Append To List   ${handle_list}   ${handle}
	MexController.Wait For Replies    @{handle_list}
	${epoch_end_time}=     Get Time  epoch

	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}     
	Write Data   


# ECQ-1777
ClusterInst shall create 4 with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create 4 clusters on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the clusters and write it to a file

	Clear Thread Dict
	Set Suite Variable    ${testnum}    4
	
	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   3
	
	@{handle_list}=  Create List
	
	${epoch_start_time}=   Get Time  epoch
	: FOR  ${INDEX}  IN RANGE  0  4
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
	\  ${handle}=   Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}       flavor_name=${flavor_name}    number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     use_thread=${True}   del_thread=${True}
	\  Append To List   ${handle_list}   ${handle}
	MexController.Wait For Replies    @{handle_list}
	${epoch_end_time}=     Get Time  epoch

	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}     
	Write Data   


# ECQ-1778
ClusterInst shall create 6 with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create 6 clusters on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the clusters and write it to a file

	Clear Thread Dict
	Set Suite Variable    ${testnum}   6
	
	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   4
	
	@{handle_list}=  Create List
	
	${epoch_start_time}=   Get Time  epoch
	: FOR  ${INDEX}  IN RANGE  0  6
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
	\  ${handle}=   Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}       flavor_name=${flavor_name}    number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     use_thread=${True}   del_thread=${True}
	\  Append To List   ${handle_list}   ${handle}
	MexController.Wait For Replies    @{handle_list}
	${epoch_end_time}=     Get Time  epoch

	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}     
	Write Data   


# ECQ-1779
ClusterInst shall create 8 with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create 8 clusters on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the clusters and write it to a file

	Clear Thread Dict
	Set Suite Variable    ${testnum}   8
	
	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   5
	
	@{handle_list}=  Create List
	
	${epoch_start_time}=   Get Time  epoch
	: FOR  ${INDEX}  IN RANGE  0  8
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
	\  ${handle}=   Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}      flavor_name=${flavor_name}    number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     use_thread=${True}   del_thread=${True}
	\  Append To List   ${handle_list}   ${handle}
	MexController.Wait For Replies    @{handle_list}
	${epoch_end_time}=     Get Time  epoch

	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}     
	Write Data   


# ECQ-1780
ClusterInst shall create 10 with IpAccessShared/kubernetes on openstack
   [Documentation]
   ...  create 10 clusters on openstack with IpAccessShared and deployment type=kubernetes
   ...  collect the time it takes to create the clusters and write it to a file

	Clear Thread Dict
	Set Suite Variable    ${testnum}   10

	${clusterlb}=  Catenate  SEPARATOR=.  ${cluster_name}  ${rootlb}
	${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   6
	
	@{handle_list}=  Create List
	
	${epoch_start_time}=   Get Time  epoch
	: FOR  ${INDEX}  IN RANGE  0  10
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
	\  ${handle}=   Create Cluster Instance   cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}      flavor_name=${flavor_name}     number_nodes=1  number_masters=1   ip_access=IpAccessShared    deployment=kubernetes     use_thread=${True}    del_thread=${True}
	\  Append To List   ${handle_list}   ${handle}
	MexController.Wait For Replies    @{handle_list}
	${epoch_end_time}=     Get Time  epoch

	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	
	${FileData}=     Set Variable       ${testnum} Openstack Kubernetes Shared Cluster Creation Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}     
	Write Data   


*** Keywords ***
Setup   
	${testdate}=    Get Time  epoch
	${testdate}=    Convert Date    ${testdate}       result_format=%d-%m-%Y
	${testdate}=     Catenate  SEPARATOR=      -      ${testdate}
	${flavor_name}=   Set Variable   automation_api_flavor
	${cloudlet_lowercase}=  Convert to Lowercase  ${cloudlet_name_openstack}
	${FileName}=    Catenate  SEPARATOR=    ${cloudlet_name_openstack}   OpenstackTimingsK8sShared 
	${FileName}=    Catenate  SEPARATOR=    ${FileName}     ${testdate}
	${FileName}=    Catenate  SEPARATOR=    ${FileName}     .timings
	
	${x}=  Evaluate    random.randint(10, 20000)   random
	${x}=  Convert To String  ${x}
	${cluster_name}=  Catenate  SEPARATOR=  timecl  ${x}
	${testnum}=   Set Variable   1
        ${failedData}=   Set Variable    Test Failed

	Set Suite Variable  ${cloudlet_lowercase}
	Set Suite Variable  ${testnum}
	Set Suite Variable  ${failedData}

	${rootlb}=  Catenate  SEPARATOR=.  ${cloudlet_name_openstack}  ${operator_name_openstack}  ${mobiledgex_domain}
	${rootlb}=  Convert To Lowercase  ${rootlb}

	Set Suite Variable    ${rootlb}
	Set Suite Variable    ${FileName}
	Set Suite Variable    ${cluster_name}	
	Set Suite Variable    ${flavor_name}

Teardown
	Run Keyword If Test Passed   Clean Up
	Run Keyword If Test Failed   Failed Data 

Clean Up
	Clear Thread Dict
	${epoch_start_time}=   Get Time  epoch
	Cleanup provisioning 
	${epoch_end_time}=     Get Time  epoch
	${epoch_total_time}=   Evaluate    ${epoch_end_time}-${epoch_start_time} 
	${FileData}=     Set Variable       Delete ${testnum} Openstack Kubernetes Shared Cluster Time: ${epoch_total_time}\n
	Append To File   ${EXECDIR}/${FileName}     ${FileData}
	Write Data

	  
Write Data
	&{thread_list}=   Get Thread Dict
	${count}=  Convert To Integer  1
	: FOR  ${ITEM}   IN   @{thread_list}
	\  ${thread_data}=   Set Variable   Cluster ${count} Start: ${thread_list['${ITEM}'][0]} End: ${thread_list['${ITEM}'][1]} Total: ${thread_list['${ITEM}'][2]}\n 
	\  Append To File    ${EXECDIR}/${FileName}   ${thread_data}  
	\  ${count}=    Evaluate   ${count}+1
	

Failed Data
	Cleanup provisioning
	: FOR  ${INDEX}  IN RANGE  0  10
	\  ${y}=   Convert To String   ${INDEX}
	\  ${cluster_name}=  Catenate  SEPARATOR=   ${cluster_name}   ${y}
        \  Run Keyword And Ignore Error   Delete Cluster Instance    cluster_name=${cluster_name}   cloudlet_name=${cloudlet_name_openstack}   operator_org_name=${operator_name_openstack}   developer_org_name=${developer_name_openstack}
        ${failedData}=   Set Variable    Test ${testnum} Failed\n
	Append To File    ${EXECDIR}/${FileName}    ${failedData}

WriteHTML
	${result}=   Run Process   python3  ${EXECDIR}/writeTimings.py   ${EXECDIR}/${FileName}
        log    ${result.stdout}
	log    ${result.stderr}
	Should Be Equal As Integers    ${result.rc}    0
