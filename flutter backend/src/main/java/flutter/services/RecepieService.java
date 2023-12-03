package flutter.services;

import java.util.List;

import flutter.entities.Recepie;



public interface RecepieService {

	public List<Recepie> getAllRecepie();
	public Recepie findRecepieById(Long id);
	public Recepie createRecepie(Recepie recepie);
	public Recepie updateRecepie(Recepie recepie);
	public void deleteRecepie(Long id);
	public Recepie updateRecepieById(Long id, Recepie updatedRecepie);


}