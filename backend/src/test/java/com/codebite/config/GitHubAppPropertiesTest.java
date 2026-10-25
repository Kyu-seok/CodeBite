package com.codebite.config;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class GitHubAppPropertiesTest {

    @Test
    void solutionRepositoryTemplateSplitsIntoOwnerAndName() {
        GitHubAppProperties properties = new GitHubAppProperties();
        properties.setSolutionRepositoryTemplate("Kyu-seok/codebite-solutions-template");

        assertThat(properties.solutionRepositoryTemplateOwner()).isEqualTo("Kyu-seok");
        assertThat(properties.solutionRepositoryTemplateName()).isEqualTo("codebite-solutions-template");
    }

    @Test
    void solutionRepositoryTemplateMustBeOwnerSlashName() {
        GitHubAppProperties properties = new GitHubAppProperties();

        assertThatThrownBy(() -> properties.setSolutionRepositoryTemplate("codebite-solutions-template"))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> properties.setSolutionRepositoryTemplate("Kyu-seok/"))
                .isInstanceOf(IllegalArgumentException.class);
        assertThatThrownBy(() -> properties.setSolutionRepositoryTemplate("a/b/c"))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void blankSolutionRepositoryTemplateMeansNone() {
        GitHubAppProperties properties = new GitHubAppProperties();
        properties.setSolutionRepositoryTemplate("");

        assertThat(properties.hasSolutionRepositoryTemplate()).isFalse();
    }
}
