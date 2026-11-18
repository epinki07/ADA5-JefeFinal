package mx.edu.tecdesoftware.market_backend.persistence.web.controller;

import mx.edu.tecdesoftware.market_backend.domain.service.ShoppingAssistantService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/assistant")
public class AssistantController {
    private final ShoppingAssistantService assistantService;

    public AssistantController(ShoppingAssistantService assistantService) {
        this.assistantService = assistantService;
    }

    @PostMapping
    public AnswerResponse answer(@RequestBody QuestionRequest request) {
        return new AnswerResponse(assistantService.answer(request.question()));
    }

    public record QuestionRequest(String question) {}

    public record AnswerResponse(String answer) {}
}
