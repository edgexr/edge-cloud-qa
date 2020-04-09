# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
import grpc

import dynamic_location_group_pb2 as dynamic__location__group__pb2


class DynamicLocGroupApiStub(object):
  # missing associated documentation comment in .proto file
  pass

  def __init__(self, channel):
    """Constructor.

    Args:
      channel: A grpc.Channel.
    """
    self.SendToGroup = channel.unary_unary(
        '/distributed_match_engine.DynamicLocGroupApi/SendToGroup',
        request_serializer=dynamic__location__group__pb2.DlgMessage.SerializeToString,
        response_deserializer=dynamic__location__group__pb2.DlgReply.FromString,
        )


class DynamicLocGroupApiServicer(object):
  # missing associated documentation comment in .proto file
  pass

  def SendToGroup(self, request, context):
    # missing associated documentation comment in .proto file
    pass
    context.set_code(grpc.StatusCode.UNIMPLEMENTED)
    context.set_details('Method not implemented!')
    raise NotImplementedError('Method not implemented!')


def add_DynamicLocGroupApiServicer_to_server(servicer, server):
  rpc_method_handlers = {
      'SendToGroup': grpc.unary_unary_rpc_method_handler(
          servicer.SendToGroup,
          request_deserializer=dynamic__location__group__pb2.DlgMessage.FromString,
          response_serializer=dynamic__location__group__pb2.DlgReply.SerializeToString,
      ),
  }
  generic_handler = grpc.method_handlers_generic_handler(
      'distributed_match_engine.DynamicLocGroupApi', rpc_method_handlers)
  server.add_generic_rpc_handlers((generic_handler,))
