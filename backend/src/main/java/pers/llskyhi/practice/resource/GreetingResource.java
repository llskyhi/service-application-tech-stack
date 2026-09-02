package pers.llskyhi.practice.resource;

import io.quarkus.security.identity.SecurityIdentity;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;

@Path("/hello")
public class GreetingResource {

    @Inject
    SecurityIdentity securityIdentity;

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public String hello() {
        return "Hello, %s.".formatted(
                securityIdentity.isAnonymous()
                        ? "guest"
                        : securityIdentity.getPrincipal().getName()
        );
    }
}
