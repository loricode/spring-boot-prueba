package com.example.models;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Inventario {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
    public int ID;
	
	public int cantidadDisponible;
	
	@ManyToOne
    @JoinColumn(name =  "id_producto") 
	public Producto producto;
	
	public String ubicacion;
	
}
