#!/usr/local/bin/python3

#
# create developer with invalid name. should match "^[0-9a-zA-Z][-_0-9a-zA-Z .&,!]*$"
# verify 'Invalid developer name' is created
# 

import unittest
import grpc
import sys
import time
from delayedassert import expect, expect_equal, assert_expectations
import logging
import os

import MexController as mex_controller

controller_address = os.getenv('AUTOMATION_CONTROLLER_ADDRESS', '127.0.0.1:55001')

mex_root_cert = 'mex-ca.crt'
mex_cert = 'mex-client.crt'
mex_key = 'mex-client.key'

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

class tc(unittest.TestCase):
    @classmethod
    def setUpClass(self):
        self.controller = mex_controller.MexController(controller_address = controller_address,
                                                    root_cert = mex_root_cert,
                                                    key = mex_key,
                                                    client_cert = mex_cert
                                                   )

    def unsupported_test_createDeveloperStartUnderscore(self):
        # print developers before add
        developer_pre = self.controller.show_developers()

        # create developer
        error = None
        self.developer = mex_controller.Developer(developer_name = '_mydeveloper')
        try:
            self.controller.create_developer(self.developer.developer)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print developers after add
        developer_post = self.controller.show_developers()
        
        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        expect_equal(error.details(), 'Invalid developer name', 'error details')
        #expect_equal(len(developer_post), len(developer_pre), 'num developer')

        assert_expectations()

    def test_createDeveloperParenthesis(self):
        # print developers before add
        developer_pre = self.controller.show_developers()

        # create developer
        error = None
        self.developer = mex_controller.Developer(developer_name='my(developer)')
        try:
            self.controller.create_developer(self.developer.developer)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print developers after add
        developer_post = self.controller.show_developers()
        
        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        #expect_equal(error.details(), 'Invalid developer name', 'error details')
        expect_equal(error.details(), 'Invalid developer name, name can only contain letters, digits, _ . -', 'error details')
        #expect_equal(len(developer_post), len(developer_pre), 'num developer')

        assert_expectations()

    def test_createDeveloperDollarsign(self):
        # print developers before add
        developer_pre = self.controller.show_developers()

        # create developer
        error = None
        self.developer = mex_controller.Developer(developer_name='my$developer')
        try:
            self.controller.create_developer(self.developer.developer)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e
        # print developers after add
        developer_post = self.controller.show_developers()
       
        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        #expect_equal(error.details(), 'Invalid developer name', 'error details')
        expect_equal(error.details(), 'Invalid developer name, name can only contain letters, digits, _ . -', 'error details')
        #expect_equal(len(developer_post), len(developer_pre), 'num developer')

        assert_expectations()

    def test_createDeveloperOtherInvalidChars(self):
        # print developers before add
        developer_pre = self.controller.show_developers()

        # create developer
        error = None
        self.developer = mex_controller.Developer(developer_name='my@#%^*<>developer')
        try:
            self.controller.create_developer(self.developer.developer)
        except grpc.RpcError as e:
            logger.info('got exception ' + str(e))
            error = e

        # print developers after add
        developer_post = self.controller.show_developers()
        
        expect_equal(error.code(), grpc.StatusCode.UNKNOWN, 'status code')
        #expect_equal(error.details(), 'Invalid developer name', 'error details')
        expect_equal(error.details(), 'Invalid developer name, name can only contain letters, digits, _ . -', 'error details')
        #expect_equal(len(developer_post), len(developer_pre), 'num developer')

        assert_expectations()

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(tc)
    sys.exit(not unittest.TextTestRunner().run(suite).wasSuccessful())

