package io.mosip.kernel.auth.defaultadapter.config;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.lang.reflect.Constructor;

import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

/**
 * Conversion and match behaviour of MOSIP Ant strings on Spring Security 7 PathPattern.
 */
public class PathPatternSupportTest {

	@Test
	public void toPathPatternNormalizesBlankAndStar() {
		assertEquals("/**", PathPatternSupport.toPathPattern(null));
		assertEquals("/**", PathPatternSupport.toPathPattern("  "));
		assertEquals("/**", PathPatternSupport.toPathPattern("*"));
	}

	@Test
	public void toPathPatternAddsSlashStripsPrefixAndGluedDoubleStar() {
		assertEquals("/actuator/**", PathPatternSupport.toPathPattern("actuator/**"));
		assertEquals("/actuator/**", PathPatternSupport.toPathPattern("/**/actuator/**"));
		assertEquals("/favicon*", PathPatternSupport.toPathPattern("/favicon**"));
	}

	@Test
	public void matchesActuatorHealth() {
		MockHttpServletRequest request = new MockHttpServletRequest("GET", "/actuator/health");
		request.setServletPath("/actuator/health");
		assertTrue(PathPatternSupport.matches(request, "/actuator/**"));
		assertFalse(PathPatternSupport.matches(request, "/swagger-ui/**"));
	}

	@Test
	public void matchesIllegalPatternIsFalse() {
		MockHttpServletRequest request = new MockHttpServletRequest("GET", "/api/a/details");
		request.setServletPath("/api/a/details");
		assertFalse(PathPatternSupport.matches(request, "/api/**/details"));
	}

	@Test
	public void privateConstructorIsInvocable() throws Exception {
		Constructor<PathPatternSupport> constructor = PathPatternSupport.class.getDeclaredConstructor();
		constructor.setAccessible(true);
		constructor.newInstance();
	}
}
