package com.example.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.models.Producto;


@EnableJpaRepositories
@Repository
public interface ProductoRepository extends JpaRepository<Producto, Integer>  {

	
	@Query(value="SELECT id, nombre, descripcion, precio, categoria FROM producto WHERE nombre LIKE '%' :text '%'", nativeQuery = true)
	public List<Producto>  buscarProducto(@Param("text") String text);
	
}
