package com.codebite.github.gateway;

import io.jsonwebtoken.Jwts;

import java.io.ByteArrayOutputStream;
import java.nio.charset.StandardCharsets;
import java.security.GeneralSecurityException;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;

/**
 * Signs the short-lived RS256 JWT that authenticates as the GitHub App itself, which is only
 * ever exchanged for an installation token.
 *
 * <p>GitHub issues App keys as PKCS#1 PEM ({@code BEGIN RSA PRIVATE KEY}), which the JDK cannot
 * read directly, so the DER is wrapped in a PKCS#8 envelope by hand. PKCS#8 PEM is accepted too.
 */
final class GitHubAppJwt {

    /** AlgorithmIdentifier SEQUENCE { OID 1.2.840.113549.1.1.1 (rsaEncryption), NULL }. */
    private static final byte[] RSA_ALGORITHM_ID = {
            0x30, 0x0D, 0x06, 0x09, 0x2A, (byte) 0x86, 0x48, (byte) 0x86, (byte) 0xF7, 0x0D, 0x01, 0x01, 0x01, 0x05, 0x00};

    private final String appId;
    private final PrivateKey key;

    GitHubAppJwt(String appId, String privateKeyPemBase64) {
        this.appId = appId;
        this.key = parse(privateKeyPemBase64);
    }

    /** Backdated 60 s for clock drift; GitHub caps the lifetime at 10 minutes. */
    String sign(Instant now) {
        return Jwts.builder()
                .issuer(appId)
                .issuedAt(Date.from(now.minusSeconds(60)))
                .expiration(Date.from(now.plusSeconds(540)))
                .signWith(key, Jwts.SIG.RS256)
                .compact();
    }

    private static PrivateKey parse(String pemBase64) {
        String pem = new String(Base64.getMimeDecoder().decode(pemBase64.trim()), StandardCharsets.US_ASCII);
        boolean pkcs1 = pem.contains("BEGIN RSA PRIVATE KEY");
        byte[] der = Base64.getMimeDecoder().decode(pem.replaceAll("-----[A-Z ]+-----", "").replaceAll("\\s", ""));
        try {
            return KeyFactory.getInstance("RSA").generatePrivate(new PKCS8EncodedKeySpec(pkcs1 ? wrapPkcs1(der) : der));
        } catch (GeneralSecurityException e) {
            throw new GitHubGatewayException("GitHub App private key is not a readable RSA key", e);
        }
    }

    /** PrivateKeyInfo SEQUENCE { INTEGER 0, AlgorithmIdentifier, OCTET STRING pkcs1 }. */
    private static byte[] wrapPkcs1(byte[] pkcs1) {
        ByteArrayOutputStream body = new ByteArrayOutputStream();
        body.writeBytes(new byte[] {0x02, 0x01, 0x00});
        body.writeBytes(RSA_ALGORITHM_ID);
        body.write(0x04);
        body.writeBytes(derLength(pkcs1.length));
        body.writeBytes(pkcs1);

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        out.write(0x30);
        out.writeBytes(derLength(body.size()));
        out.writeBytes(body.toByteArray());
        return out.toByteArray();
    }

    private static byte[] derLength(int length) {
        if (length < 0x80) {
            return new byte[] {(byte) length};
        }
        int bytes = (Integer.SIZE - Integer.numberOfLeadingZeros(length) + 7) / 8;
        byte[] out = new byte[bytes + 1];
        out[0] = (byte) (0x80 | bytes);
        for (int i = 0; i < bytes; i++) {
            out[bytes - i] = (byte) (length >>> (8 * i));
        }
        return out;
    }
}
