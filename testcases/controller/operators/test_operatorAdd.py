#!/usr/local/bin/python3

# Operator - User shall be able to create an operator
# Operator - User shall be able to create an operator with a space
# Operator - User shall be able to create an operator with an underscore
#
# create operator
# verify it is created
# 

import unittest
import grpc
import sys
import time
import os
from delayedassert import expect, expect_equal, assert_expectations
import logging

import MexController as mex_controller

controller_address = os.getenv('AUTOMATION_CONTROLLER_ADDRESS', '127.0.0.1:55001')

operator_name = 'operator' + str(time.time())

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

    def test_createOperator(self):
        # print operators before add
        operator_pre = self.controller.show_operators()

        # create operator
        self.operator = mex_controller.Operator(operator_name = operator_name)
        self.controller.create_operator(self.operator.operator)

        # print operators after add
        operator_post = self.controller.show_operators()
        
        # found operator
        found_operator = self.operator.exists(operator_post)
     
        self.controller.delete_operator(self.operator.operator)

        expect_equal(found_operator, True, 'find operator')
        assert_expectations()

    def test_createOperatorSpace(self):
        # print operators before add
        operator_pre = self.controller.show_operators()

        # create operator
        self.operator = mex_controller.Operator(operator_name = operator_name + ' operator')
        self.controller.create_operator(self.operator.operator)

        # print operators after add
        operator_post = self.controller.show_operators()
        
        # found operator
        found_operator = self.operator.exists(operator_post)

        self.controller.delete_operator(self.operator.operator)

        expect_equal(found_operator, True, 'find operator')
        assert_expectations()

    def test_createOperatorUnderscore(self):
        # print operators before add
        operator_pre = self.controller.show_operators()

        # create operator
        self.operator = mex_controller.Operator(operator_name = operator_name + '_operator')
        self.controller.create_operator(self.operator.operator)

        # print operators after add
        operator_post = self.controller.show_operators()
        
        # found operator
        found_operator = self.operator.exists(operator_post)

        self.controller.delete_operator(self.operator.operator)

        expect_equal(found_operator, True, 'find operator')
        assert_expectations()

if __name__ == '__main__':
    suite = unittest.TestLoader().loadTestsFromTestCase(tc)
    sys.exit(not unittest.TextTestRunner().run(suite).wasSuccessful())

