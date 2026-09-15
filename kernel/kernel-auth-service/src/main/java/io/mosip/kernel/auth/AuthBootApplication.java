package io.mosip.kernel.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Spring Boot entry point for the MOSIP auth manager HTTP service.
 * <p>
 * The runnable artifact is authmanager, typically listening on port {@code 8091}
 * with servlet path {@code /v1/authmanager}. Component scan includes REST
 * controllers, servlet configuration, the configured auth-adapter and IAM
 * implementation packages, and kernel-core logger configuration. Identity is
 * backed by Keycloak.
 */
@SpringBootApplication(scanBasePackages = {"io.mosip.kernel.auth.controller","io.mosip.kernel.auth.config","${mosip.auth.adapter.impl.basepackage}","${mosip.iam.impl.basepackage}", "io.mosip.kernel.core.logger.config"})
public class AuthBootApplication {

	/**
	 * Starts the Spring Boot application context for authmanager.
	 *
	 * @param args command-line arguments passed to {@link SpringApplication}
	 */
	public static void main(String[] args) {
		SpringApplication.run(AuthBootApplication.class, args);

	}
}
