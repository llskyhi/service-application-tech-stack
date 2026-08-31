package pers.llskyhi.practice.resource;

import java.net.URI;
import java.util.List;

import org.eclipse.microprofile.jwt.JsonWebToken;

import io.quarkus.oidc.IdToken;
import io.quarkus.security.identity.SecurityIdentity;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/auth")
public class AuthorizationResource {
    @Inject
    @IdToken
    JsonWebToken idToken;

    @Inject
    JsonWebToken accessToken;

    @Inject
    SecurityIdentity securityIdentity;

    @GET
    @Path("post-logout")
    public Response postLogout() {
        return Response.seeOther(URI.create("/hello"))
                .build();
    }

    @GET
    @Path("test")
    public String test() {
        return "idToken: %s.\n\naccessToken: %s.\n\nidentity: %s.".formatted(
                idToken,
                accessToken,
                List.of(
                        securityIdentity.getPrincipal(),
                        securityIdentity.getRoles(),
                        securityIdentity.getAttributes()
                )
        );
    }
}
