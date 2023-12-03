package flutter.services;

import java.util.List;

import flutter.entities.User;



public interface UserService {
	public List<User> getAllUser();
	public User findUserById(Long id);
	public User createUser(User user);
	public User updateUser(User user);
	public void deleteUser(Long id);
	public User updateUserById(Long id, User updatedUser);
	public User getUserByMailAndPassword(String email, String password);

}
