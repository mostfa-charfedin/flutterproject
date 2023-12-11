package flutter.services;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import flutter.entities.Recepie;

import flutter.repositories.RecepieRepository;

@Service
public class RecepieServiceimpl implements RecepieService{

	
	@Autowired
	private  RecepieRepository recepieRepository;


	
	//get all Recepies
		@Override
		public List<Recepie>  getAllRecepie(){
			
			return recepieRepository.findAll();
		}

		
	//find recepie by Id
		@Override
		public Recepie findRecepieById(Long id) {
			Optional<Recepie> reOptional = recepieRepository.findById(id); 
			
			if(reOptional.isEmpty() ) {
				return null;
			}else {
				return reOptional.get();
			}
				
		}

		
	//create recepie
		@Override
		public Recepie createRecepie(Recepie recepie) {
			return recepieRepository.save(recepie);
		}

		
	// update recepie
		@Override
		public Recepie updateRecepie(Recepie recepie) {
			Optional<Recepie> reOptional = recepieRepository.findById(recepie.getId()); 
			if(reOptional.isEmpty() ) {
				return null;
			}else {
				return recepieRepository.save(recepie);
			}
		}

		
	//delete recepie
		@Override
		public void deleteRecepie(Long id) {
			recepieRepository.deleteById(id);	
		}
		
		
		
		@Override
		public Recepie updateRecepieById(Long id, Recepie updatedRecepie) {
		    Optional<Recepie> recepieOptional = recepieRepository.findById(id);
		    if (recepieOptional.isPresent()) {
		    	Recepie existingRecepie = recepieOptional.get();
		        
		
		        if (updatedRecepie.getName() != null) {
		            existingRecepie.setName(updatedRecepie.getName());
		        }
		        
		        if (updatedRecepie.getDescription() != null) {
		            existingRecepie.setDescription(updatedRecepie.getDescription());
		        }
		        
		        if (updatedRecepie.getIngredient() != null) {
		            existingRecepie.setIngredient(updatedRecepie.getIngredient());
		        }
		        if (updatedRecepie.getImage() != null) {
		            existingRecepie.setImage(updatedRecepie.getImage());
		        }
		        if (updatedRecepie.getUserid() != null) {
		            existingRecepie.setUserid(updatedRecepie.getUserid());
		        }
		        
		        
		        // Save the updated recepie
		        return recepieRepository.save(existingRecepie);
		    } 
		    else {
		        throw new NoSuchElementException("Recepie not found id : " + id);
		    }
		}



	


	}
