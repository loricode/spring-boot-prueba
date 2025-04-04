package com.example.models;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;

@Entity
public class Producto {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
    public int ID;
	
	public String nombre;
	
	public String descripcion;
	
	public float precio;
	
	public String categoria;
	
	@OneToMany(mappedBy = "producto", cascade = CascadeType.ALL)
    private List<Inventario> inventario;
	
}
