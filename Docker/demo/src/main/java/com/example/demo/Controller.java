package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
@RequestMapping("/devops-bootcamp")
public class Controller
{
    private static final String DEVOPS = "DEVOPS";
    private static final String DEVOPS_ERROR_MESSAGE = "The 'DEVOPS' variable does not exist";

    @GetMapping
    public String getDevopsVariable() {
        return Optional.ofNullable( System.getenv(DEVOPS) ).orElse( DEVOPS_ERROR_MESSAGE );
    }

}
