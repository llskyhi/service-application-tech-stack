package pers.llskyhi.practice.resource;

import java.util.List;
import java.util.UUID;

import jakarta.transaction.Transactional;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import lombok.RequiredArgsConstructor;
import pers.llskyhi.practice.domain.MyEntity;
import pers.llskyhi.practice.repository.MyEntityRepository;

@Path("/my-entity")
@RequiredArgsConstructor
public class MyEntityResource {
    final MyEntityRepository myEntityRepository;

    @GET
    @Path("add")
    @Transactional
    public void add() {
        final MyEntity toAddEntity = new MyEntity();
        toAddEntity.field = UUID.randomUUID().toString();
        myEntityRepository.persist(toAddEntity);
    }

    @GET
    public List<MyEntity> list() {
        return myEntityRepository.findAll().list();
    }
}
