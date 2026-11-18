package mx.edu.tecdesoftware.market_backend.persistence.web.controller;

import java.util.ArrayList;
import java.util.List;
import mx.edu.tecdesoftware.market_backend.domain.service.Category;
import mx.edu.tecdesoftware.market_backend.persistence.crud.CategoriaCrudRepository;
import mx.edu.tecdesoftware.market_backend.persistence.mapper.CategoryMapper;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories")
@CrossOrigin(origins = "*")
public class CategoryController {
    private final CategoriaCrudRepository repository;
    private final CategoryMapper mapper;

    public CategoryController(CategoriaCrudRepository repository, CategoryMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @GetMapping
    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        repository.findAll().forEach(entity -> categories.add(mapper.toCategory(entity)));
        return categories;
    }
}
