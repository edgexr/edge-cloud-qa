/**
 * Copyright 2018-2020 MobiledgeX, Inc. All rights and licenses reserved.
 * MobiledgeX, Inc. 156 2nd Street #408, San Francisco, CA 94105
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.mobiledgex.sdkvalidator;

import android.app.UiAutomation;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Looper;
import android.util.Log;
import android.util.Pair;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.mobiledgex.matchingengine.AppConnectionManager;
import com.mobiledgex.matchingengine.ChannelIterator;
import com.mobiledgex.matchingengine.DmeDnsException;
import com.mobiledgex.matchingengine.MatchingEngine;
import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

import javax.net.ssl.SSLPeerUnverifiedException;

import distributed_match_engine.AppClient;
import distributed_match_engine.Appcommon.AppPort;
import io.grpc.StatusRuntimeException;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

@RunWith(AndroidJUnit4.class)
public class EngineCallTest {
    public static final String TAG = "EngineCallTest";
    public static final long GRPC_TIMEOUT_MS = 21000;

    public static final String organizationName = "MobiledgeX-Samples";
    // Other globals:
    public static final String applicationName = "sdktest";
    public static final String appVersion = "9.0";

    FusedLocationProviderClient fusedLocationClient;

    public static String hostOverride = "eu-qa.dme.mobiledgex.net";
    public static int portOverride = 50051;
    public static String findCloudletCarrierOverride = "GDDT"; // Allow "Any" if using "", but this likely breaks test cases.

    public boolean useHostOverride = true;

    public HashMap<String, String> myTag = new  HashMap<String, String>();

    // "useWifiOnly = true" also disables network switching, since the android default is WiFi.
    // Must be set to true if you are running tests without a SIM card.
    public boolean useWifiOnly = false;

    // Lat and long for San Jose
    public static final double latitude = 33.00;
    public static final double longitude = -96.54;

    private Location getTestLocation(double latitude, double longitude) {
        Location location = new Location("MobiledgeX_Test");
        location.setLatitude(latitude);
        location.setLongitude(longitude);
        return location;
    }

    @Before
    public void LooperEnsure() {
        // SubscriberManager needs a thread. Start one:
        if (Looper.myLooper()==null)
            Looper.prepare();
    }

    @Before
    public void grantPermissions() {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            UiAutomation uiAutomation = InstrumentationRegistry.getInstrumentation().getUiAutomation();
            uiAutomation.grantRuntimePermission(
                    InstrumentationRegistry.getInstrumentation().getTargetContext().getPackageName(),
                    "android.permission.READ_PHONE_STATE");
            uiAutomation.grantRuntimePermission(
                    InstrumentationRegistry.getInstrumentation().getTargetContext().getPackageName(),
                    "android.permission.ACCESS_COARSE_LOCATION");
            uiAutomation.grantRuntimePermission(
                    InstrumentationRegistry.getInstrumentation().getTargetContext().getPackageName(),
                    "android.permission.ACCESS_FINE_LOCATION"
            );
        }
    }
    // Mini test of wifi only:
    @Test
    public void testWiFiOnly() {
        useWifiOnly = true;

        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        assertEquals(true, me.isUseWifiOnly());
        String overrideHost = "";
        try {
            overrideHost = me.generateDmeHostAddress();
        } catch (DmeDnsException dde) {
            assertTrue("Cannot set to use WiFi! DNS failure!", false);
        }
        assertEquals(me.wifiOnlyDmeHost, overrideHost);
        me.setUseWifiOnly(useWifiOnly = false);
        assertEquals(false, me.isUseWifiOnly());
    }

    /**
     * Enable or Disable MockLocation.
     * @param context
     * @param enableMock
     * @return
     */
    public boolean enableMockLocation(Context context, boolean enableMock) {
        if (fusedLocationClient == null) {
            fusedLocationClient = new FusedLocationProviderClient(context);
        }
        if (enableMock == false) {
            fusedLocationClient.setMockMode(false);
            return false;
        } else {
            fusedLocationClient.setMockMode(true);
            return true;
        }
    }

    /**
     * Utility Func. Single point mock location, fills in some extra fields. Does not calculate speed, nor update interval.
     * @param context
     * @param location
     */
    public void setMockLocation(Context context, Location location) throws InterruptedException {
        if (fusedLocationClient == null) {
            fusedLocationClient = new FusedLocationProviderClient(context);
        }

        location.setTime(System.currentTimeMillis());
        location.setElapsedRealtimeNanos(1000);
        location.setAccuracy(3f);
        fusedLocationClient.setMockLocation(location);
        synchronized (location) {
            try {
                location.wait(1500); // Give Mock a bit of time to take effect.
            } catch (InterruptedException ie) {
                throw ie;
            }
        }
        fusedLocationClient.flushLocations();
    }

    // Every call needs registration to be called first at some point.
    public void registerClient(MatchingEngine me) {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        AppClient.RegisterClientReply registerReply;
        AppClient.RegisterClientRequest regRequest;

        try {
            // The app version will be null, but we can build from scratch for test
            List<Pair<String, Long>> ids = me.retrieveCellId(context);
            //me.setSSLEnabled(false);
            AppClient.RegisterClientRequest.Builder regRequestBuilder = AppClient.RegisterClientRequest.newBuilder()
                    .setOrgName(organizationName)
                    .setAppName(applicationName)
                    .setAppVers(appVersion);
            if (ids != null && ids.size() > 0) {
                regRequestBuilder.setCellId(me.retrieveCellId(context).get(0).second.intValue());
            }
            regRequest = regRequestBuilder.build();
            if (useHostOverride) {
                registerReply = me.registerClient(regRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                registerReply = me.registerClient(regRequest, GRPC_TIMEOUT_MS);
            }
            // TODO: Validate JWT
        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertTrue("ExecutionException registering client.", false);
        } catch (ExecutionException ee) {
            Log.e(TAG, Log.getStackTraceString(ee));
            assertTrue("ExecutionException registering client", false);
        } catch (InterruptedException ioe) {
            Log.e(TAG, Log.getStackTraceString(ioe));
            assertTrue("InterruptedException registering client", false);
        }
    }

    @Test
    public void verifyLocationTest() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        MatchingEngine me = new MatchingEngine(context);
        //me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        //me.setAllowSwitchIfNoSubscriberInfo(true);
        //me.setSSLEnabled(false);
        AppClient.VerifyLocationReply verifyLocationReply = null;

        try {
            //enableMockLocation(context, true);
            //Location mockLoc = MockUtils.createLocation("verifyLocationTest", -96.994, 32.4824);
            //setMockLocation(context, mockLoc);

            //Location location = getTestLocation(-96.994, 32.4824);
            Location location = getTestLocation( 33.00,-96.54);

            //String carrierName = me.getCarrierName(context);
            registerClient(me);

            AppClient.VerifyLocationRequest verifyLocationRequest = me.createDefaultVerifyLocationRequest(context, location)
                    //.setCarrierName(carrierName)
                    .build();

            if (useHostOverride) {
                verifyLocationReply = me.verifyLocation(verifyLocationRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                verifyLocationReply = me.verifyLocation(verifyLocationRequest, GRPC_TIMEOUT_MS);
            }
            assert (verifyLocationReply != null);
        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("VerifyLocation: DmeDnsException", true);
        } catch (IOException ioe) {
            Log.e(TAG, Log.getStackTraceString(ioe));
            assertFalse("VerifyLocation: IOException!", true);
        } catch (ExecutionException ee) {
            Log.e(TAG, Log.getStackTraceString(ee));
            assertFalse("VerifyLocation: ExecutionExecution!", true);
        } catch (StatusRuntimeException sre) {
            Log.e(TAG, Log.getStackTraceString(sre));
            assertFalse("VerifyLocation: StatusRuntimeException!", true);
        } catch (InterruptedException ie) {
            Log.e(TAG, Log.getStackTraceString(ie));
            assertFalse("VerifyLocation: InterruptedException!", true);
        } finally {
            enableMockLocation(context, false);
        }


        // Temporary.
        assertEquals(0, verifyLocationReply.getVer());
        assertEquals(AppClient.VerifyLocationReply.TowerStatus.TOWER_UNKNOWN, verifyLocationReply.getTowerStatus());
        assertEquals(AppClient.VerifyLocationReply.GPSLocationStatus.LOC_ROAMING_COUNTRY_MISMATCH, verifyLocationReply.getGpsLocationStatus());
    }

    @Test
    public void verifyLocationFutureTest() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        me.setAllowSwitchIfNoSubscriberInfo(true);
        //me.setSSLEnabled(false);
        AppClient.VerifyLocationReply verifyLocationReply = null;
        Future<AppClient.VerifyLocationReply> verifyLocationReplyFuture = null;

        try {
            Location location = getTestLocation( 33.00,-96.54);

            //String carrierName = me.getCarrierName(context);
            registerClient(me);
            AppClient.VerifyLocationRequest verifyLocationRequest = me.createDefaultVerifyLocationRequest(context, location)
                    //.setCarrierName(carrierName)
                    .build();
            if (useHostOverride) {
                verifyLocationReplyFuture = me.verifyLocationFuture(verifyLocationRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                verifyLocationReplyFuture = me.verifyLocationFuture(verifyLocationRequest, GRPC_TIMEOUT_MS);
            }
            verifyLocationReply = verifyLocationReplyFuture.get();
        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("verifyLocationFutureTest: DmeDnsException", true);
        } catch (ExecutionException ee) {
            Log.e(TAG, Log.getStackTraceString(ee));
            assertFalse("verifyLocationFutureTest: ExecutionException Failed!", true);
        } catch (InterruptedException ie) {
            Log.e(TAG, Log.getStackTraceString(ie));
            assertFalse("verifyLocationFutureTest: InterruptedException!", true);
        }


        // Temporary.
        assertEquals(0, verifyLocationReply.getVer());
        assertEquals(AppClient.VerifyLocationReply.TowerStatus.TOWER_UNKNOWN, verifyLocationReply.getTowerStatus());
        assertEquals(AppClient.VerifyLocationReply.GPSLocationStatus.LOC_ROAMING_COUNTRY_MISMATCH, verifyLocationReply.getGpsLocationStatus());
    }


    /**
     * Mocked Location test. Note that responsibility of verifying location is in the MatchingEngine
     * on the server side, not client side.
     */
    @Test
    public void verifyMockedLocationTest_NorthPole() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        enableMockLocation(context,true);

        Location mockLoc = MockUtils.createLocation("verifyMockedLocationTest_NorthPole", 90d, 1d);

        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        me.setAllowSwitchIfNoSubscriberInfo(true);
        //me.setSSLEnabled(false);

        AppClient.VerifyLocationReply verifyLocationReply = null;
        try {
            Location location = getTestLocation( 33.00,-96.54);

            //String carrierName = me.getCarrierName(context);
            registerClient(me);
            AppClient.VerifyLocationRequest verifyLocationRequest = me.createDefaultVerifyLocationRequest(context, location)
                    //.setCarrierName(carrierName)
                    .build();
            if (useHostOverride) {
                verifyLocationReply = me.verifyLocation(verifyLocationRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                verifyLocationReply = me.verifyLocation(verifyLocationRequest, GRPC_TIMEOUT_MS);
            }
            assert(verifyLocationReply != null);
        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("verifyMockedLocationTest_NorthPole: DmeDnsException", true);
        } catch (IOException ioe) {
            Log.e(TAG, Log.getStackTraceString(ioe));
            assertFalse("verifyMockedLocationTest_NorthPole: IOException!", true);
        } catch (ExecutionException ee) {
            Log.e(TAG, Log.getStackTraceString(ee));
            assertFalse("verifyMockedLocationTest_NorthPole: ExecutionException!", true);
        } catch (InterruptedException ie) {
            Log.e(TAG, Log.getStackTraceString(ie));
            assertFalse("verifyMockedLocationTest_NorthPole: InterruptedException!", true);
        }

        // Temporary.
        assertEquals(0, verifyLocationReply.getVer());
        assertEquals(AppClient.VerifyLocationReply.TowerStatus.TOWER_UNKNOWN, verifyLocationReply.getTowerStatus());
        assertEquals(AppClient.VerifyLocationReply.GPSLocationStatus.LOC_ROAMING_COUNTRY_MISMATCH, verifyLocationReply.getGpsLocationStatus()); // Based on test data.

    }

    @Test
    public void getAppInstListTest() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        me.setAllowSwitchIfNoSubscriberInfo(true);

        AppClient.AppInstListReply appInstListReply = null;

        try {
            Location location = getTestLocation( 33.00,-96.54);
            //me.setSSLEnabled(false);
            registerClient(me);
            AppClient.AppInstListRequest appInstListRequest;
            AppClient.AppInstListReply list;
            appInstListRequest  = me.createDefaultAppInstListRequest(context, location)
                    .setCarrierName(findCloudletCarrierOverride)
                    .build();
            if (useHostOverride) {
                list = me.getAppInstList(appInstListRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                list = me.getAppInstList(appInstListRequest, GRPC_TIMEOUT_MS);
            }

            assertEquals(0, list.getVer());
            assertEquals(AppClient.AppInstListReply.AIStatus.AI_SUCCESS, list.getStatus());
            assertEquals(3, list.getCloudletsCount()); // NOTE: This is entirely test server dependent.
            for (int i = 0; i < list.getCloudletsCount(); i++) {
                Log.v(TAG, "Cloudlet: " + list.getCloudlets(i).toString());
            }

        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("getAppInstListTest: DmeDnsException", true);
        } catch (ExecutionException ee) {
            Log.i(TAG, Log.getStackTraceString(ee));
            assertFalse("getAppInstListTest: ExecutionException!", true);
        } catch (StatusRuntimeException sre) {
            Log.i(TAG, Log.getStackTraceString(sre));
            Log.i(TAG, sre.getMessage());
            assertFalse("getAppInstListTest: StatusRuntimeException!", true);
        } catch (InterruptedException ie) {
            Log.i(TAG, Log.getStackTraceString(ie));
            assertFalse("getAppInstListTest: InterruptedException!", true);
        }
    }

    @Test
    public void getAppInstListFutureTest() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        me.setAllowSwitchIfNoSubscriberInfo(true);
        //me.setSSLEnabled(false);

        try {
            Location location = getTestLocation( 33.00,-96.54);

            registerClient(me);
            AppClient.AppInstListRequest appInstListRequest = me.createDefaultAppInstListRequest(context, location)
                    .setCarrierName(findCloudletCarrierOverride)
                    .build();

            Future<AppClient.AppInstListReply> listFuture;
            if (useHostOverride) {
                listFuture = me.getAppInstListFuture(appInstListRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                listFuture = me.getAppInstListFuture(appInstListRequest, GRPC_TIMEOUT_MS);
            }
            AppClient.AppInstListReply list = listFuture.get();

            assertEquals(0, list.getVer());
            assertEquals(AppClient.AppInstListReply.AIStatus.AI_SUCCESS, list.getStatus());
            assertEquals(3, list.getCloudletsCount()); // NOTE: This is entirely test server dependent.
            for (int i = 0; i < list.getCloudletsCount(); i++) {
                Log.v(TAG, "Cloudlet: " + list.getCloudlets(i).toString());
            }

        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("getAppInstListFutureTest: DmeDnsException", true);
        } catch (ExecutionException ee) {
            Log.i(TAG, Log.getStackTraceString(ee));
            assertFalse("getAppInstListFutureTest: ExecutionException!", true);
        } catch (StatusRuntimeException sre) {
            Log.i(TAG, sre.getMessage());
            Log.i(TAG, Log.getStackTraceString(sre));
            assertFalse("getAppInstListFutureTest: StatusRuntimeException!", true);
        } catch (InterruptedException ie) {
            Log.i(TAG, Log.getStackTraceString(ie));
            assertFalse("getAppInstListFutureTest: InterruptedException!", true);
        }
    }



    /**
     * Tests the MatchingEngine SDK supplied TCP connection to the edge cloudlet.
     *
     * This is a raw stream to a test echo server, so there are no explicit message delimiters.
     */
    @Test
    public void appConnectionTestTcp001() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();

        MatchingEngine me = new MatchingEngine(context);
        me.setUseWifiOnly(useWifiOnly);
        AppConnectionManager appConnect = me.getAppConnectionManager();
        //me.setSSLEnabled(false);

        enableMockLocation(context, true);

        Socket s = null;
        BufferedOutputStream bos = null;
        BufferedInputStream bis = null;
        try {
            // Test against Http Echo.
            String carrierName = "GDDT";
            String appName = applicationName;
            String orgName = "MobiledgeX";
            String appVersion = "1.0";

            // Exercise and override the default:
            // The app version will be null, but we can build from scratch for test
            AppClient.RegisterClientRequest regRequest = AppClient.RegisterClientRequest.newBuilder()
                    //.setCarrierName(me.getCarrierName(context))
                    .setOrgName(orgName)
                    .setAppName(appName)
                    .setAppVers(appVersion)
                    .build();

            AppClient.RegisterClientReply registerClientReply;
            if (true) {
                registerClientReply = me.registerClient(regRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                registerClientReply = me.registerClient(regRequest, GRPC_TIMEOUT_MS);
            }
            assertTrue("Register did not succeed for HttpEcho appInst", registerClientReply.getStatus() == AppClient.ReplyStatus.RS_SUCCESS);

            Location location = getTestLocation( 33.00,-96.54);

            // Defaults:
            AppClient.FindCloudletRequest findCloudletRequest = me.createDefaultFindCloudletRequest(context, location)
                    .setCarrierName(findCloudletCarrierOverride)
                    .build();

            AppClient.FindCloudletReply findCloudletReply;
            if (true) {
                findCloudletReply = me.findCloudlet(findCloudletRequest, hostOverride, portOverride, GRPC_TIMEOUT_MS);
            } else {
                findCloudletReply = me.findCloudlet(findCloudletRequest, GRPC_TIMEOUT_MS);
            }

            // Just using first one. This depends entirely on the server design.
            List<AppPort> appPorts = findCloudletReply.getPortsList();
            assertTrue("AppPorts is null", appPorts != null);
            assertTrue("AppPorts is empty!", appPorts.size() > 0);

            HashMap<Integer, AppPort> portMap = appConnect.getTCPMap(findCloudletReply);
            AppPort one = portMap.get(8085); // This internal port depends entirely the AppInst configuration/Docker image.

            assertTrue("EndPort is expected to be 0 for this AppInst", one.getEndPort() == 0 );
            // The actual mapped Public port, or one between getPublicPort() to getEndPort(), inclusive.
            Future<Socket> fs = appConnect.getTcpSocket(findCloudletReply, one, one.getPublicPort(), (int)GRPC_TIMEOUT_MS);

            // Interface bound TCP socket.
            s = fs.get(); // Nothing to do. Await value.
            try {
                bos = new BufferedOutputStream(s.getOutputStream());
                String data = "{\"/automation.html\"}";
                String rawpost = "GET / HTTP/1.1\r\n" +
                        "Host: 80.187.134.5:8085\r\n" +
                        "User-Agent: curl/7.54.0\r\n" +
                        "Accept: */*\r\n" +
                        "Content-Length: " + data.length() + "\r\n" +
                        "Content-Type: text/html\r\n" +
                        "\r\n" + data;
                bos.write(rawpost.getBytes());
                bos.flush();

                Object aMon = new Object(); // Some arbitrary object Monitor.
                synchronized (aMon) {
                    aMon.wait(1000);
                }

                bis = new BufferedInputStream(s.getInputStream());
                int available = bis.available();
                assertTrue("No bytes available in response.", available > 0); // Probably true.

                byte[] b = new byte[4096];
                int numRead = bis.read(b);
                assertTrue("Didn't get response!", numRead > 0);

                String output = new String(b);
                Log.i(TAG, "output="+output);
                // http client, we are expecting xml back. Verify the output of the directory listing contains 'automation.html'
                boolean found = output.indexOf("automation.html") != -1 ? true : false;;

                assertTrue("Didn't find text automation.html in response!", found == true);

            } catch (IOException ioe) {
                assertTrue("Failed to get output stream for socket!", false);
            }

        } catch (DmeDnsException dde) {
            Log.e(TAG, Log.getStackTraceString(dde));
            assertFalse("appConnectionTestTcp001: DmeDnsException", true);
        } catch (ExecutionException ee) {
            Log.i(TAG, Log.getStackTraceString(ee));
            assertFalse("appConnectionTestTcp001: ExecutionException!", true);
        //} catch (PackageManager.NameNotFoundException ee) {
        //    Log.e(TAG, Log.getStackTraceString(ee));
        //    assertFalse("FindCloudlet: ExecutionException!", true);

        } catch (StatusRuntimeException sre) {
            Log.i(TAG, sre.getMessage());
            Log.i(TAG, Log.getStackTraceString(sre));
            assertFalse("appConnectionTestTcp001: StatusRuntimeException!", true);
        } catch (InterruptedException ie) {
            Log.i(TAG, Log.getStackTraceString(ie));
            assertFalse("appConnectionTestTcp001: InterruptedException!", true);
        } finally {
            try {
                if (bis != null) {
                    bis.close();
                }
                if (bos != null) {
                    bos.close();
                }
                if (s != null) {
                    s.close();
                }
            } catch (IOException ioe) {
                assertFalse("IO Exceptions trying to close socket.", true);
            }
            me.setNetworkSwitchingEnabled(true);
        }
    }


    /**
     * NOTE: HttpEcho may only be installed on wifi.dme domain
     */

    @Test
    public void testRegisterAndFindCloudlet_001() {
        Context context = InstrumentationRegistry.getInstrumentation().getTargetContext();
        MatchingEngine me = new MatchingEngine(context);
        //me.setUseWifiOnly(useWifiOnly);
        me.setMatchingEngineLocationAllowed(true);
        //me.setAllowSwitchIfNoSubscriberInfo(true);

        AppConnectionManager appConnectionManager = me.getAppConnectionManager();

        AppClient.RegisterClientReply registerClientReply = null;

        Socket socket = null;
        try {
            Location location = getTestLocation( 33.00,-96.54);
            myTag.put("Tag1", "LeonsTag");

//            Future<AppClient.FindCloudletReply> findCloudletReplyFuture = me.registerAndFindCloudlet(context, hostOverride, portOverride,
//                    organizationName, appName,
//                    appVersion, location, "",
//                    0, null, null, null); // FIXME: These parameters should be overloaded or optional.

            //me.setSSLEnabled(false);
            Future<AppClient.FindCloudletReply> findCloudletReplyFuture = me.registerAndFindCloudlet(context, hostOverride, portOverride,
                    organizationName, applicationName, appVersion, location, "",0, "", "", myTag, MatchingEngine.FindCloudletMode.PROXIMITY);

            // Just wait:
            AppClient.FindCloudletReply findCloudletReply = findCloudletReplyFuture.get();
            HashMap<Integer, AppPort> appTcpPortMap = appConnectionManager.getTCPMap(findCloudletReply);
            AppPort appPort = appTcpPortMap.get(2016);
            assertTrue(appPort != null); // There should be at least one for a connection to be made.
            Future<Socket> socketFuture = me.getAppConnectionManager().getTcpSocket(findCloudletReply, appPort, appPort.getPublicPort(), (int)GRPC_TIMEOUT_MS);
            socket = socketFuture.get();

            assertTrue("FindCloudletReply failed!", findCloudletReply != null);
        } catch (ExecutionException ee) {
            Log.i(TAG, Log.getStackTraceString(ee));
            //assertFalse("testRegisterAndFindCloudlet_001: ExecutionException! "+ee.getLocalizedMessage(), true);
        } catch (StatusRuntimeException sre) {
            Log.i(TAG, Log.getStackTraceString(sre));
            assertFalse("testRegisterAndFindCloudlet_001: StatusRuntimeException!", true);
        } catch (InterruptedException ie) {
            Log.i(TAG, Log.getStackTraceString(ie));
            assertFalse("testRegisterAndFindCloudlet_001: InterruptedException!", true);
        } finally {
            try {
                if (socket != null) {
                    socket.close();
                }
            } catch (IOException ioe) {
                ioe.printStackTrace();
            }
            enableMockLocation(context,false);
        }
    }

    @Test
    public void NetTestAPItest() {
        //TODO
    }

}

