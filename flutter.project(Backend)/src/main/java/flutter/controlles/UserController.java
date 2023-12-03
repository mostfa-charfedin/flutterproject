package flutter.controlles;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;


import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import flutter.entities.User;
import flutter.repositories.UserRepository;
import flutter.services.UserService;



@RestController
@RequestMapping("/user")

public class UserController {
	

	
	@Autowired
	private UserService userService ;
	

	@Autowired
	private  UserRepository userRepository;
	
	@GetMapping("/connexion/{email}/{password}")
	public ResponseEntity<?> getUserByMailAndPassword( @PathVariable(value = "email") String email , @PathVariable (value = "password")String password) {
	    try {
	        System.out.println("Received request with mail: " + email + " and password: " + password);
	        User user = userService.getUserByMailAndPassword(email, password);

	        if (user != null) {
	            return new ResponseEntity<>(user, HttpStatus.OK);
	        } else {
	            System.out.println("User not found");
	            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
	        }
	        
	    } catch (Exception e) {
	        System.out.println("An error occurred: " + e.getMessage());
	        return new ResponseEntity<>("An error occurred: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
	    }
	}

	



	@GetMapping
	public List<User> getAllUsers()
	{
		return userService.getAllUser();
	}
	
	@GetMapping(path="/{id}")
	public ResponseEntity<User> findUserById(@PathVariable Long id)
	{
		User user= userService.findUserById(id);
		
		if(user==null)
		{
			return new ResponseEntity<User>(HttpStatus.NO_CONTENT);
		}else {
			return new ResponseEntity<User>(user,HttpStatus.OK);
		}
	}
	
	

	

	

	@PostMapping
	public User CreateUser(@RequestBody User user)
	{
		User createdUser = userService.createUser(user);
        
        return createdUser;
	
	}	
	
	@PutMapping
	public User UpdateUser(@RequestBody User user)
	{
		return userService.updateUser(user);
	}	
	
	@DeleteMapping(path="/supprimer/{id}")
	public void deleteUser(@PathVariable Long id)
	{
		userService.deleteUser( id);
	}
	
	
	 @PutMapping(path="/{id}")
	    public ResponseEntity<User> updateUserById(@PathVariable Long id, @RequestBody User updatedUser) {
	        User updatedUtilisateur = userService.updateUserById(id, updatedUser);
	        return ResponseEntity.ok(updatedUtilisateur);
	    }
	
}

