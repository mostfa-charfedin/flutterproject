package flutter.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import flutter.entities.User;



@Repository
public interface UserRepository extends JpaRepository<User,Long>{
	 Optional<User> findByname(String name);
	 User findByEmailAndPassword(String email, String password);

}
