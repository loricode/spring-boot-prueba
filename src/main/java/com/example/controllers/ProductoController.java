package com.example.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.models.Producto;
import com.example.repository.*;

@RestController
@CrossOrigin()
@RequestMapping("/api/producto")
public class ProductoController {

	@Autowired
	private ProductoRepository repository;
	
	@GetMapping("/greeting")
	public @ResponseBody String greeting() {
		return "HelloWord";
	}
	 
	@GetMapping(value = "/search/{text}")
	public List<Producto> getProducts(@PathVariable String text) {
		
		if(text.equals("all")) {
		
		  return repository.findAll();
			  
	    } 
		  
		return repository.buscarProducto(text);
	
	}
	
	@PostMapping("/save")
	public Object addProduct(@RequestBody Producto product) {
		return repository.save(product);
	}
	
	@DeleteMapping(value = "/delete/{id}")
	public void deleteProduct(@PathVariable int id) {
		repository.deleteById(id);
	}

	@GetMapping(value = "/get/{id}")
	public Optional<Producto> getProduct(@PathVariable int id){
		return repository.findById(id);
	}
	  
	@PutMapping("/update")
	public void UpdatePruduct(@RequestBody Producto product){
		  repository.saveAndFlush(product);
	} 
	
}
