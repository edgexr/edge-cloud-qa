import os
from slackclient import SlackClient
import argparse
import json
import logging
import sys

api_token = '***REMOVED***'
#channel_number = 'DF3JVL43W'
#channel_number = 'DF6DPUATG'
channel_number = 'CF67W3QH5'

slack_token = api_token
sc = SlackClient(slack_token)

message = sys.argv[1]

sc.api_call(
    "chat.postMessage",
    channel=channel_number,
    #text="Hello from Python! :tada:"
    text=message
)
