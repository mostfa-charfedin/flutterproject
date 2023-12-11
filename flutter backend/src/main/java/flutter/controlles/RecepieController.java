package flutter.controlles;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;


import flutter.entities.Recepie;
import flutter.entities.User;
import flutter.repositories.RecepieRepository;
import flutter.services.RecepieService;


@RestController
@RequestMapping("/recepie")
public class RecepieController {
	
	
	@Autowired
	private RecepieService recepieService ;
	@Autowired
	private  RecepieRepository recepieRepository;

	
	@GetMapping
	public List<Recepie> getAllRecepie()
	{
		return recepieService.getAllRecepie();
	}
	
	@GetMapping(path="/{id}")
	public ResponseEntity<Recepie> findRecepieById(@PathVariable Long id)
	{
		Recepie recepie= recepieService.findRecepieById(id);
		
		if(recepie==null)
		{
			return new ResponseEntity<Recepie>(HttpStatus.NO_CONTENT);
		}else {
			return new ResponseEntity<Recepie>(recepie,HttpStatus.OK);
		}
	}
	
	

	

	

	@PostMapping
	public Recepie CreateRecepie(@RequestBody Recepie recepie)
	{
		Recepie createdRecepie = recepieService.createRecepie(recepie);
        
        return createdRecepie;
	
	}	
	
	@PutMapping
	public Recepie UpdateRecepie(@RequestBody Recepie recepie)
	{
		return recepieService.updateRecepie(recepie);
	}	
	
	
	
	
	@DeleteMapping(path="/supprimer/{id}")
	public void deleteRecepie(@PathVariable Long id)
	{
		recepieService.deleteRecepie( id);
	}
	
	
	 @PutMapping(path="/{id}")
	    public ResponseEntity<Recepie> updateRecepieById(@PathVariable Long id, @RequestBody Recepie updatedRecepie) {
		 Recepie updatedrecepie = recepieService.updateRecepieById(id, updatedRecepie);
	        return ResponseEntity.ok(updatedrecepie);
	    }
	
	 
	
}
