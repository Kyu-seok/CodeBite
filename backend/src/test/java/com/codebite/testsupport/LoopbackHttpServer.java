package com.codebite.testsupport;

import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.InetSocketAddress;

/**
 * A JDK {@link HttpServer} on 127.0.0.1 and a free port, for tests that stand in for an HTTP API.
 *
 * <p>Not the wildcard address: the JDK binds it as IPv6 {@code ::}, and macOS can then hand out a
 * port another process holds on 127.0.0.1, which gets the requests sent to 127.0.0.1 (#247).
 */
public final class LoopbackHttpServer {

    private static final String HOST = "127.0.0.1";

    private LoopbackHttpServer() {
    }

    /** An unstarted server on 127.0.0.1 and a free port. */
    public static HttpServer create() throws IOException {
        return HttpServer.create(new InetSocketAddress(HOST, 0), 0);
    }

    /** {@code http://127.0.0.1:<port>}, the server's base URL with no trailing slash. */
    public static String baseUrl(HttpServer server) {
        return "http://" + HOST + ":" + server.getAddress().getPort();
    }
}
