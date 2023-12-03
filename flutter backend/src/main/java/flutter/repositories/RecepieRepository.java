package flutter.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import flutter.entities.Recepie;


@Repository
public interface RecepieRepository extends JpaRepository<Recepie, Long> {
	 Optional<Recepie> findByname(String name);


	

}
