package com.codebite.problem.controller;

import com.codebite.problem.dto.TagDto;
import com.codebite.problem.repository.TagRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/tags")
public class TagController {

    private final TagRepository tagRepository;

    public TagController(TagRepository tagRepository) {
        this.tagRepository = tagRepository;
    }

    @GetMapping
    public ResponseEntity<List<TagDto>> listTags() {
        List<TagDto> tags = tagRepository.findAllByOrderByNameAsc()
                .stream()
                .map(t -> new TagDto(t.getName(), t.getSlug()))
                .toList();
        return ResponseEntity.ok(tags);
    }
}
