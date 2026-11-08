package com.codebite.sitemap;

import com.codebite.config.SiteProperties;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.SitemapEntry;
import org.springframework.http.CacheControl;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.ZoneOffset;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * The XML sitemap: the public pages crawlers should know about, which the app itself can't tell
 * them (every route is the same HTML shell, and the problem list links only the default curation).
 * nginx serves it at /sitemap.xml; robots.txt names it.
 */
@RestController
public class SitemapController {

    /** Routes with no row of their own; the problem pages are listed from the database. */
    private static final List<String> STATIC_PATHS = List.of("/", "/problems", "/roadmap");

    private final ProblemRepository problemRepository;
    private final String baseUrl;

    public SitemapController(ProblemRepository problemRepository, SiteProperties site) {
        this.problemRepository = problemRepository;
        this.baseUrl = site.baseUrl();
    }

    /** Every URL under {@code app.site.base-url}; a problem's {@code lastmod} is its last update. */
    @GetMapping(value = "/api/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    public ResponseEntity<String> sitemap() {
        StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n")
                .append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n");
        for (String path : STATIC_PATHS) {
            appendUrl(xml, path, null);
        }
        for (SitemapEntry entry : problemRepository.findSitemapEntries()) {
            appendUrl(xml, "/problems/" + entry.slug(), entry);
        }
        xml.append("</urlset>\n");
        return ResponseEntity.ok()
                .cacheControl(CacheControl.maxAge(1, TimeUnit.HOURS).cachePublic())
                .body(xml.toString());
    }

    private void appendUrl(StringBuilder xml, String path, SitemapEntry entry) {
        xml.append("  <url>\n    <loc>").append(escape(baseUrl + path)).append("</loc>\n");
        if (entry != null && entry.updatedAt() != null) {
            xml.append("    <lastmod>").append(entry.updatedAt().atZone(ZoneOffset.UTC).toLocalDate()).append("</lastmod>\n");
        }
        xml.append("  </url>\n");
    }

    /** Slugs are [a-z0-9-], but the base URL is configuration: escape what XML reserves. */
    private static String escape(String text) {
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\"", "&quot;").replace("'", "&apos;");
    }
}
