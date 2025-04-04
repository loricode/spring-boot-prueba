package com.example;


import static org.assertj.core.api.Assertions.assertThat;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


import org.springframework.test.web.servlet.MockMvc;

import com.example.controllers.ProductoController;


@SpringBootTest
@AutoConfigureMockMvc
class PruebaBackendJavaApplicationTests {

	@Autowired
	private MockMvc mockMvc;
	
	@Autowired
	private ProductoController controller;
	
	@Test
	void contextLoads() {
		
		assertThat(controller).isNotNull();
		
	}
	
	@Test
	void testSearchDataFromService() throws Exception {
		  
		this.mockMvc.perform(get("/api/producto/search/all")).andDo(print()).andExpect(status().isOk());
				
	}

}
