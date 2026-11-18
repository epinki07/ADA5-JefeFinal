package mx.edu.tecdesoftware.market_backend.domain.service;

public class AssistantUnavailableException extends RuntimeException {
    public AssistantUnavailableException(String message) {
        super(message);
    }
}
