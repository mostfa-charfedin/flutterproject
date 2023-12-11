package flutter.entities;

import java.io.Serializable;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Lob;

@Entity
public class Recepie implements Serializable {
	
	private String name;
	private String description;
	private String ingredient;
	
	  @Lob
	  @Column(name = "image", columnDefinition = "BLOB")
	  private byte[] image;
	  
	@Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getIngredient() {
		return ingredient;
	}

	public void setIngredient(String ingredient) {
		this.ingredient = ingredient;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
    

	  public byte[] getImage() {
		    return image;
		  }

		  public void setImage(byte[] image) {
		    this.image = image;
		  }

    
    
}
