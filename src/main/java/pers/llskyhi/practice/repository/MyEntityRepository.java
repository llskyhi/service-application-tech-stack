package pers.llskyhi.practice.repository;

import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;
import pers.llskyhi.practice.domain.MyEntity;

@ApplicationScoped
public class MyEntityRepository implements PanacheRepository<MyEntity> {
}
