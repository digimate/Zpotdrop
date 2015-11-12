package com.zpotdrop.api;

import android.content.Context;
import android.util.Base64;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.util.ArrayList;

public class SmartRestClient {
    private static final String HTTPS_STRING = "https";
    private ArrayList<NameValuePair> headers;
    private String message;
    private ArrayList<NameValuePair> params;
    private String response;
    private int responseCode;
    private String url;
    private Context context;

    public SmartRestClient(String url) {
        this.url = url;
        params = new ArrayList<NameValuePair>();
        headers = new ArrayList<NameValuePair>();
    }

//	private static SmartRestClient instance = null;
//	public static SmartRestClient getInstance(){
//		if(instance == null) {
//			instance = new SmartRestClient();
//		}
//		return instance;
//	}

    private static String getB64Auth() {
        String source = "tixel" + ":" + "COjzm22H";
        String ret = "Basic "
                + Base64.encodeToString(source.getBytes(), Base64.URL_SAFE
                | Base64.NO_WRAP);
        return ret;
    }

    public String getErrorMessage() {
        return message;
    }

    public String getResponse() {
        return response;
    }

    public int getResponseCode() {
        return responseCode;
    }

    private String convertStreamToString(InputStream is) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }

    public void addHeader(String name, String value) {
        headers.add(new BasicNameValuePair(name, value));
    }

    public void addParam(String name, String value) {
        params.add(new BasicNameValuePair(name, value));
    }

    public void execute(RequestMethod method, Context ctx) throws Exception {
        this.context = ctx;
        switch (method) {
            case GET: {
                // add parameters
                String combinedParams = "";
                if (!params.isEmpty()) {
                    combinedParams += "?";
                    for (NameValuePair p : params) {
                        String paramString = p.getName() + "="
                                + URLEncoder.encode(p.getValue(), "UTF-8");
                        if (combinedParams.length() > 1) {
                            combinedParams += "&" + paramString;
                        } else {
                            combinedParams += paramString;
                        }
                    }
                }

                HttpGet request = new HttpGet(url + combinedParams);

                // add headers
                for (NameValuePair h : headers) {
                    request.addHeader(h.getName(), h.getValue());
                }

                //executeRequest(request, url, ctx);
                executeRequest(request);
                break;
            }
            case POST: {
                HttpPost request = new HttpPost(url);

                // add headers
                for (NameValuePair h : headers) {
                    request.addHeader(h.getName(), h.getValue());
                }

                if (!params.isEmpty()) {
                    request.setEntity(new UrlEncodedFormEntity(params, HTTP.UTF_8));
                }

                //executeRequest(request, url, ctx);
                executeRequest(request);
                break;
            }
        }
    }

    public void executeRequest(HttpUriRequest request) {
        HttpClient httpClient = HTTPUtils.getNewHttpClient(this.context, url.startsWith(HTTPS_STRING));
        HttpResponse httpResponse = null;

        try {
            httpResponse = httpClient.execute(request);
            responseCode = httpResponse.getStatusLine().getStatusCode();
            message = httpResponse.getStatusLine().getReasonPhrase();

            HttpEntity entity = httpResponse.getEntity();

            if (entity != null) {
                InputStream instream = entity.getContent();
                response = convertStreamToString(instream);

                // Closing the input stream will trigger connection release
                instream.close();
            }

        } catch (ClientProtocolException e) {
            httpClient.getConnectionManager().shutdown();
            e.printStackTrace();
        } catch (IOException e) {
            httpClient.getConnectionManager().shutdown();
            e.printStackTrace();
        }
    }

    public enum RequestMethod {
        GET, POST
    }
}
