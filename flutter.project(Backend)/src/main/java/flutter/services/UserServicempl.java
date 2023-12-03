package flutter.services;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.crossstore.ChangeSetPersister.NotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.PathVariable;

import flutter.entities.User;
import flutter.repositories.UserRepository;




@Service
public class UserServicempl implements UserService{
	
	@Autowired
	private  UserRepository userRepository;

	
//get all users
	@Override
	public List<User> getAllUser() {
		
		return userRepository.findAll();
	}

	
//find user by Id
	@Override
	public User findUserById(Long id) {
		Optional<User> utOptional = userRepository.findById(id); 
		
		if(utOptional.isEmpty() ) {
			return null;
		}else {
			return utOptional.get();
		}
			
	}

	
//create user
	@Override
	public User createUser(User user) {
		return userRepository.save(user);
	}

	
// update user
	@Override
	public User updateUser(User user) {
		Optional<User> utOptional = userRepository.findById(user.getId()); 
		if(utOptional.isEmpty() ) {
			return null;
		}else {
			return userRepository.save(user);
		}
	}

	
//delete user
	@Override
	public void deleteUser(Long id) {
		 userRepository.deleteById(id);	
	}
	
	
	
	@Override
	public User updateUserById(Long id, User updatedUser) {
	    Optional<User> userOptional = userRepository.findById(id);
	    if (userOptional.isPresent()) {
	        User existingUser = userOptional.get();
	        
	
	        if (updatedUser.getName() != null) {
	            existingUser.setName(updatedUser.getName());
	        }
	        
	        if (updatedUser.getLastName() != null) {
	            existingUser.setLastName(updatedUser.getLastName());
	        }
	        
	        if (updatedUser.getPassword() != null) {
	            existingUser.setPassword(updatedUser.getPassword());
	        }
	        
	        // Save the updated user
	        return userRepository.save(existingUser);
	    } else {
	        throw new NoSuchElementException("Utilisateur non trouvé avec l'ID : " + id);
	    }
	}



	 @Override
	    public User getUserByMailAndPassword(String email, String password) {
	        return userRepository.findByEmailAndPassword(email, password);
	    }



}
