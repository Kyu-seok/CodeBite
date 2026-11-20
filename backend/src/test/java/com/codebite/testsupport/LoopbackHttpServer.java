package com.codebite.testsupport;

import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.net.InetSocketAddress;

/**
 * A JDK {@link HttpServer} on 127.0.0.1 and a free port, for tests that stand in for an HTTP API.
 *
 * <p>Never bind the wildcard address and call it {@code localhost}: the JDK binds with
 * {@code SO_REUSEADDR}, so the kernel may hand a wildcard listener a port another process already
 * listens on at 127.0.0.1 (macOS hands out ephemeral ports in sequence and reaches every port
 * again), and requests then go to that process (#247). A 127.0.0.1 listener never shares its port
 * with another 127.0.0.1 listener.
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
