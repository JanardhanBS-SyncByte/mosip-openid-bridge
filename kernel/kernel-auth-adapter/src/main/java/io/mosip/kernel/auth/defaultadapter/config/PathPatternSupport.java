package io.mosip.kernel.auth.defaultadapter.config;

import org.springframework.security.web.servlet.util.matcher.PathPatternRequestMatcher;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Maps MOSIP no-auth Ant patterns onto Spring Security 7
 * {@link PathPatternRequestMatcher}.
 * <p>
 * This adapter is a library other MOSIP services put on the classpath. Older
 * configs used Ant-style matchers such as {@code AntPathRequestMatcher}. Spring
 * Security 7 uses {@code AnyRequestMatcher} together with
 * {@link PathPatternRequestMatcher}; this helper is the only translation layer
 * between those stored Ant strings and PathPattern.
 * <p>
 * PathPattern is relative to the servlet context path, so a leading Ant
 * any-depth prefix ({@code /}**{@code /}) from older configs is stripped. Double-star
 * is only valid as a full path segment.
 */
public final class PathPatternSupport {

	/**
	 * Shared PathPattern matcher builder using Spring Security defaults (servlet
	 * path relative to the context path).
	 */
	private static final PathPatternRequestMatcher.Builder PATHS = PathPatternRequestMatcher.withDefaults();

	/**
	 * Prevents instantiation; all members are static.
	 */
	private PathPatternSupport() {
	}

	/**
	 * Converts a MOSIP Ant-style exclude pattern into a Spring Security 7
	 * PathPattern string.
	 * <p>
	 * Blank, {@code null}, or {@code *} patterns become {@code /}**. A missing
	 * leading slash is added. Repeated {@code /}**{@code /} prefixes are stripped so the
	 * remainder is context-relative. A {@code **} that is not a full path segment
	 * is reduced to a single {@code *}.
	 *
	 * @param pattern the configured Ant-style path, possibly {@code null}
	 * @return a PathPattern string suitable for {@link PathPatternRequestMatcher}
	 */
	public static String toPathPattern(String pattern) {
		if (pattern == null || pattern.isBlank() || "*".equals(pattern.trim())) {
			return "/**";
		}
		String path = pattern.trim();
		if (!path.startsWith("/")) {
			path = "/" + path;
		}
		while (path.startsWith("/**/")) {
			path = "/" + path.substring(4);
		}
		return path.replaceAll("([^/])\\*\\*", "$1*");
	}

	/**
	 * Returns whether the given servlet request matches the MOSIP Ant-style
	 * pattern after {@link #toPathPattern(String)} conversion.
	 * <p>
	 * Illegal PathPattern syntax is treated as a non-match rather than thrown.
	 *
	 * @param request the inbound HTTP request
	 * @param pattern the configured Ant-style path
	 * @return {@code true} if {@link PathPatternRequestMatcher} matches the request
	 */
	public static boolean matches(HttpServletRequest request, String pattern) {
		try {
			return PATHS.matcher(toPathPattern(pattern)).matches(request);
		} catch (IllegalArgumentException ex) {
			return false;
		}
	}
}
