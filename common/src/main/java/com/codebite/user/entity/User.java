package com.codebite.user.entity;

import com.codebite.common.base.BaseEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;

@Entity
@Table(name = "users")
public class User extends BaseEntity {

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "password_hash")
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Role role = Role.USER;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Column(name = "recent_language", length = 20)
    private String recentLanguage;

    @Column(name = "editor_settings", columnDefinition = "TEXT")
    private String editorSettings;

    @Column(name = "theme_preference", length = 10)
    private String themePreference;

    @Column(length = 10)
    private String locale = "ko";

    @Column(length = 10)
    private String curation = "CB100";

    @Column(name = "single_page")
    private Boolean singlePage = true;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getRecentLanguage() {
        return recentLanguage;
    }

    public void setRecentLanguage(String recentLanguage) {
        this.recentLanguage = recentLanguage;
    }

    public String getEditorSettings() {
        return editorSettings;
    }

    public void setEditorSettings(String editorSettings) {
        this.editorSettings = editorSettings;
    }

    public String getThemePreference() {
        return themePreference;
    }

    public void setThemePreference(String themePreference) {
        this.themePreference = themePreference;
    }

    public String getLocale() {
        return locale;
    }

    public void setLocale(String locale) {
        this.locale = locale;
    }

    public String getCuration() {
        return curation;
    }

    public void setCuration(String curation) {
        this.curation = curation;
    }

    public Boolean getSinglePage() {
        return singlePage;
    }

    public void setSinglePage(Boolean singlePage) {
        this.singlePage = singlePage;
    }
}
