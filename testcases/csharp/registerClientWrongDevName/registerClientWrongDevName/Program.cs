//ECQ-117

using System;
using Grpc.Core;
using System.Net;
using System.Diagnostics;
//using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

// MobiledgeX Matching Engine API.
using DistributedMatchEngine;

namespace MexGrpcSampleConsoleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("RegisterClientWrongDevName Test Case");


            var mexGrpcLibApp = new MexGrpcLibApp();
            mexGrpcLibApp.RunSampleFlow();
        }
    }

    public class TokenException : Exception
    {
        public TokenException(string message)
            : base(message)
        {
        }

        public TokenException(string message, Exception innerException)
            : base(message, innerException)
        {
        }
    }

    class MexGrpcLibApp
    {
        Loc location;

        string dmeHost = "us-qa.dme.mobiledgex.net"; // DME server hostname or ip.
        //string dmeHost = "mexdemo.dme.mobiledgex.net"; // DME server hostname or ip.
        int dmePort = 50051; // DME port.

        MatchEngineApi.MatchEngineApiClient client;

        public void RunSampleFlow()
        {
            location = getLocation();
            //string tokenServerURI = "http://mexdemo.tok.mobiledgex.net:9999/its?followURL=https://dme.mobiledgex.net/verifyLoc";
            string uri = dmeHost + ":" + dmePort;
            //string devName = "MobiledgeX”;
            //string appName = "MobiledgeX SDK Demo”;
            string devName = "mobiledgex_leon";
            string appName = "automation_api_app";

            // Channel:
            ChannelCredentials channelCredentials = new SslCredentials();
            Channel channel = new Channel(uri, channelCredentials);

            client = new DistributedMatchEngine.MatchEngineApi.MatchEngineApiClient(channel);

            var registerClientRequest = CreateRegisterClientRequest(devName, appName, "1.0");
            try
            {
                var regReply = client.RegisterClient(registerClientRequest);
            }
            catch (Grpc.Core.RpcException regReplyError)
            {
                //Console.WriteLine(regReplyError.Status);
                if (regReplyError.Status.Detail == "app not found")
                {
                    Console.WriteLine("Register Client Wrong Dev Name Return: " + regReplyError.Status.Detail);
                    Console.WriteLine("TestCase Passed!!!");
                    Environment.Exit(0);
                }
                else
                {
                    Console.WriteLine("Register Client Wrong Dev Name Failed Return: " + regReplyError.Status.Detail);
                    Environment.Exit(1);
                }

            }

        }


        RegisterClientRequest CreateRegisterClientRequest(string devName, string appName, string appVersion)
        {
            var request = new RegisterClientRequest
            {
                Ver = 1,
                DevName = devName,
                AppName = appName,
                AppVers = appVersion
            };
            return request;
        }



        // TODO: The app must retrieve form they platform this case sensitive value before each DME GRPC call.
        // The device is potentially mobile and may have data roaming.
        String getCarrierName()
        {
            return "GDDT";
        }

        // TODO: The client must retrieve a real GPS location from the platform, even if it is just the last known location,
        // possibly asynchronously.
        Loc getLocation()
        {
            return new DistributedMatchEngine.Loc
            {
                Longitude = -122.149349,
                Latitude = 37.459609
            };
        }

    }


    static class Credentials
    {
        // Root CA:
        public static string caCrt = @"-----BEGIN CERTIFICATE-----
MIIE4jCCAsqgAwIBAgIBATANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDEwZtZXgt
Y2EwHhcNMTgwODIwMDMwNzQwWhcNMjAwMjIwMDMwNzQwWjARMQ8wDQYDVQQDEwZt
ZXgtY2EwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCk45wuENmZk/ok
u41JjBwC3PBRWA8SRIGjVbHHIGA6uORNY/GaKU1mgBengzvOqT9DrnwsHjQGoLEl
f3J3d/KF3rhm60ZVtHGi3FUuZc9N/8E3ABBivd31gGcv30b25UyxcE9TNiqJJ7z2
t1RmLT5+KSP7Mg9l+H1lhBRukdmAIym+pQsiFaKTxiZ9VbCfget+QP4mn1G1VdLD
j9LV7UIS8OO3EwslU4yYT0ycaHoUZEKWUYu9+D+nL/L9X3lruk2vNg0ieiFBAeoM
hAmQy8sQ+nsLPQlzWr7nyi2AMCwL8DQyKFVkGETaCmmTrDhoy+TWE6wkX5nsw90t
EIaaE4/BpEc4irXT8lUdLXEovYWaFcGxTDMJkFKjtPFACO8ck8r0GQ1C24FWqU4B
7kQoCj9BRtTGfRAozBIOroZ2/k2lig+FGIVnSUPIvc0F2axFgzlg8k2RVrPrdkQ2
VYWG7FLfZ9Wo8SkkenmnejguBEKOXs0Q4kEjh/qjDx5MZgIvjRCiamUt2MnBm7ky
j1EA1lZ7A8f2FmbCLthvcu5knpI1w/yvADXC2i+dBa/r8pIIlZv/9Mb7IlkBBF95
p0ES3rXAMTVbTrYKnwPSiZoES5zuLHOKCrNLg2zO2nqYE69a6FEPjkA+aoOs/KZG
JauZzTvtP25hViMnuee9QckcwS/mzwIDAQABo0UwQzAOBgNVHQ8BAf8EBAMCAQYw
EgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHQ4EFgQU0JOPAC7G5mw7G7W0e6GtHn7r
S3gwDQYJKoZIhvcNAQELBQADggIBAIDFI/SbMNIy1nskp4TNKv6YwMMgWUO7tfXs
obLrwGfneOR8lA9GJlpab47aohWcTxua6iwzUNqowq0x5wwmWwbSLeyiMY4TJj2E
C6Lla7uuC6WeY3RIS1XjjvOIvW6Mq2n3JElIwtGnm5qmr6CzfqiZenxY+UU1nBbI
eRw/V36ikJAQz5kj7wskUVwhAPEPnHr1hYmyu8t2Ue7zERwHzRIs0nwERQaV32aI
f//bV/kqhzueDiwqXqwFSHGreEefhUGUYEtiC8etLUZHe5ts3627pTjr0FZ2F+pt
OkQB9A+yuTPeJQJTMCLuyHxsiDQkT0On/Mky6ffdWSAwWXbcNVfO1If8Wi6yXvRz
Xe9dvyiIVwvG4VAtuwGEmTXd/fh4J/OpqxjLcXe/3k1ibX+y6zClV4REp4ygm6Kr
minVSTY4o4f1H39tIth9LZqpZKzOC4QJu0CWI4rLb6sCUlo8nWOmAktyua3xSAjs
k59JzlMIfdZ8z0SZq0Hy5Bf5XhZY0WcvWLc89RGslDibMtg6qweO43F23lV8w+Xn
mbSi8TUL2D7kA5StYElnJ4G2o4Bmymu8XxcZhDfeH0LJ8lqP7TyRnkL2jmNYm6be
3u/yuyFCrwRluMzwEzAY+3FPuhfHWCmlSZhx1gsXQIXtmKT0l2xU9dlF8fPBYC5e
LggXHNeu
-----END CERTIFICATE-----";

        // Client Crt:
        public static string clientCrt = @"-----BEGIN CERTIFICATE-----
MIIEOjCCAiKgAwIBAgIQMCuDiDXhpNOKRvn69uSbCjANBgkqhkiG9w0BAQsFADAR
MQ8wDQYDVQQDEwZtZXgtY2EwHhcNMTgwODIwMDMxMDI0WhcNMjAwMjIwMDMwNzM5
WjAVMRMwEQYDVQQDEwptZXgtY2xpZW50MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAzLaPAPOAUzV49VXgiYsDZTQ/zyCtsr0w3Ge/tvIck2Mm2FtAZ88r
oRV2UPrviEZPBL+o/JPiShfgqj1cLU1GyRr4uyezYl9AIig9/2xjYnkcXg6e3QG7
5lOaX2zH9mrYAm/N2hNzJwe9ZWBibXMDwFN4cptyygZuQ86SnK4j+6h1SVmN+F1j
ma18RzSU2rOjHK0InFgILSOlcjYYD/ds3HiL+vY6CVSNfuul5IMvQ/R8B8GwZpGG
34vl4AsDYM6FK+qW/ncFEt9rAOfu9AOeDWciKxPjzB4bX5G0dWAk5IU3VoGafEXe
Yt1xyeK25KHkw4kSh57BRkJKSuyvPWUqewIDAQABo4GJMIGGMA4GA1UdDwEB/wQE
AwIDuDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFGoT
cCzivXGPbeBD14sTusqjamkbMB8GA1UdIwQYMBaAFNCTjwAuxuZsOxu1tHuhrR5+
60t4MBUGA1UdEQQOMAyCCm1leC1jbGllbnQwDQYJKoZIhvcNAQELBQADggIBABSb
ZdZE9zh7vgT3cNr0gLVWk4We43VRlSa5JgdzWixi63qYTVIjHUE0BZo9yBMm3cx8
w327wAMVdlImUl/0Sv1NLi0IyC7EtxHfNhmUsgDa9oXuZwXM/RNmite1emS0ZYLE
fh7lNYUwnU/DHRPlZbIu08/7jYfyqxYKJSkP9HUBGOreGmMg+xARifr1Wb9uQDnx
12zK2uSG0Np8SbZV6FykNp7HeXG0jzOW+1Kg/NSxzYtScbSj3PfHIIHCiPhLd630
jVFsRUSfKMsM2+mDotVMvFlGyKoQUkQpS9RT/WsbKsSgLuW/WP1Zskh692DchMxI
YIASjJnwgidLwVen5uwj6h9vX9L1jb8CjV8w+SPjTqo6Hw8veQnqZV1nI1PgE17P
wjBlAmrCzfhbpNoMrktglWhpi/NJtCfQWwNkkGpd547NA1WXTRRqbxGc9Mg4GALb
6G9Hzp7nUpC3tC78jwZtsiw6oyPreYQc+O1XVD7qrvfcKabDStOIYcyenLmv82CL
ciCxLZGwVZ+5ABTuOsch7Sg3ZFnCJHvJqn00ZH7YBvTeoCfeelEiFCn7ehEbX8kn
y9MuVRwaDfGMKBYZ8Urr+RDxoDQwObvYQNIW9wVLoCGRuj3qt0BtTLkOuHvNCox1
GJJmmOKzRetckg3+ZSu7ET2YDuB3TDxPvDyc4Tq8
-----END CERTIFICATE-----";

        // Client Private Key:
        public static string clientKey = @"-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAzLaPAPOAUzV49VXgiYsDZTQ/zyCtsr0w3Ge/tvIck2Mm2FtA
Z88roRV2UPrviEZPBL+o/JPiShfgqj1cLU1GyRr4uyezYl9AIig9/2xjYnkcXg6e
3QG75lOaX2zH9mrYAm/N2hNzJwe9ZWBibXMDwFN4cptyygZuQ86SnK4j+6h1SVmN
+F1jma18RzSU2rOjHK0InFgILSOlcjYYD/ds3HiL+vY6CVSNfuul5IMvQ/R8B8Gw
ZpGG34vl4AsDYM6FK+qW/ncFEt9rAOfu9AOeDWciKxPjzB4bX5G0dWAk5IU3VoGa
fEXeYt1xyeK25KHkw4kSh57BRkJKSuyvPWUqewIDAQABAoIBACePjBk59W2fIs3+
l5LdC33uV/p2LTsidqPRZOo85arR+XrMP6kQDzVlCWVi6RFjzPd09npBNfTtolwj
2YFjsq9AiBra9D6pe6JeNoT69EXec831c1vwbth3BZk1U3tacH4gDx76rUE4rLA/
rSXLmUj8mIVFZyyFi5+M9yZSPN/v+J7VfE2b3dRVw+oBa4GEGpR9IcEGyGgjzz/2
qc4e+iphCW10ZfLl6ZuVIErJgoGEDlilZhNMLlGIu/4/0Pd2DH+pYE4JaVKHIltW
WChDIWh1Ad+fZvVB/+M27GOaavHKm64z5/46Oj/n6lhwL/GDi1CQeMHBSFn4xsf0
rloEvNkCgYEA3rChHJlq7xxHnAyCjR+VVWjS409DQHFM2KntbX7mv2lMS8t4jpf9
sV/tyX5CWrlbk4Ntyxzz8Z8hi6VYhRsLVDbWL5g3fHMK76mj1JtbDLUw/w28twEm
d1wit0i+5Un6i3i7Wig8g+y31xAqobI4/5mhehEhjjSQP7H8JQ7M2dUCgYEA61WM
x5QGAzYIi+y59rFITfk6x7DNW7dOk0z3B6caF1HBoUzIh/uZrKaGxHLUcPNUprBG
vhSCpYdsXPVZgqxibnjPwrbYCPBZoN4DXsvOosbUcK4aDwvAX/i0RH77eBM5M+J4
5DbNxoS8y0ALjjgj85LQv4fFQeFXy2VtVGvHSw8CgYAyrTtcyMT++Q6KwoYLG37e
WuZy+Byz05TLUZBIdLKKKKpGLV2YBZqj/NKeIe9zue7PGP+pU0NoXvBBWTVVxRvE
5F3Fovwtg/ifJZm0zk3gDHPD9xpVAxv/2aXE0/ctMrKjfqwUDkgHNZ14gaNR/L7f
29RVdQSP2gJhnF1nCYEwqQKBgQDBd+Vytfhzb1p7XjRL4Ncmczylqm5Jdlt8sYts
mS3T+fyLlMpPMMLXs1eb7SNFcGYpW0XtQoNdfgXSLkpWKU4Kr/ttgk/8mUu1+o8e
wcKxA3Dm6dq2f9y5iYb5wMMPpg4i346vX3awO7PSDGbzlqfHuO0waHf8fztkFZBa
FPkUdQKBgGhCavU72BxbSIFBsLuw07+DQ7aU00JFkqEFYrK2Y0KbtRzi5s0f8sTQ
m67Ck9nZhhvdpunWWeynM8rjJy4MPUJWZeJmo8OAxOAdmdXs8cmykqfNb+0uC35b
i4CrX+qG6rq9Y4/kVJ4jWdUbpAN7gp+vCMBUGZ0HuYtxlkRH4y6G
-----END RSA PRIVATE KEY-----";
    }
}
